import 'package:encontrei_pet/models/Anuncio.dart';
import 'package:encontrei_pet/views/Anuncios.dart';
import 'package:encontrei_pet/views/Dashboard.dart';
import 'package:encontrei_pet/views/DashboardAdocao.dart';
import 'package:encontrei_pet/views/DetalhesAnuncio.dart';
import 'package:encontrei_pet/views/DetalhesInteresse.dart';
import 'package:encontrei_pet/views/EditarAnuncio.dart';
import 'package:encontrei_pet/views/InteresseAdocao.dart';
import 'package:encontrei_pet/views/Interesses.dart';
import 'package:encontrei_pet/views/Login.dart';
import 'package:encontrei_pet/views/MeusAnuncios.dart';
import 'package:encontrei_pet/views/NovoAnuncio.dart';
import 'package:encontrei_pet/views/NovoUsuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(settings){

    final args = settings.arguments;

    switch( settings.name){
      case "/":
        return MaterialPageRoute(
            builder: (_) => Dashboard()
        );
      case "/dashboard-adocao":
        return MaterialPageRoute(
            builder: (_) => DashboardAdocao()
        );
      case "/anuncios":
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
      case "/detalhes-interesse":
        return MaterialPageRoute(
            builder: (_) => DetalhesInteresse(args)
        );
      case "/interesse-adocao":
        return MaterialPageRoute(
            builder: (_) => InteresseAdocao(args)
        );
      case "/novo-usuario":
        return MaterialPageRoute(
            builder: (_) => NovoUsuario()
        );
      case "/editar-anuncio":
        return MaterialPageRoute(
            builder: (_) => EditarAnuncio(idAnuncio: settings.arguments,)
        );
      case "/interesses":
        return MaterialPageRoute(
            builder: (_) => Interesses(args)
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