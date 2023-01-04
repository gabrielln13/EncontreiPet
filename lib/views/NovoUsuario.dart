import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Usuario.dart';

class NovoUsuario extends StatefulWidget {
  const NovoUsuario({Key? key}) : super(key: key);

  @override
  State<NovoUsuario> createState() => _NovoUsuarioState();
}

class _NovoUsuarioState extends State<NovoUsuario> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  //TextEditingController _controllerCpf = TextEditingController();

  bool _cadastrar = true;
  String _mensagemErro = "";
  String _textoBotao = "Cadastrar";

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((FirebaseUser) {
      setState(() {
        _mensagemErro = "Cadastro realizado!";
      });
      //redireciona para tela principal
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  // _logarUsuario(Usuario usuario) {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   auth.signInWithEmailAndPassword(
  //       email: usuario.email,
  //       password: usuario.senha
  //   ).then((FirebaseUser) {
  //     //redireciona para tela principal
  //     Navigator.pushReplacementNamed(context, "/");
  //   });
  // }

  _validarCampos() {
    //Recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    //String cpf = _controllerCpf.text;
    String telefone = _controllerTelefone.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (telefone.isNotEmpty && telefone.length >= 8) {
        if (nome.length >= 3) {
          if (senha.isNotEmpty && senha.length >= 6) {

            //Configurar usuário
            Usuario usuario = Usuario();
            usuario.senha = senha;
            usuario.email = email;
            usuario.nome = nome;
            usuario.telefone = telefone;

            // //Cadastrar ou Logar
            // if (_cadastrar) {
            //   //Cadastrar
              _cadastrarUsuario(usuario);
            // } else {
            //   //Logar
            //   _logarUsuario(usuario);
            // }
          } else {
            setState(() {
              _mensagemErro =
              "Preencha a senha! Digite 6 ou mais caracteres!";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Digita um e-mail válido!";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Digite um telefone válido!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Nome precisa ter mais que 2 caracteres!";
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Novo Usuário"),
        ),
        body: Container(
          // decoration: BoxDecoration(color: Color(0xffeeeef3)),
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //tamanho do botão "entrar"
                children: <Widget>[

                  Padding(padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "imagens/logo.png",
                      width: 200,
                      height: 150,
                    ),
                  ),

                  InputCustomizado(
                    controller: _controllerNome,
                    hint: "Nome",
                    autofocus: true,
                    maxLines: 1,
                    type: TextInputType.text,
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 5)),

                  // InputCustomizado(
                  //   controller: _controllerCpf,
                  //   hint: "CPF",
                  //   maxLines: 1,
                  //   type: TextInputType.text,
                  // ),

                  Padding(
                      padding: EdgeInsets.only(top: 5)),

                  InputCustomizado(
                    controller: _controllerTelefone,
                    hint: "Telefone",
                    maxLines: 1,
                    type: TextInputType.phone,
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 5)),

                  InputCustomizado(
                    controller: _controllerEmail,
                    hint: "E-mail",
                    maxLines: 1,
                    type: TextInputType.emailAddress,
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 5)),

                  InputCustomizado(
                    controller: _controllerSenha,
                    hint: "Senha",
                    obscure: true,
                    maxLines: 1,
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10)),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     Text("Logar"),
                  //     Switch(
                  //       value: _cadastrar,
                  //       onChanged: (bool valor){
                  //         setState(() {
                  //           _cadastrar = valor;
                  //           _textoBotao = "Entrar";
                  //           if(_cadastrar ){
                  //             _textoBotao = "Cadastre-se";
                  //           }
                  //         });
                  //       },
                  //     ),
                  //     Text("Cadastrar"),
                  //   ],
                  // ),

                  BotaoCustomizado(
                    texto: _textoBotao,
                    onPressed: () {
                      _validarCampos();
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(_mensagemErro, style: TextStyle(
                        fontSize: 16,
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


