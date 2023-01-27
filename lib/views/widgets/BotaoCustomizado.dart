import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Color(0xff2BBDEE)),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(32, 10, 32, 10)),
      ),
      child: Text(
        this.texto,
        style: GoogleFonts.lato( textStyle: TextStyle(
            color: this.corTexto, fontSize: 20
        ),
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}