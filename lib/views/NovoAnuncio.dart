import 'dart:convert';

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
import '../main.dart';
import '../models/Anuncio.dart';
import '../util/Configuracoes.dart';
import 'package:path/path.dart' as path;
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

TextEditingController _nomeController = TextEditingController();
TextEditingController _racaController = TextEditingController();
TextEditingController _corController = TextEditingController();
TextEditingController _descricaoController = TextEditingController();
TextEditingController _idadeController = TextEditingController();
TextEditingController _doencaController = TextEditingController();
TextEditingController _vacinacaoController = TextEditingController();
TextEditingController _cepController = TextEditingController();
TextEditingController _cidadeController = TextEditingController();
TextEditingController _bairroController = TextEditingController();
TextEditingController _logradouroController = TextEditingController();
TextEditingController _quadraController = TextEditingController();
TextEditingController _numeroController = TextEditingController();
TextEditingController _loteController = TextEditingController();
TextEditingController _numeroChipController = TextEditingController();

class _NovoAnuncioState extends State<NovoAnuncio> {
  List<File> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropPorte = [];
  List<DropdownMenuItem<String>> _listaItensDropEspecie = [];
  List<DropdownMenuItem<String>> _listaItensDropTemperamento = [];
  List<DropdownMenuItem<String>> _listaItensDropChip = [];
  List<DropdownMenuItem<String>> _listaItensDropSexo = [];
  List<DropdownMenuItem<String>> _listaItensDropSituacao = [];
  final _formKey = GlobalKey<FormState>();
  late Anuncio _anuncio;
  late BuildContext _dialogContext;

  String? _itemSelecionadoEstado = 'GO';
  String? _itemSelecionadoPorte;
  String? _itemSelecionadoEspecie;
  String? _itemSelecionadoTemperamento;
  String? _itemSelecionadoChip;
  String? _itemSelecionadoSexo;
  String? _itemSelecionadoSituacao = 'Disponível';

  final picker = ImagePicker();
  File? imagemSelecionada;

  _selecionarImagemGaleria() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imagemSelecionada = File(pickedFile!.path);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada!);
      });
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Salvando anúncio...")
              ],
            ),
          );
        });
  }

  // _buscarCep() async {
  //   String cep = _cepController.text;
  //   if (cep.isEmpty) {
  //     return;
  //   }
  //
  //   String url = "https://viacep.com.br/ws/${cep}/json/";
  //
  //   http.Response response;
  //   response = await http.get(Uri.parse(url),
  //       headers: {"Content-Type": "text/json; charset=utf-8"});
  //   Map<String, dynamic> dados = json.decode(response.body);
  //   _cidadeController.text = dados['localidade'];
  //   _bairroController.text = dados['bairro'];
  //   _logradouroController.text = dados['logradouro'];
  //   _itemSelecionadoEstado = dados['uf'];
  //
  // }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext);

    //uploud imagens no storage
    await _uploadImagens();

    //Salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser!;
    String idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    _anuncio.dataCadastro = Timestamp.fromDate(DateTime.now());
    _anuncio.idUsuario = idUsuarioLogado;
    db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap())
        .then((_) {
      //salvar anúncio público
      db
          .collection("anuncios")
          .doc(_anuncio.id)
          .set(_anuncio.toMap())
          .then((_) {
        Navigator.pop(_dialogContext);

        Navigator.pop(context);
      });
    });
  }

  // Future _uploadImagens() async{
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference pastaRaiz = storage.ref();
  //
  //   for(var imagem in _listaImagens){
  //     String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
  //     Reference arquivo = pastaRaiz
  //         .child("meus_anuncios")
  //         .child(_anuncio.id)
  //         .child(nomeImagem);
  //
  //     UploadTask uploadTask = arquivo.putFile(imagem);
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //
  //     String url = await taskSnapshot.ref.getDownloadURL();
  //     _anuncio.fotos.add(url);
  //
  //   }
  //
  // }

  // Future _uploadImagens() async{
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   for(var imagem in _listaImagens){
  //     String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
  //     String caminhoRelativo = path.joinAll(['meus_anuncios',_anuncio.id, nomeImagem]);
  //     Reference arquivo = storage.ref().child(caminhoRelativo);
  //     UploadTask uploadTask = arquivo.putFile(imagem);
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //
  //     String url = await taskSnapshot.ref.getDownloadURL();
  //     _anuncio.fotos.add(url);
  //   }
  // }

  Future<void> _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
      String caminhoRelativo =
          path.joinAll(['meus_anuncios', _anuncio.id, nomeImagem]);
      Reference arquivo = storage.ref().child(caminhoRelativo);
      var imageBytes = await FlutterImageCompress.compressWithFile(
        imagem.path,
        minWidth: 500,
        minHeight: 500,
        quality: 85,
        rotate: 0,
      );
      UploadTask uploadTask =
          arquivo.putData(Uint8List.fromList(imageBytes as List<int>));
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

  _carregarItensDropdown() {
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
    //Lista de itens ESTADOS
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Novo Anúncio",
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                  color: Colors.grey[100]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                if (_listaImagens.length > 0) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Image.file(_listaImagens[
                                                          indice]),
                                                      TextButton(
                                                          child: Text("Excluir",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                          onPressed: () {
                                                            setState(() {
                                                              _listaImagens
                                                                  .removeAt(
                                                                      indice);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[indice]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(Icons.delete,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Container(
                              child: Text("[${state.errorText}]",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14)))
                      ],
                    );
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
                          onSaved: (situacao) {
                            _anuncio.situacao = situacao.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropSituacao,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
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
                          onSaved: (especie) {
                            _anuncio.especie = especie.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropEspecie,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
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
                          onSaved: (porte) {
                            _anuncio.porte = porte.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropPorte,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
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
                          onSaved: (temperamento) {
                            _anuncio.temperamento = temperamento.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropTemperamento,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
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
                          onSaved: (chip) {
                            _anuncio.chip = chip.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropChip,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
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
                          onSaved: (sexo) {
                            _anuncio.sexo = sexo.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropSexo,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
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
                    upperFirstLetter: true,
                    controller: _nomeController,
                    hint: "Nome*",
                    onSaved: (nome) {
                      _anuncio.nome = nome.toString();
                    },
                    maxLines: 1,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _corController,
                    hint: "Cor*",
                    onSaved: (cor) {
                      _anuncio.cor = cor.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.text,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _racaController,
                    hint: "Raça*",
                    onSaved: (raca) {
                      _anuncio.raca = raca.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.text,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _idadeController,
                    hint: "Idade Aproximada*",
                    onSaved: (idade) {
                      _anuncio.idade = idade.toString();
                    },
                    maxLines: 1,
                    type: TextInputType.number,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _numeroChipController,
                    hint: "Código do Chip (Caso possua)",
                    onSaved: (numeroChip) {
                      _anuncio.numeroChip = numeroChip.toString();
                    },
                    maxLines: 1,
                    // type: TextInputType.number,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                    //       .valido(valor as String);
                    // },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _vacinacaoController,
                    hint: "Vacinação* (Descreva as vacinas)",
                    onSaved: (vacinacao) {
                      _anuncio.vacinacao = vacinacao.toString();
                    },
                    maxLines: null,
                    validator: (valor) {
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
                    upperFirstLetter: true,
                    controller: _doencaController,
                    hint: "Doenças (Descreva as doenças, se houver)",
                    onSaved: (doenca) {
                      _anuncio.doenca = doenca.toString();
                    },
                    maxLines: null,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                    //       .maxLength(200, msg: "Máximo de 200 caracteres")
                    //       .valido(valor as String);
                    // },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                Text(
                  "Endereço",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),

                //ENDEREÇO
                //COMBO UF
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: Text("UF"),
                          onSaved: (uf) {
                            _anuncio.uf = uf.toString();
                          },
                          style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: _listaItensDropEstados,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                //CEP
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _cepController,
                    hint: "CEP",
                    onSaved: (cep){
                      _anuncio.cep = cep.toString();
                    },
                    maxLines: null,
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter()
                    ],
                  ),
                ),

                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.all(8),
                //         child: InputCustomizado(
                //           upperFirstLetter: false,
                //           controller: _cepController,
                //           hint: "CEP*",
                //           onSaved: (cep) {
                //             _anuncio.cep = cep.toString();
                //           },
                //           maxLines: null,
                //           inputFormatters: [
                //             FilteringTextInputFormatter.digitsOnly,
                //             CepInputFormatter()
                //           ],
                //           validator: (valor) {
                //             return Validador()
                //                 .add(Validar.OBRIGATORIO,
                //                     msg: "Campo Obrigatório")
                //                 .valido(valor as String);
                //           },
                //         ),
                //       ),
                //     ),
                //     IconButton(
                //       icon: Icon(Icons.search),
                //       onPressed: () {
                //         // Implemente a lógica de busca de CEP aqui
                //         _buscarCep();
                //       },
                //     )
                //   ],
                // ),

                //Cidade
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _cidadeController,
                    hint: "Cidade*",
                    onSaved: (cidade) {
                      _anuncio.cidade = cidade.toString();
                    },
                    maxLines: null,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                //Bairro
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _bairroController,
                    hint: "Bairro*",
                    onSaved: (bairro) {
                      _anuncio.bairro = bairro.toString();
                    },
                    maxLines: null,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                //Logradouro
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _logradouroController,
                    hint: "Logradouro*",
                    onSaved: (logradouro) {
                      _anuncio.logradouro = logradouro.toString();
                    },
                    maxLines: null,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor as String);
                    },
                  ),
                ),

                //Quadra
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _quadraController,
                    hint: "Quadra",
                    onSaved: (quadra) {
                      _anuncio.quadra = quadra.toString();
                    },
                    maxLines: null,
                    type: TextInputType.number,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                    //       .valido(valor as String);
                    // },
                  ),
                ),

                //Lote
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _loteController,
                    hint: "Lote",
                    onSaved: (lote) {
                      _anuncio.lote = lote.toString();
                    },
                    maxLines: null,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                    //       .valido(valor as String);
                    // },
                  ),
                ),

                //Numero
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _numeroController,
                    hint: "Número",
                    onSaved: (numero) {
                      _anuncio.numero = numero.toString();
                    },
                    maxLines: null,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                    //       .valido(valor as String);
                    // },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                Text(
                  "Descrição",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),

                //Descrição
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _descricaoController,
                    hint: "Descrição livre",
                    onSaved: (descricao) {
                      _anuncio.descricao = descricao.toString();
                    },
                    maxLines: null,
                    // validator: (valor){
                    //   return Validador()
                    //       .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                    //   .maxLength(200, msg: "Máximo de 200 caracteres")
                    //       .valido(valor as String);
                    // },
                  ),
                ),

                BotaoCustomizado(
                  texto: "Cadastrar Anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //Salvar campos
                      _formKey.currentState?.save();

                      //Limpar formulário
                      _formKey.currentState?.reset();

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
