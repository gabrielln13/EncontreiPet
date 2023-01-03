import 'package:encontrei_pet/views/Anuncios.dart';
import 'package:encontrei_pet/views/DetalhesAnuncio.dart';
import 'package:encontrei_pet/views/Login.dart';
import 'package:encontrei_pet/views/MeusAnuncios.dart';
import 'package:encontrei_pet/views/NovoAnuncio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(settings){

    final args = settings.arguments;

    switch( settings.name){
      case "/":
        return MaterialPageRoute(
            builder: (_) => Anuncios()
        );
        case "/login":
          return MaterialPageRoute(
              builder: (_) => Login()
          );
      case "/meus-anuncios":
        return MaterialPageRoute(
            builder: (_) => MeusAnuncios()
        );
      case "/novo-anuncio":
        return MaterialPageRoute(
            builder: (_) => NovoAnuncio()
        );
      case "/detalhes-anuncio":
        return MaterialPageRoute(
            builder: (_) => DetalhesAnuncio(args)
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('Não há rota definida para ${settings.name}')),
            )
        );
    }
  }
}
//   static Route<dynamic> _erroRota(){
//     return MaterialPageRoute(
//         builder: (_){
//           return Scaffold(
//             appBar: AppBar(
//               title: Text("Tela não encontrada!"),
//             ),
//             body: Center(
//               child: Text("Tela não encontrada!"),
//             ),
//           );
//     }
//     );
// }
// }