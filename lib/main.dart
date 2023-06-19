import 'package:encontrei_pet/RouteGenarator.dart';
import 'package:encontrei_pet/views/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData temaPadrao = ThemeData(
  textTheme: TextTheme(
    headline6: GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 18
      ),
    ),
  ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      // primary: Color(0xff0E1F55),
      primary: Colors.black12,
      secondary: Color(0xff2BBDEE),
    )
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Encontrei Pet",
    home: Dashboard(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}