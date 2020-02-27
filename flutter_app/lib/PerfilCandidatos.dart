
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/model/Usuario.dart';

class PerfilCandidatos extends StatefulWidget {
  Usuario usuario;

  PerfilCandidatos(this.usuario);

  @override
  _PerfilCandidatosState createState() => _PerfilCandidatosState();
}

class _PerfilCandidatosState extends State<PerfilCandidatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //title: Text(widget.usuario.nome),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff0097C4)),
        width: double.maxFinite,
        child: Center(
          child: Card(
            color: Colors.grey[300],
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}