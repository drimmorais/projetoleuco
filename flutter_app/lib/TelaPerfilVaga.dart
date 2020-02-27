import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/model/Vaga.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaPerfilVaga extends StatefulWidget {

  Vaga vaga;

  TelaPerfilVaga(this.vaga);

  _candidatar()async{


  }



  @override
  _TelaPerfilVagaState createState() => _TelaPerfilVagaState();
}

class _TelaPerfilVagaState extends State<TelaPerfilVaga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.vaga.nome),
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
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("NÍVEL DA VAGA: ",
                            style: TextStyle(
                              fontSize:25,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 5),
                        child: Text(widget.vaga.nivel,
                            style: TextStyle(
                              fontSize:22,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("REQUISITOS: ",
                            style: TextStyle(
                              fontSize:25,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 5),
                        child: Text(widget.vaga.requisitos,
                            style: TextStyle(
                              fontSize:22,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("DESCRIÇÃO :  ",
                            style: TextStyle(
                              fontSize:25,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 5),
                        child: Text(widget.vaga.descricao,
                            style: TextStyle(
                              fontSize:22,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("E-MAIL :  ",
                            style: TextStyle(
                              fontSize:25,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent[700],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 5),
                        child: Text(widget.vaga.email,
                            style: TextStyle(
                              fontSize:25,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            )
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: RaisedButton(
                          child: Text(
                            "Candidatar - se",
                            style: TextStyle(color: Colors.orange, fontSize: 20),
                          ),
                          color: Colors.grey[50],
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          onPressed: () {
                            //_atualizarNomeFirestore();
                          }
                      ),
                    ),
                  ],

                ),
              ),

            ),
          ),
        ),

        );
  }
}
