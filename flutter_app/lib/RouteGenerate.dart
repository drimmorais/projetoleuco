import 'package:flutter/material.dart';
import 'package:flutter_app/Editar.dart';
import 'package:flutter_app/Exclusao.dart';
import 'package:flutter_app/TelaCadastroCandidato.dart';
import 'package:flutter_app/TelaCandidatos.dart';
import 'package:flutter_app/TelaLogin.dart';
import 'package:flutter_app/TelaPerfilVaga.dart';
import 'package:flutter_app/telas/AbaCandidatos.dart';
import 'package:flutter_app/PerfilCandidatos.dart';
import 'file:///C:/Users/dryka/AndroidStudioProjects/flutter_app/lib/AbaVagas.dart';

class RouteGenarator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => TelaLogin()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => TelaLogin()
        );
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => TelaCadastroCandidato()
        );
      /*case "/home":
        return MaterialPageRoute(
            builder: (_) => HomeDoCandidato()
        );*/
      case "/editar":
        return MaterialPageRoute(
            builder: (_) => Editar()
        );
      case "/candidatos":
        return MaterialPageRoute(
            builder: (_) => TelaCandidatos()
        );
      case "/abaCand":
        return MaterialPageRoute(
            builder: (_) => TelaCandidatos()
        );
      case "/perfilVaga":
        return MaterialPageRoute(
            builder: (_) => TelaPerfilVaga(args)
        );
      case "/perfilCandidato":
        return MaterialPageRoute(
            builder: (_) => PerfilCandidatos(args)
        );
      case "/abaVaga":
        return MaterialPageRoute(
            builder: (_) => AbaVagas()
        );
      case "/exclusao":
        return MaterialPageRoute(
            builder: (_) => Exclusao()
        );
      case "/telaLogin":
        return MaterialPageRoute(
            builder: (_) => TelaLogin()
        );
    }
  }

}