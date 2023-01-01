import 'package:encontrei_pet/models/Usuario.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController(text: "gabrielln13@gmail.com");
  TextEditingController _controllerSenha = TextEditingController(text: "123456");

  bool _cadastrar = false;
  String _mensagemErro = "";
  String _textoBotao = "Entrar";

  _cadastrarUsuario(Usuario usuario){

  FirebaseAuth auth = FirebaseAuth.instance;

  auth.createUserWithEmailAndPassword(
  email: usuario.email,
  password: usuario.senha
  ).then((FirebaseUser){

    //redireciona para tela principal
    Navigator.pushReplacementNamed(context, "/");

  });
}
  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((FirebaseUser) {

      //redireciona para tela principal
      Navigator.pushReplacementNamed(context, "/");

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

        //Cadastrar ou Logar
        if(_cadastrar){
          //Cadastrar
          _cadastrarUsuario(usuario);
        }else{
          //Logar
          _logarUsuario(usuario);
        }

      } else {
        setState(() {
          _mensagemErro = "Preencha a senha! Digite seis ou mais caracteres";
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
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(bottom: 32),
                child: Image.asset(
                    "imagens/logo.png",
                  width: 200,
                  height: 150,
                ),
                ),

                InputCustomizado(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  maxLines: 1,
                  type: TextInputType.emailAddress,
                ),
                InputCustomizado(
                  controller: _controllerSenha,
                  hint: "Senha",
                  obscure: true,
                  maxLines: 1,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Logar"),
                    Switch(
                      value: _cadastrar,
                      onChanged: (bool valor){
                        setState(() {
                          _cadastrar = valor;
                          _textoBotao = "Entrar";
                          if(_cadastrar ){
                            _textoBotao = "Cadastre-se";
                          }
                        });
                      },
                    ),
                    Text("Cadastrar"),
                  ],
                ),

                BotaoCustomizado(
                  texto: _textoBotao,
                  onPressed: () {
                    _validarCampos();
                  },
                ),

                    Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(_mensagemErro, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
