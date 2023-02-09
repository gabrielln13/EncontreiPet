import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/models/Interesse.dart';
import 'package:encontrei_pet/views/widgets/BotaoCustomizado.dart';
import 'package:encontrei_pet/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validadores/Validador.dart';
import '../models/Anuncio.dart';
import 'package:mailer/mailer.dart';

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
              ..subject = 'Interesse na Adoção do Pet "'+nomePet+'".'
              ..text = 'EncontreiPet \n\nO usuário '+nomeUsuarioAnuncio+' demonstrou interesse na adoção do seu pet "'+nomePet+'". Acesse o aplicativo e confira.';

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
