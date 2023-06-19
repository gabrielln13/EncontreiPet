import 'package:encontrei_pet/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardAdocao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adoção",
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing:20,
                    runSpacing: 20.0,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, "/anuncios",
                          );
                        },
                        child: Card(
                          color: Colors.grey[50],
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("imagens/adote1.png", width: 74.0),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Adote um pet",
                                      style: GoogleFonts.lato( textStyle: TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          User? usuarioLogado = await auth.currentUser;
                          if (usuarioLogado != null) {
                            Navigator.pushNamed(
                                context, "/meus-anuncios",);
                          }else {
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
                          }
                        },
                        child: Card(
                          color: Colors.grey[50],
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("imagens/cadastropet.png", width: 74.0),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Meus Anúncios",
                                      style: GoogleFonts.lato( textStyle: TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}