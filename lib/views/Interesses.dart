import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/main.dart';
import 'package:encontrei_pet/views/widgets/ItemAnuncio.dart';
import 'package:encontrei_pet/views/widgets/ItemInteresse.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Anuncio.dart';
import '../models/Interesse.dart';
import '../util/Configuracoes.dart';

class Interesses extends StatefulWidget {

  Anuncio anuncio;
  Interesses(this.anuncio);

  @override
  State<Interesses> createState() => _InteressesState();
}

class _InteressesState extends State<Interesses> {

  late Anuncio _anuncio;

  final _controler = StreamController<QuerySnapshot>.broadcast();
  late String _idUsuarioLogado;

  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

  }

  String? _telefoneUsuarioInteressado;

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Stream<QuerySnapshot>?> _adicionarListenerInteresses() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      final uid = usuarioLogado.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;
      Stream<QuerySnapshot> stream = db
          .collection("anuncios")
          .doc(_anuncio.id)
          .collection("interesse")
          .orderBy("dataCadastro", descending: true)
          .snapshots();
      stream.listen((dados) {
        _controler.add(dados);

        for (var doc in dados.docs) {
          var idUsuarioInteressado = doc["idUsuarioInteressado"];
          var usuarioRef = FirebaseFirestore.instance.collection("usuarios").doc(idUsuarioInteressado);
          usuarioRef.get().then((usuarioSnap) async {
          _telefoneUsuarioInteressado = usuarioSnap.data()?["telefone"];


          });
        }
      });
    }
  }

  // // Exemplo de ligação
  // _ligarTelefone(_telefoneUsuarioInteressado) async {
  //   if( await canLaunch("tel:$_telefoneUsuarioInteressado") ){
  //     await launch("tel:$_telefoneUsuarioInteressado");
  //   }else{
  //     print("Não pode fazer a ligação");
  //   }
  // }

  _ligarTelefone(String _telefoneUsuarioInteressado) async {
    var formattedNumber = "+55" + _telefoneUsuarioInteressado.replaceAll(new RegExp(r'[^\+\d]'), "");
    var url = "tel:$formattedNumber";
    if (await canLaunch(url)){
      await launch(url);
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text("Não foi possível realizar a ligação"),
            actions: <Widget>[
              MaterialButton(
                child: Text("OK"),
                onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
          },
      );
    }
  }

  // _abrirWhatsApp(String _telefoneUsuarioInteressado) async {
  //   var formattedNumber = "+55" + _telefoneUsuarioInteressado.replaceAll(new RegExp(r'[^\d]'), "");
  //   var url = "whatsapp:$formattedNumber";
  //   if (await canLaunch(url)){
  //     await launch(url);
  //   }else{
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Erro"),
  //           content: Text("Não foi possível abrir o WhatsApp"),
  //           actions: <Widget>[
  //             MaterialButton(
  //               child: Text("OK"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _anuncio = widget.anuncio;
    _adicionarListenerInteresses();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando interesses...",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Interessados",
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,

      ),
      body: Container(
        child: Column(
          children: <Widget>[

            //LISTAGEM DE INTERESSES
            StreamBuilder(
              stream: _controler.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot =
                    snapshot.data as QuerySnapshot;

                    if (querySnapshot.docs.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Nenhum interessado!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> interesses =
                            querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot =
                            interesses[indice];
                            Interesse interesse =
                            Interesse.fromDocumentSnapshot(documentSnapshot);

                            return ItemInteresse(
                              interesse: interesse,


                              //LIGAR
                              onPressedLigacao: (){
                                _ligarTelefone(_telefoneUsuarioInteressado!);
                              },

                              // //WHATSAPP
                              // onPressedWhats: (){
                              //   _abrirWhatsApp(_telefoneUsuarioInteressado!);
                              // },

                            );
                          }),
                    );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
