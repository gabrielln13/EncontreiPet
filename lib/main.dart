import 'package:encontrei_pet/RouteGenarator.dart';
import 'package:encontrei_pet/views/Anuncios.dart';
import 'package:encontrei_pet/views/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

final ThemeData temaPadrao = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        // primary: Color(0xff0E1F55),
        primary: Colors.grey,
        secondary: Color(0xff2BBDEE),
));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Encontrei Pet",
    home: Anuncios(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}