import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/PerfilCandidatos.dart';
import 'package:flutter_app/RouteGenerate.dart';
import 'package:flutter_app/TelaCandidatos.dart';
import 'file:///C:/Users/dryka/AndroidStudioProjects/flutter_app/lib/AbaVagas.dart';
import 'package:flutter_app/TelaLogin.dart';



void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaLogin(),
    theme: ThemeData(
        primaryColor: Color(0xffF8F8F8),
        accentColor: Color(0xffF8F8F8)
    ),
    initialRoute: "/abaVaga",
    onGenerateRoute:RouteGenarator.generateRoute,

  )
  );
}