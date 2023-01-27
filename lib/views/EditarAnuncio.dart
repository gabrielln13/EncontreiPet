import 'dart:math';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';
import 'package:flutter/services.dart';
import '../models/Anuncio.dart';
import '../util/Configuracoes.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class EditarAnuncio extends StatefulWidget {
  final String idAnuncio;
  const EditarAnuncio({Key? key, required this.idAnuncio}) : super(key: key);

  @override
  State<EditarAnuncio> createState() => _EditarAnuncioState();
}

class _EditarAnuncioState extends State<EditarAnuncio> {

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _racaController = TextEditingController();
  TextEditingController _corController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _doencaController = TextEditingController();
  TextEditingController _vacinacaoController = TextEditingController();

  List<File> _listaImagens = [];
  // List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropPorte = [];
  List<DropdownMenuItem<String>> _listaItensDropEspecie = [];
  List<DropdownMenuItem<String>> _listaItensDropTemperamento = [];
  List<DropdownMenuItem<String>> _listaItensDropChip = [];
  List<DropdownMenuItem<String>> _listaItensDropSexo = [];
  List<DropdownMenuItem<String>> _listaItensDropSituacao = [];
  final _formKey = GlobalKey<FormState>();
  late Anuncio _anuncio;
  late BuildContext _dialogContext;

  // String? _itemSelecionadoEstado;
  String? _itemSelecionadoPorte;
  String? _itemSelecionadoEspecie;
  String? _itemSelecionadoTemperamento;
  String? _itemSelecionadoChip;
  String? _itemSelecionadoSexo;
  String? _itemSelecionadoSituacao;


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
                Text("Salvando edição do anúncio...")
              ],),
          );
        }
    );

  }

  _carregarItensDropdown(){

    //Lista de itens PORTE
    _listaItensDropPorte = Configuracoes.getPorte();
    //Lista de itens ESPECIE
    _listaItensDropEspecie = Configuracoes.getEspecie();
    //Lista de itens TEMPERAMENTO
    _listaItensDropTemperamento = Configuracoes.getTemperamento();
    //Lista de itens CHIP
    _listaItensDropChip = Configuracoes.getChip();
    //Lista de itens SEXO
    _listaItensDropSexo = Configuracoes.getSexo();
    //Lista de itens SITUAÇÃO
    _listaItensDropSituacao = Configuracoes.getSituacao();

  }

  _recuperarAnuncio() async {
    // print('id@debug > ${widget.idAnuncio}');

    // FirebaseFirestore db  = FirebaseFirestore.instance;
    // db.collection('anucios').doc(widget.idAnuncio).get();
    var anuncio = await FirebaseFirestore.instance
        .collection("anuncios")
        .doc(widget.idAnuncio)
        .get();

    _anuncio = await Anuncio.fromDocumentSnapshot(anuncio);
    setState(() {
      carregarCampos();
    });
    if (_anuncio.fotos != null) {
      _listaImagens = await _carregarImagensAnuncio(_anuncio.fotos);
    }
    // atualiza a tela
    setState(() {});
  }

  carregarCampos() async {
    _nomeController.text = _anuncio.nome;
    _racaController.text = _anuncio.raca;
    _corController.text = _anuncio.cor;
    _descricaoController.text = _anuncio.descricao;
    _idadeController.text = _anuncio.idade;
    _doencaController.text = _anuncio.doenca;
    _vacinacaoController.text = _anuncio.vacinacao;
    _itemSelecionadoEspecie = _anuncio.especie;
    _itemSelecionadoTemperamento = _anuncio.temperamento;
    _itemSelecionadoChip = _anuncio.chip;
    _itemSelecionadoPorte = _anuncio.porte;
    _itemSelecionadoSexo = _anuncio.sexo;
    _itemSelecionadoSituacao = _anuncio.situacao;
    _listaImagens = await _carregarImagensAnuncio(_anuncio.fotos);
    print('debug:::: >>>>  $_listaImagens');
  }

   _carregarImagensAnuncio(List<String> urls) async {
    List<File> _listaImagens = [];
    for (var url in urls) {
      _listaImagens.add(await urlToFile(url));
    }
    return _listaImagens;
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }







  _atualizarAnuncio() async {

    _abrirDialog( _dialogContext );

    List<String> novaListaImagens = await _uploadImagens();
    _anuncio.fotos = novaListaImagens;

    if (_formKey.currentState!.validate()) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? usuarioLogado = await auth.currentUser!;
      String idUsuarioLogado = usuarioLogado.uid;

      _anuncio.dataCadastro = Timestamp.fromDate(DateTime.now());
      _anuncio.idUsuario = idUsuarioLogado;

      await FirebaseFirestore.instance
          .collection("meus_anuncios")
          .doc(idUsuarioLogado)
          .collection("anuncios")
          .doc(_anuncio.id)
          .update(_anuncio.toMap());

      await FirebaseFirestore.instance
          .collection("anuncios")
          .doc(_anuncio.id)
          .update(_anuncio.toMap());


      Navigator.pop(_dialogContext);

      Navigator.pop(context);


    };
  }

  _uploadImagens() async {
    List<String> listaUrls = [];
    for (var imagem in _listaImagens) {
      var url = await _uploadImagem(imagem);
      listaUrls.add(url);
    }
    return listaUrls;
  }

  // _uploadImagem(File imagem) async {
  //   var nomeImagem = "${DateTime.now().millisecondsSinceEpoch}";
  //   var caminhoRelativo = path.joinAll(['meus_anuncios',_anuncio.id, nomeImagem]);
  //   var ref = FirebaseStorage.instance.ref().child(caminhoRelativo);
  //   var uploadTask = ref.putFile(imagem);
  //
  //   var url = await (await uploadTask).ref.getDownloadURL();
  //   return url;
  // }


  _uploadImagem(File imagem) async {
    var nomeImagem = "${DateTime.now().millisecondsSinceEpoch}";
    var caminhoRelativo = path.joinAll(['meus_anuncios',_anuncio.id, nomeImagem]);
    var ref = FirebaseStorage.instance.ref().child(caminhoRelativo);
    var imageBytes = await FlutterImageCompress.compressWithFile(
        imagem.absolute.path,
        minWidth: 500,
        minHeight: 500,
        quality: 85,
        rotate: 0
    );
    var uploadTask = ref.putData(imageBytes!);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }


  _removerImagem(int index) {
    setState(() {
      _listaImagens.removeAt(index);
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarItensDropdown();
    _recuperarAnuncio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Editar Anúncio",
          style: GoogleFonts.lato( textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //área de imagens
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

                //SITUAÇÃO CADASTRO
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoSituacao,
                          hint: Text("Situação"),
                          onSaved: (situacao){
                            _anuncio.situacao = situacao.toString();
                          },
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:16
                          ),
                          ),
                          items: _listaItensDropSituacao,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoSituacao = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                //SITUAÇÃO ESPECIE
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEspecie,
                          hint: Text("Espécie"),
                          onSaved: (especie){
                            _anuncio.especie = especie.toString();
                          },
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:16
                          ),
                          ),
                          items: _listaItensDropEspecie,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoEspecie = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // COMBO PORTE
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoPorte,
                          hint: Text("Porte"),
                          onSaved: (porte){
                            _anuncio.porte = porte.toString();
                          },
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:16
                          ),
                          ),
                          items: _listaItensDropPorte,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoPorte = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),


                // COMBO TEMPERAMENTO
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoTemperamento,
                          hint: Text("Temperamento"),
                          onSaved: (temperamento){
                            _anuncio.temperamento = temperamento.toString();
                          },
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:16
                          ),
                          ),
                          items: _listaItensDropTemperamento,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoTemperamento = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // COMBO CHIP
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoChip,
                          hint: Text("Possiu Chip?"),
                          onSaved: (chip){
                            _anuncio.chip = chip.toString();
                          },
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:16
                          ),
                          ),
                          items: _listaItensDropChip,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoChip = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // COMBO SEXO
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoSexo,
                          hint: Text("Sexo"),
                          onSaved: (sexo){
                            _anuncio.sexo = sexo.toString();
                          },
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              color: Colors.black,
                              fontSize:16
                          ),
                          ),
                          items: _listaItensDropSexo,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoSexo = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                //Caixas de textos e botões
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    labelText: "Nome",
                    controller: _nomeController,
                    hint: "Nome",
                    onSaved: (nome){
                      _anuncio.nome = nome.toString();
                    },
                    maxLines: 1,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _corController,
                    labelText: "Cor",
                    hint: "Cor",
                    onSaved: (cor){
                      _anuncio.cor = cor.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.text,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _racaController,
                    labelText: "Raça",
                    hint: "Raça",
                    onSaved: (raca){
                      _anuncio.raca = raca.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.text,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _idadeController,
                    labelText: "Idade",
                    hint: "Idade Aproximada",
                    onSaved: (idade){
                      _anuncio.idade = idade.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.number,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _vacinacaoController,
                    labelText: "Vacinação",
                    hint: "Vacinação (Descreva as vacinas)",
                    onSaved: (vacinacao){
                      _anuncio.vacinacao = vacinacao.toString();
                    },
                    maxLines: null,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _doencaController,
                    labelText: "Doenças",
                    hint: "Doenças (Descreva as doenças, se houver)",
                    onSaved: (doenca){
                      _anuncio?.doenca = doenca.toString();
                    },
                    maxLines: null,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _descricaoController,
                    labelText: "Descrição",
                    hint: "Descrição (Campo livre)",
                    onSaved: (descricao){
                      _anuncio?.descricao = descricao.toString();
                    },
                    maxLines: null,
                  ),
                ),

                BotaoCustomizado(
                  texto: "Editar Anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      //Salvar campos
                      _formKey.currentState?.save();

                      //Limpar formulário
                      _formKey.currentState?.reset();

                      //Configura dialog context
                      _dialogContext = context;

                      //Salvar anuncio
                      _atualizarAnuncio();
                      _formKey.currentState?.reset();

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
