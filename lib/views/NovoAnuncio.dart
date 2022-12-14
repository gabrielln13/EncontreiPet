import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';
import 'package:flutter/services.dart';
import '../models/Anuncio.dart';
import '../util/Configuracoes.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

TextEditingController _tituloController = TextEditingController();
TextEditingController _precoController = TextEditingController();
TextEditingController _telefoneController = TextEditingController();
TextEditingController _descricaoController = TextEditingController();

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<File> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final _formKey = GlobalKey<FormState>();
  late Anuncio _anuncio;
  late BuildContext _dialogContext;

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  final picker = ImagePicker();
  File? imagemSelecionada;

  _selecionarImagemGaleria() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imagemSelecionada = File(pickedFile!.path);

    if(imagemSelecionada != null){
      setState(() {
        _listaImagens.add(imagemSelecionada!);
      });
    }
  }

  _abrirDialog(BuildContext context){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando an??ncio...")
              ],),
          );
        }
    );

  }

  _salvarAnuncio() async{

    _abrirDialog( _dialogContext );

    //uploud imagens no storage
    await _uploadImagens();

    //Salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser!;
    String idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap()).then((_) {

      //salvar an??ncio p??blico
      db.collection("anuncios")
          .doc( _anuncio.id )
          .set( _anuncio.toMap() ).then((_){

      Navigator.pop(_dialogContext);

      Navigator.pop(context);
    });

    });
  }

  Future _uploadImagens() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for(var imagem in _listaImagens){
      String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarItensDropdown();

    _anuncio = Anuncio.gerarId();

  }

  _carregarItensDropdown(){

    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Novo An??ncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //??rea de imagens
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens!.length == 0) {
                      return "Selecione uma imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(children: <Widget>[
                      Container(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1,
                            itemBuilder: (context, indice) {
                              if (indice == _listaImagens.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: Colors.grey[100],
                                        ),
                                        Text (
                                          "Adicionar",
                                          style: TextStyle(
                                            color: Colors.grey[100]
                                          ),
                                        )
                                      ],),
                                    ),
                                  ),
                                );
                              }

                              if (_listaImagens.length > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                              Image.file(_listaImagens[indice]),
                                              TextButton(
                                                child: Text("Excluir",
                                                  style: TextStyle(color: Colors.red)),
                                                onPressed: (){
                                                  setState(() {
                                                    _listaImagens.removeAt(indice);
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              )
                                            ],),
                                          )
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(_listaImagens[indice]),
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            }
                        ),
                      ),
                      if(state.hasError)
                        Container(
                            child: Text(
                                "[${state.errorText}]",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14
                                )
                            )
                        )
                    ],);
                  },
                ),
                //menus dropdown
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            value: _itemSelecionadoEstado,
                            hint: Text("Estados"),
                            onSaved: (estado){
                              _anuncio.estado = estado.toString();
                            },
                            style: TextStyle(
                            color: Colors.black,
                            fontSize:20
                          ),
                            items: _listaItensDropEstados,
                            validator: (valor){
                              return Validador()
                                  .add(Validar.OBRIGATORIO, msg: "Campo Obrigat??rio")
                                  .valido(valor as String);
                            },
                            onChanged: (valor){
                              setState(() {
                                _itemSelecionadoEstado = valor as String;
                              });
                            },
                          ),
                        ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: Text("Categorias"),
                          onSaved: (categoria){
                            _anuncio..categoria = categoria.toString();
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:20
                          ),
                          items: _listaItensDropCategorias,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigat??rio")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoCategoria = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //Caixas de textos e bot??es

                Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    controller: _tituloController,
                    hint: "T??tulo",
                    onSaved: (titulo){
                      _anuncio.titulo = titulo.toString();
                    },
                    maxLines: 1,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigat??rio")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _precoController,
                    hint: "Pre??o",
                    onSaved: (preco){
                      _anuncio.preco = preco.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(casasDecimais: 2),
                    ],
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigat??rio")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _telefoneController,
                    hint: "Telefone",
                    onSaved: (telefone){
                      _anuncio.telefone = telefone.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigat??rio")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _descricaoController,
                    hint: "Descri????o",
                    onSaved: (descricao){
                      _anuncio.descricao = descricao.toString();
                    },
                    maxLines: null,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigat??rio")
                      .maxLength(200, msg: "M??ximo de 200 caracteres")
                          .valido(valor as String);
                    },
                  ),
                ),

                BotaoCustomizado(
                  texto: "Cadastrar An??ncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      //Salvar campos
                      _formKey.currentState?.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //Salvar anuncio
                      _salvarAnuncio();

                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
