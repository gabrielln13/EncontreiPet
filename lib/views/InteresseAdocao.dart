// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
// import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:encontrei_pet/main.dart';
// import 'package:encontrei_pet/models/Anuncio.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:validadores/Validador.dart';
//
// import '../models/Interesse.dart';
//
// class InteresseAdocao extends StatefulWidget {
//
//   Anuncio anuncio;
//   InteresseAdocao(this.anuncio);
//
//   @override
//   _InteresseAdocaoState createState() => _InteresseAdocaoState();
// }
//
// TextEditingController _descricaoController = TextEditingController();
//
//
// class _InteresseAdocaoState extends State<InteresseAdocao> {
//
//   final _formKey = GlobalKey<FormState>();
//   late Anuncio _anuncio;
//   late Interesse _interesse;
//   late BuildContext _dialogContext;
//
//   _abrirDialog(BuildContext context){
//
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context){
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 CircularProgressIndicator(),
//                 SizedBox(height: 20,),
//                 Text("Salvando interesse de adoção...")
//               ],),
//           );
//         }
//     );
//
//   }
//
//   _salvarInteresse() async{
//
//     _abrirDialog( _dialogContext );
//
//     //Salvar anuncio no Firestore
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? usuarioLogado = await auth.currentUser!;
//     String idUsuarioLogado = usuarioLogado.uid;
//
//     FirebaseFirestore db = FirebaseFirestore.instance;
//     _interesse.dataCadastro = Timestamp.fromDate(DateTime.now());
//     _interesse.idUsuarioInteressado = idUsuarioLogado;
//     db.collection("interesse")
//         .doc( _interesse.id )
//         .set( _interesse.toMap() ).then((_){
//
//
//         Navigator.pop(_dialogContext);
//
//         Navigator.pop(context);
//       });
//
//   }
//
//   List<Widget> _getListaImagens(){
//
//     List<String> listaUrlImagens = _anuncio.fotos;
//     return listaUrlImagens.map((url){
//       return Container(
//         height: 250,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: NetworkImage(url),
//                 fit: BoxFit.fitWidth
//             )
//         ),
//       );
//     }).toList();
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _anuncio = widget.anuncio;
//     _interesse = Interesse.gerarId();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Manifestar Interesse Adoção"),
//       ),
//       body: Stack(children: <Widget>[
//
//         ListView(children: <Widget>[
//
//           SizedBox(
//             height: 250,
//             child: Carousel(
//               images: _getListaImagens(),
//               dotSize: 8,
//               dotBgColor: Colors.transparent,
//               dotColor: Colors.white,
//               autoplay: false,
//               dotIncreasedColor: temaPadrao.primaryColor,
//             ),
//           ),
//
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//
//                 //NOME
//                 Text(
//                   "${_anuncio.nome}",
//                   style: GoogleFonts.lato( textStyle: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: temaPadrao.primaryColor
//                   ),
//                   ),
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                 ),
//
//                 //IDADE
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Idade:",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       " ${_anuncio.idade} Anos",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                         fontSize: 18,
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                 ),
//
//                 //SEXO
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Sexo:",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       " ${_anuncio.sexo}",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                         fontSize: 18,
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                 ),
//
//                 //RAÇA
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Raça:",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       " ${_anuncio.raca}",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                         fontSize: 18,
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                 ),
//
//                 //COR
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Cor:",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       " ${_anuncio.cor}",
//                       style: GoogleFonts.lato( textStyle: TextStyle(
//                         fontSize: 18,
//                       ),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//
//
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child: Divider(),
//                 ),
//
//                 Text(
//                   "Confirmar Interesse de Adoção?",
//                   style: GoogleFonts.lato(
//                     textStyle: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: temaPadrao.primaryColor
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 15),
//                   child: InputCustomizado(
//                     controller: _descricaoController,
//                     hint: "O que te faz ter interesse na adoção desse pet?",
//                     onSaved: (descricao){
//                       _anuncio.descricao = descricao.toString();
//                     },
//                     maxLines: null,
//                     validator: (valor){
//                       return Validador()
//                           .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
//                       .maxLength(200, msg: "Máximo de 200 caracteres")
//                           .valido(valor as String);
//                     },
//                   ),
//                 ),
//                 BotaoCustomizado(
//                   texto: "Confirmar",
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//
//                       //Salvar campos
//                       _formKey.currentState?.save();
//
//                       //Limpar formulário
//                       _formKey.currentState?.reset();
//
//                       //Configura dialog context
//                       _dialogContext = context;
//
//                       //Salvar anuncio
//                       _salvarInteresse();
//
//                     }
//                   },
//                 ),
//               ],),
//           )
//         ],
//         ),
//
//
//
//       ],),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/models/Interesse.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validadores/Validador.dart';
import '../models/Anuncio.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:mailer/mailer.dart';
import 'dart:io';


class InteresseAdocao extends StatefulWidget {

  Anuncio anuncio;
  InteresseAdocao(this.anuncio);

  @override
  State<InteresseAdocao> createState() => _InteresseAdocaoState();
}

TextEditingController _descricaoController = TextEditingController();

class _InteresseAdocaoState extends State<InteresseAdocao> {

  String _mensagemErro = "";
  final _formKey = GlobalKey<FormState>();
  late Anuncio _anuncio;
  late Interesse _interesse;
  late BuildContext _dialogContext;



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
                Text("Salvando interesse de adoção...")
              ],),
          );
        }
    );

  }

  // _salvarInteresse() async {
  //   _abrirDialog(_dialogContext);
  //
  //
  //   //Salvar anuncio no Firestore
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? usuarioLogado = await auth.currentUser!;
  //   if (usuarioLogado == null) {
  //     // exibir mensagem de erro para o usuário
  //     setState(() {
  //       _mensagemErro = "Favor realizar login para completar essa ação.";
  //     });
  //   } else {
  //     // prosseguir com o código normalmente
  //     String idUsuarioLogado = usuarioLogado.uid;
  //
  //
  //     FirebaseFirestore db = FirebaseFirestore.instance;
  //     _interesse.idAnuncio = _anuncio.id;
  //     _interesse.dataCadastro = Timestamp.fromDate(DateTime.now());
  //     _interesse.idUsuarioInteressado = idUsuarioLogado;
  //     db.collection("interesse")
  //         .doc(idUsuarioLogado)
  //         .collection("anuncios")
  //         .doc(_interesse.id)
  //         .set(_interesse.toMap()).then((_) {
  //       Navigator.pop(_dialogContext);
  //
  //       Navigator.pop(context);
  //     });
  //   }
  // }

  //xZ6SBNlgT9SuXGmiroAk2d8eEaB3
  //eDblsLk1zOplpEaSbqUL

  // _salvarInteresse() async {
  //   _abrirDialog(_dialogContext);
  //
  //   //Salvar anuncio no Firestore
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? usuarioLogado = await auth.currentUser!;
  //   if (usuarioLogado == null) {
  //     // exibir mensagem de erro para o usuário
  //     setState(() {
  //       _mensagemErro = "Favor realizar login para completar essa ação.";
  //     });
  //   } else {
  //     // prosseguir com o código normalmente
  //     String idUsuarioLogado = usuarioLogado.uid;
  //
  //     FirebaseFirestore db = FirebaseFirestore.instance;
  //     _interesse.dataCadastro = Timestamp.fromDate(DateTime.now());
  //     _interesse.idUsuarioInteressado = idUsuarioLogado;
  //     DocumentReference interesseRef = db
  //         .collection("anuncios")
  //         .doc(_anuncio.id)
  //         .collection("interesse")
  //         .doc();
  //
  //     _interesse.id = interesseRef.id;
  //     _interesse.idAnuncio = _anuncio.id;
  //
  //     // Adiciona o interesse na coleção de interesses do anuncio
  //     interesseRef.set(_interesse.toMap());
  //     // Adiciona uma referência do interesse na coleção de interesses do usuário
  //     db.collection("usuarios")
  //         .doc(idUsuarioLogado)
  //         .collection("interesse")
  //         .doc(_interesse.id)
  //         .set({
  //       'idInteresse': _interesse.id,
  //       'idAnuncio': _anuncio.id
  //     }).then((_) {
  //       Navigator.pop(_dialogContext);
  //       Navigator.pop(context);
  //     });
  //   }
  // }


  _salvarInteresse() async {
    _abrirDialog(_dialogContext);
    //Salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser!;
    if (usuarioLogado == null) {
      // exibir mensagem de erro para o usuário
      setState(() {
        _mensagemErro = "Favor realizar login para completar essa ação.";
      });
    } else {
      // prosseguir com o código normalmente
      String idUsuarioLogado = usuarioLogado.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;
      _interesse.dataCadastro = Timestamp.fromDate(DateTime.now());
      _interesse.idUsuarioInteressado = idUsuarioLogado;
      DocumentReference interesseRef = db
          .collection("anuncios")
          .doc(_anuncio.id)
          .collection("interesse")
          .doc();

      _interesse.id = interesseRef.id;
      _interesse.idAnuncio = _anuncio.id;

      // Adiciona o interesse na coleção de interesses do anuncio
      interesseRef.set(_interesse.toMap());
      // Adiciona uma referência do interesse na coleção de interesses do usuário
      db.collection("usuarios")
          .doc(idUsuarioLogado)
          .collection("interesse")
          .doc(_interesse.id)
          .set({
        'idInteresse': _interesse.id,
        'idAnuncio': _anuncio.id
      }).then((_) {
        // Busca o email do usuário que cadastrou o anuncio
        db.collection("usuarios").doc(_anuncio.idUsuario).get().then((document) async {
          var emailUsuarioAnuncio = document.data()!["email"];
          // var nomeUsuarioAnuncio = document.data()!["nome"];

          // Busca o nome do usuário que se interessou no anuncio
          db.collection("usuarios").doc(_interesse.idUsuarioInteressado).get().then((document) async {
            var nomeUsuarioAnuncio = document.data()!["nome"];

          // Busca o nome do pet
          db.collection("anuncios").doc(_anuncio.id).get().then((document) async {
            var nomePet = document.data()!["nome"];

            // aqui você pode usar uma biblioteca como o "dart:io" ou um serviço de envio de email para enviar o email para o usuário.
            // exemplo de como enviar email com a biblioteca "dart:io"
            final options = new GmailSmtpOptions()
              ..username = 'encontreipet@gmail.com'
              ..password = 'wiqvcftffzqilnzy';
            var emailTransport = new SmtpTransport(options);
            var envelope = new Envelope()
              ..from = 'encontreipet@gmail.com'
              ..recipients.add(emailUsuarioAnuncio)
              ..subject = 'Interesse no Anúncio'
              ..text = 'O usuário '+nomeUsuarioAnuncio+' demonstrou interesse na adoção do seu pet "'+nomePet+'". Acesse o aplicativo e confira.';

            await emailTransport.send(envelope);

            Navigator.pop(_dialogContext);
            Navigator.pop(context);
          });
        });
      });
            });
          }
      }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _anuncio = widget.anuncio;

    _interesse = Interesse.gerarId();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Manifestar Interesse de Adoção",
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


                //Caixas de textos e botões
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _descricaoController,
                    hint: "Qual o motivo do seu interesse?",
                    onSaved: (descricao){
                      _interesse.descricao = descricao.toString();
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

                BotaoCustomizado(
                  texto: "Confirmar Interesse",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      //Salvar campos
                      _formKey.currentState?.save();

                      //Limpar formulário
                      _formKey.currentState?.reset();

                      //Configura dialog context
                      _dialogContext = context;

                      //Salvar interesse
                      _salvarInteresse();

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
