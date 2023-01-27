import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../../models/Anuncio.dart';

class ItemAnuncio extends StatelessWidget {

  Anuncio anuncio;
  VoidCallback? onTapItem;
  VoidCallback? onPressedRemover;
  VoidCallback? onPressedEditar;

  ItemAnuncio({super.key,
    required this.anuncio,
    this.onTapItem,
    this.onPressedRemover,
    this.onPressedEditar
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: <Widget>[

            //Imagem
            SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                anuncio.fotos[0],
                fit: BoxFit.cover,
              ),
            ),

            //DADOS
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    //NOME
                    Text(
                    "${anuncio.nome}",
                    style: GoogleFonts.lato( textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor
                    ),
                    ),
                  ),

                // Text(
                //   "Cor: ${anuncio.cor}",
                //   style: TextStyle(
                //       fontSize: 16,
                //   ),
                // ),

                    //COR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Espécie:",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " ${anuncio.especie}",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),

                    //COR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Cor:",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " ${anuncio.cor}",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),

                    // Text(
                    //   "Idade: ${anuncio.idade} Anos ",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //   ),
                    // ),

                    //IDADE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Idade:",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " ${anuncio.idade} Anos",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),

                    // Text(
                    //   "Sexo: ${anuncio.sexo}",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //   ),
                    // ),

                    //SEXO
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Sexo:",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " ${anuncio.sexo}",
                          style: GoogleFonts.lato( textStyle: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),

                    // //SITUAÇÃO
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     Text(
                    //       "Status:",
                    //       style: GoogleFonts.lato( textStyle: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold
                    //       ),
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     ),
                    //     Text(
                    //       " ${anuncio.situacao}",
                    //       style: GoogleFonts.lato( textStyle: TextStyle(
                    //         fontSize: 16,
                    //       ),
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     ),
                    //   ],
                    // ),

                ],),
              ),
            ),

            //BOTÃO EDITAR
            if( this.onPressedEditar != null ) Expanded(
              flex: 1,
              child: MaterialButton(
                padding: EdgeInsets.all(10),
                onPressed: this.onPressedEditar,
                child: Icon(Icons.edit, color: Colors.grey,),
              ),
            ),

            //BOTÃO REMOVER
            if( this.onPressedRemover != null ) Expanded(
              flex: 1,
              child: MaterialButton(
                //color: Colors.red,
                padding: EdgeInsets.all(10),
                onPressed: this.onPressedRemover,
                child: Icon(Icons.delete, color: Colors.red,),
              ),
            ),

          ],),
        ),
      ),
    );
  }
}
