import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final String? labelText;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FormFieldValidator<String>? onSaved;

  InputCustomizado({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
    this.inputFormatters,
    required this.maxLines,
    this.validator,
    this.onSaved,
    this.labelText

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.type,
      inputFormatters: this.inputFormatters,
      validator: this.validator,
      maxLines: this.maxLines,
      onSaved: this.onSaved,
      style: GoogleFonts.lato( textStyle: TextStyle(fontSize: 16),),
      decoration: InputDecoration(
          labelText: this.labelText,
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16)
          )
      ),
    );
  }
}
