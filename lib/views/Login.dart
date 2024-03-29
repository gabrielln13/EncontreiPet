import 'package:encontrei_pet/models/Usuario.dart';
import 'package:encontrei_pet/views/Anuncios.dart';
import 'package:encontrei_pet/views/Dashboard.dart';
import 'package:encontrei_pet/views/NovoUsuario.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = "";
  String _textoBotao = "Entrar";

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((FirebaseUser) {
      //redireciona para tela principal
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }).catchError((error) {
      setState(() {
        _mensagemErro =
            "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });
    });
  }

  _validarCampos() {
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length >= 6) {
        //Configurar usuário
        Usuario usuario = Usuario();
        usuario.senha = senha;
        usuario.email = email;

        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha! Digite 6 ou mais caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Digita um e-mail válido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, //tamanho do botão "entrar"
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                InputCustomizado(
                  // upperFirstLetter: false,
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  maxLines: 1,
                  type: TextInputType.emailAddress,
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                InputCustomizado(
                  // upperFirstLetter: false,
                  controller: _controllerSenha,
                  hint: "Senha",
                  obscure: true,
                  maxLines: 1,
                ),
                Padding(padding: EdgeInsets.only(top: 16, bottom: 10)),
                BotaoCustomizado(
                  texto: _textoBotao,
                  onPressed: () {
                    _validarCampos();
                  },
                ),

                Padding(
                  padding: EdgeInsets.all(25),
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? Cadastre-se!",
                      style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NovoUsuario()));
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(25),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Acessar sem conta",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 16))
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
