import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:encontrei_pet/main.dart';
import 'package:encontrei_pet/models/Anuncio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetalhesAnuncio extends StatefulWidget {

  Anuncio anuncio;
  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {

  late Anuncio _anuncio;

  List<Widget> _getListaImagens(){

    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url){
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fitWidth
          )
        ),
      );
    }).toList();

  }

  // Exemplo de ligação
  // _ligarTelefone(String telefone) async {
  //
  //   if( await canLaunchUrlString("tel:$telefone") ){
  //     await launchUrlString("tel:$telefone");
  //   }else{
  //     print("Não pode fazer a ligação");
  //   }
  //
  // }

  @override
  void initState() {
    super.initState();

    _anuncio = widget.anuncio;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncio"),
      ),
      body: Stack(children: <Widget>[

        ListView(children: <Widget>[

          SizedBox(
            height: 250,
            child: Carousel(
              images: _getListaImagens(),
              dotSize: 8,
              dotBgColor: Colors.transparent,
              dotColor: Colors.white,
              autoplay: false,
              dotIncreasedColor: temaPadrao.primaryColor,
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(
                  "R\$ ${_anuncio.preco}",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: temaPadrao.primaryColor
                  ),
                ),

                Text(
                  "${_anuncio.titulo}",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),

                Text(
                  "${_anuncio.descricao}",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                Text(
                  "Contato",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 66),
                  child: Text(
                    "${_anuncio.telefone}",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),


              ],),
          )

        ],),

        //Exemplo de Ligação
        // Positioned(
        //   left: 16,
        //   right: 16,
        //   bottom: 16,
        //   child: GestureDetector(
        //     child: Container(
        //       child: Text(
        //         "Ligar",
        //         style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 20
        //         ),
        //       ),
        //       padding: EdgeInsets.all(16),
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //           color: temaPadrao.primaryColor,
        //           borderRadius: BorderRadius.circular(30)
        //       ),
        //     ),
        //     onTap: (){
        //       _ligarTelefone(_anuncio.telefone);
        //     },
        //   ),
        // ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: GestureDetector(
            child: Container(
              child: Text(
                "Interesse na Adoção?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: temaPadrao.primaryColor,
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, "/interesse-adocao");

            },
          ),
        )

      ],),
    );
  }
}