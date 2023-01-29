import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import '../../models/Anuncio.dart';
import '../../models/Interesse.dart';
import 'package:intl/intl.dart';

class ItemInteresse extends StatelessWidget {
  Interesse interesse;
  VoidCallback? onTapItem;
  VoidCallback? onPressedLigacao;
  VoidCallback? onPressedWhatsapp;
  // VoidCallback? onPressedConfirmarDoacao;
  String? nomeUsuario;
  String? cpfUsuario;
  String? telefoneUsuario;
  String? emailUsuario;

  ItemInteresse(
      {super.key,
      required this.interesse,
      this.onTapItem,
      this.onPressedLigacao,
      this.onPressedWhatsapp
      // this.onPressedConfirmarDoacao
      }) {
    FirebaseFirestore.instance
        .collection("usuarios")
        .doc(interesse.idUsuarioInteressado)
        .get()
        .then((snapshot) {
      nomeUsuario = snapshot.data()!["nome"];
      cpfUsuario = snapshot.data()!["cpf"];
      telefoneUsuario = snapshot.data()!["telefone"];
      emailUsuario = snapshot.data()!["email"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              //DADOS
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //INTERESSADO
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("usuarios")
                            .doc(interesse.idUsuarioInteressado)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var nomeUsuario = snapshot.data!["nome"];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Interessado:",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: temaPadrao.primaryColor),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      " $nomeUsuario",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: temaPadrao.primaryColor),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                      ),

                      //DATA DE CADASTRO
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Cadastrado em:",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            " ${DateFormat('dd-MM-yyyy').format(interesse.dataCadastro.toDate())}",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                      ),

                      //CPF
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("usuarios")
                            .doc(interesse.idUsuarioInteressado)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var cpfUsuario = snapshot.data!["cpf"];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "CPF:",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  " $cpfUsuario",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                      ),

                      //EMAIL
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("usuarios")
                            .doc(interesse.idUsuarioInteressado)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var emailUsuario = snapshot.data!["email"];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "E-mail:",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  " $emailUsuario",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                      ),

                      //TELEFONE
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("usuarios")
                            .doc(interesse.idUsuarioInteressado)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var telefoneUsuario = snapshot.data!["telefone"];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Telefone:",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  " $telefoneUsuario",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                      ),

                      //DESCRIÇÃO
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Descrição:",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                " ${interesse.descricao}",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //BOTÃO LIGAR
              if (this.onPressedLigacao != null)
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    //color: Colors.red,
                    padding: EdgeInsets.all(10),
                    onPressed: this.onPressedLigacao,
                    child: Icon(FontAwesomeIcons.phone, color: Colors.green),
                  ),
                ),

              //BOTÃO WHATSAPP
              if (this.onPressedWhatsapp != null)
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    //color: Colors.red,
                    padding: EdgeInsets.all(10),
                    onPressed: this.onPressedWhatsapp,
                    child: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
