import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  String _idUsuarioLogado;


  Firestore db = Firestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
  //auth.signOut();
  FirebaseUser usuarioLogado = await auth.currentUser();

  usuarioLogado = "usuarioLogado" as FirebaseUser;

  db.collection("usuarios").document(_idUsuarioLogado).delete();


}


class Exclusao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

