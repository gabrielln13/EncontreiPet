import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/main.dart';
import 'package:encontrei_pet/views/widgets/ItemAnuncio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Anuncio.dart';
import '../util/Configuracoes.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {

  List<String> itensMenu = [];
  late List<DropdownMenuItem<String>> _listaItensDropCategorias;
  late List<DropdownMenuItem<String>> _listaItensDropEstados;

  final _controler = StreamController<QuerySnapshot>.broadcast();

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){

      case "Meus Anúncios" :
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Logar / Cadastrar Usuário":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }

  }

  _deslogarUsuario() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamed(context, "/login");
  }

  Future _verificaUsuarioLogado() async{
    
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if(usuarioLogado == null){
      itensMenu = [
        "Logar / Cadastrar Usuário"
      ];
    }else{
      itensMenu = [
        "Meus Anúncios",
        "Deslogar"
      ];
    }
  }

  _carregarItensDropdown(){

    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();

  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    stream.listen((dados){
      _controler.add(dados);
    });

  }

  Future<Stream<QuerySnapshot>?> _filtrarAnuncios() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");

    if( _itemSelecionadoEstado != null ){
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }
    if( _itemSelecionadoCategoria != null ){
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados){
      _controler.add(dados);
    });

  }

  @override
  void initState(){
    super.initState();

    _carregarItensDropdown();
    _verificaUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[

        Text("Carregando anúncios..."),
        CircularProgressIndicator()
      ],

      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Encontrei Pet"),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem <String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[

          //Filtros
          Row(children: <Widget>[
            Expanded(
              child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: temaPadrao.primaryColor,
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),
                      onChanged: (estado){
                        setState(() {
                          _itemSelecionadoEstado = estado as String?;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  )
              ),
            ),

            Container(
              color: Colors.grey[200],
              width: 2,
              height: 60,
            ),

            Expanded(
              child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: temaPadrao.primaryColor,
                      value: _itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),
                      onChanged: (categoria){
                        setState(() {
                          _itemSelecionadoCategoria = categoria as String?;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  )
              ),
            )



          ],),
          //Listagem de anúncios
          StreamBuilder(
            stream: _controler.stream,
            builder: (context, snapshot){
              switch( snapshot.connectionState ){
                case ConnectionState.none:
                case ConnectionState.waiting:
                return carregandoDados;
                break;
                case ConnectionState.active:
                case ConnectionState.done:

                  QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

                  if( querySnapshot.docs.length == 0 ){
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Text("Nenhum anúncio!", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, indice){

                          List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = anuncios[indice];
                          Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                          return ItemAnuncio(
                            anuncio: anuncio,
                            onTapItem: (){
                              Navigator.pushNamed(
                                  context, "/detalhes-anuncio",
                                arguments: anuncio
                              );
                            },
                          );

                        }
                    ),
                  );

              }
              return Container();
            },
          )

        ],),
      ),
    );
  }
}