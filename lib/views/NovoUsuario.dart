import 'package:brasil_fields/brasil_fields.dart';
import 'package:encontrei_pet/views/Login.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validadores/Validador.dart';
import '../models/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NovoUsuario extends StatefulWidget {

  @override
  _NovoUsuarioState createState() => _NovoUsuarioState();
}

class _NovoUsuarioState extends State<NovoUsuario> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();

  // bool _cadastrar = true;
  String _mensagemErro = "";
  String _textoBotao = "Cadastrar";

  _validarCampos() {
    //Recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String cpf = _controllerCpf.text;
    String telefone = _controllerTelefone.text;
    String senha = _controllerSenha.text;

    if (nome.length >= 3) {
      if (GetUtils.isCpf(cpf) && cpf.length >= 11) {
        if (telefone.isNotEmpty && telefone.length >= 8) {
          if (email.isNotEmpty && email.contains("@")) {
            if (senha.isNotEmpty && senha.length >= 6) {
              setState(() {
                _mensagemErro = "";
              });

              //Configurar usuário
              Usuario usuario = Usuario();
              usuario.senha = senha;
              usuario.email = email;
              usuario.nome = nome;
              usuario.telefone = telefone;
              usuario.cpf = cpf;

              _cadastrarUsuario(usuario);

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
          _mensagemErro = "Digite um CPF válido!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Nome precisa ter mais que 2 caracteres!";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha)
        .then((FirebaseUser) {
      //Salvar dados do usuário
      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection("usuarios")
          .doc(FirebaseUser.user!.uid)
          .set(usuario.toMap());

      //redireciona para tela principal
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));

    }).catchError((error) {
      print("erro app: " + error.toString());
      setState(() {
        _mensagemErro =
            "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Novo Usuário",
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
        // decoration: BoxDecoration(color: Color(0xffeeeef3)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //tamanho do botão "entrar"
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: InputCustomizado(
                    upperFirstLetter: true,
                    controller: _controllerNome,
                    hint: "Nome",
                    autofocus: true,
                    maxLines: 1,
                    type: TextInputType.text,
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _controllerCpf,
                    hint: "CPF",
                    autofocus: true,
                    maxLines: 1,
                    type: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter()
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _controllerTelefone,
                    hint: "Telefone",
                    autofocus: true,
                    maxLines: 1,
                    type: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _controllerEmail,
                    hint: "E-mail",
                    autofocus: true,
                    maxLines: 1,
                    type: TextInputType.text,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: InputCustomizado(
                    upperFirstLetter: false,
                    controller: _controllerSenha,
                    hint: "Senha",
                    obscure: true,
                    maxLines: 1,
                    type: TextInputType.text,
                  ),
                ),


                Padding(padding: EdgeInsets.only(top: 16, bottom: 10)),
                BotaoCustomizado(
                  texto: _textoBotao,
                  onPressed: () {
                    _validarCampos();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(fontSize: 16, color: Colors.red),
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
