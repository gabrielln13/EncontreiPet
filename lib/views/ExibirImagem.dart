import 'package:flutter/material.dart';

class ExibirImagem extends StatelessWidget {
  // const ExibirImagem({Key? key}) : super(key: key);

  final String urlImagem;

  ExibirImagem(this.urlImagem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(urlImagem),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: FloatingActionButton(
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}