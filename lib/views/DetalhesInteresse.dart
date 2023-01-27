import 'package:carousel_pro/carousel_pro.dart';
import 'package:encontrei_pet/views/InteresseAdocao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encontrei_pet/main.dart';
import 'package:encontrei_pet/models/Anuncio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class DetalhesInteresse extends StatefulWidget {

  Anuncio anuncio;
  DetalhesInteresse(this.anuncio);


  @override
  _DetalhesInteresseState createState() => _DetalhesInteresseState();
}

class _DetalhesInteresseState extends State<DetalhesInteresse> {


  late Anuncio _anuncio;
  // String _mensagemErro = "";

  List<Widget> _getListaImagens(){

    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url){
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.fitWidth
            )
        ),
      );
    }).toList();

  }



  @override
  void initState() {
    super.initState();

    _anuncio = widget.anuncio;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes Anúncio",
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
      body: Stack(children: <Widget>[

        ListView(children: <Widget>[

          SizedBox(
            height: 250,
            child: Carousel(
              images: _getListaImagens(),
              dotSize: 8,
              dotBgColor: Colors.transparent,
              dotColor: Colors.white,
              autoplay: false,
              dotIncreasedColor: temaPadrao.primaryColor,
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //NOME
                Text(
                  "${_anuncio.nome}",
                  style: GoogleFonts.lato( textStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: temaPadrao.primaryColor
                  ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),


                // Text(
                //   "Idade: ${_anuncio.idade} Anos",
                //   style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w400
                //   ),
                // ),

                //IDADE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Idade:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.idade} Anos",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //SEXO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sexo:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.sexo}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Sexo: ${_anuncio.sexo}",
                //   style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w400
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //RAÇA
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Raça:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.raca}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Raça: ${_anuncio.raca}",
                //   style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w400
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //COR
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Cor:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.cor}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Cor: ${_anuncio.cor}",
                //   style: TextStyle(
                //       fontSize: 18
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                Text(
                  "Outras Informações",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),

                //PORTE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Porte:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.porte}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Porte: ${_anuncio.porte}",
                //   style: TextStyle(
                //       fontSize: 18
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //TEMPERAMENTO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Temperamento:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.temperamento}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Temperamento: ${_anuncio.temperamento}",
                //   style: TextStyle(
                //       fontSize: 18
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //CHIP
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Chip:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.chip}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Chip: ${_anuncio.chip}",
                //   style: TextStyle(
                //       fontSize: 18
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //VACINAÇÃO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Vacinação:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.vacinacao}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Vacinação: ${_anuncio.vacinacao}",
                //   style: TextStyle(
                //       fontSize: 18
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //DOENÇA
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Doenças:",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " ${_anuncio.doenca}",
                      style: GoogleFonts.lato( textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                // Text(
                //   "Doenças: ${_anuncio.doenca}",
                //   style: TextStyle(
                //       fontSize: 18
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //DESCRIÇÃO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Text(
                        "Descrição:",
                        style: GoogleFonts.lato( textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 80),
                        child: Text.rich(
                          TextSpan(
                            text: " ${_anuncio.descricao}",
                            style: GoogleFonts.lato( textStyle: TextStyle(
                              fontSize: 18,
                            ),
                            ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),

                //DATA CADASTRO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Text(
                        "Cadastrado em:",
                        style: GoogleFonts.lato( textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 80),
                        child: Text.rich(
                          TextSpan(
                            text: " ${DateFormat('dd-MM-yyyy').format(_anuncio.dataCadastro.toDate())}",
                            style: GoogleFonts.lato( textStyle: TextStyle(
                              fontSize: 18,
                            ),
                            ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                )

              ],),
          )

        ],),



        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: GestureDetector(
            child: Container(
              child: Text(
                "Interesse na Adoção?",
                style: GoogleFonts.lato( textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
                ),
              ),
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: temaPadrao.primaryColor,
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
            onTap: () async {
              // Navigator.pushNamed(context, "/interesse-adocao");

              FirebaseAuth auth = FirebaseAuth.instance;
              //User? usuarioLogado = !;
              if (await auth.currentUser != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InteresseAdocao(_anuncio,)
                    )
                );
              } else {
                // exibir mensagem de erro para o usuário
                setState(() {

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          Text("Favor realizar login para completar essa ação."),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              MaterialButton(
                                child: Text("Fazer Login"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(context, '/login');
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    ),
                  );



                });
              }

            },
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 20),
        //   child: Text(_mensagemErro, style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.red
        //   ),),
        // ),
      ],),
    );
  }
}