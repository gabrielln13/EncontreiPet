import 'dart:ffi';

import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  final List<File> _listaImagens = [];
  final List<DropdownMenuItem<Int>> _listaItensDropEstados = [];
  final List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final _formKey = GlobalKey<FormState>();

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
  }
  
  _carregarItensDropdown(){
    
    //Estados
    _listaItensDropEstados.add(
      DropdownMenuItem(child: Text("São Paulo"), value: 1,)
    );
    _listaItensDropEstados.add(
        DropdownMenuItem(child: Text("Minas Gerais"), value: 2,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Novo Anúncio"),
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
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            hint: Text("Estados"),
                            items: _listaItensDropEstados,
                            onChanged: (valor){

                            },
                          )
                        )
                    ),
                    Text("Categoria"),
                  ],
                ),
                //Caixas de textos e botões
                Text("Caixas de textos"),
                BotaoCustomizado(
                  texto: "Cadastrar Anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
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
