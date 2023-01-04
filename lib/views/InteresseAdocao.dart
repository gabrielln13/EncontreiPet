import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:encontrei_pet/main.dart';
import 'package:encontrei_pet/models/Anuncio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InteresseAdocao extends StatefulWidget {

  Anuncio anuncio;
  InteresseAdocao(this.anuncio);

  @override
  _InteresseAdocaoState createState() => _InteresseAdocaoState();
}

class _InteresseAdocaoState extends State<InteresseAdocao> {

  late Anuncio _anuncio;

  @override
  void initState() {
    super.initState();

    _anuncio = widget.anuncio;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manifestar Interesse na Adoção"),
      ),
    );
  }
}