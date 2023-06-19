import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> itensMenu = [];

  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){

      case "Logar / Cadastrar Usuário":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }

  }
  FirebaseFirestore db = FirebaseFirestore.instance;

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
        // "Meus Anúncios",
        "Deslogar"
      ];
    }
  }

  @override
  void initState(){
    super.initState();

    _verificaUsuarioLogado();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(""),
        centerTitle: true,
        titleSpacing: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle, color: Colors.grey),
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
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  "Encontrei Pet",
                  style: GoogleFonts.lato( textStyle: TextStyle(
                      color: temaPadrao.primaryColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                ),
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
                            context, "/dashboard-adocao",
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
                                    Image.asset("imagens/adocao.png", width: 74.0),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Adoção",
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text("Esta funcionalidade estará disponível na próxima versão. \n\n\n Enquanto isso, utilize a opção Adoção!"),
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
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
                                    Image.asset("imagens/perdido.png",width: 74.0,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Pets Perdidos",
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text("Esta funcionalidade estará disponível na próxima versão. \n\n\n Enquanto isso, utilize a opção Adoção!"),
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
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
                                    Image.asset("imagens/roubado.png", width: 74.0,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Pets Roubados",
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text("Esta funcionalidade estará disponível na próxima versão. \n\n\n Por enquanto utilize a opção Adoção!"),
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
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
                                    Image.asset("imagens/denuncia.png",width: 74.0,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Denúncias",
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