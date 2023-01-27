import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/views/EditarAnuncio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encontrei_pet/models/Anuncio.dart';
import 'package:encontrei_pet/views/widgets/ItemAnuncio.dart';
import 'package:google_fonts/google_fonts.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  late Anuncio _anuncio;

  final _controller = StreamController<QuerySnapshot>.broadcast();
  late String _idUsuarioLogado;

  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {

    await _recuperaDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc( _idUsuarioLogado )
        .collection("anuncios")
        .orderBy("dataCadastro", descending: true)
        .snapshots();

    stream.listen((dados){
      _controller.add( dados );
    });

  }

  _removerAnuncio(String idAnuncio){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
        .doc( _idUsuarioLogado )
        .collection("anuncios")
        .doc( idAnuncio )
        .delete().then((_){

      db.collection("anuncios")
          .doc(idAnuncio)
          .delete();

    });

  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[
        Text("Carregando anúncios",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),),
        CircularProgressIndicator()
      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Anúncios",
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
      floatingActionButton: FloatingActionButton(
//         //backgroundColor: Color.fromARGB(250, 255, 179, 0),
         foregroundColor: Colors.white,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
         child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, "/novo-anuncio");
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        // stream: db.collection("anuncios").orderBy(
        //     "dataCadastro", descending: true).snapshots(),
        builder: (context, snapshot){

          switch( snapshot.connectionState ){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:

            //Exibe mensagem de erro
              if(snapshot.hasError) {
                return Text("Erro ao carregar os dados!",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),),);
              }

              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

              if( querySnapshot.docs.length == 0 ){
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(25),
                  child: Text("Nenhum anúncio!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),),
                );
              }

              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, indice){

                    List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[indice];
                    Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                    return ItemAnuncio(
                      anuncio: anuncio,

                      //IR PARA TELA DE INTERESSADOS
                      onTapItem: (){
                        Navigator.pushNamed(
                            context, "/interesses",
                            arguments: anuncio
                        );
                      },

                      //EDITAR ANÚNCIO
                      onPressedEditar: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarAnuncio(idAnuncio: anuncio.id,)
                            )
                        );
                      },

                      //REMOVER ANÚNCIO
                      onPressedRemover: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("Deseja realmente excluir o anúncio?"),
                                actions: <Widget>[

                                  MaterialButton(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                  MaterialButton(
                                    //color: Colors.red,
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(
                                          color: Colors.red
                                      ),
                                    ),
                                    onPressed: (){
                                      _removerAnuncio( anuncio.id );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      },
                    );
                  }
              );
          }

          return Container();

        },
      ),
    );
  }
}