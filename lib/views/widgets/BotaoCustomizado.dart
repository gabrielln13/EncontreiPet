import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  BotaoCustomizado(
      {Key? key,
      required this.texto,
      this.corTexto = Colors.white,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(32, 16, 32, 16)),
      ),
      child: Text(
        this.texto,
        style: TextStyle(
            color: this.corTexto, fontSize: 20
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}