import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbaCandidatos extends StatefulWidget {
  @override
  _AbaCandidatosState createState() => _AbaCandidatosState();
}

class _AbaCandidatosState extends State<AbaCandidatos>{

  String _idUsuarioLogado;
  String _emailUsuarioLogado;


  Future<List<Usuario>> _recuperarUsuario() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuarios").getDocuments();

    List<Usuario> listaUsuario = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.area = dados["area"];

      listaUsuario.add(usuario);
    }
    return listaUsuario;
  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _emailUsuarioLogado = usuarioLogado.email;

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Encontre o Candidato Ideal"),
      ),
      body: Container(
          decoration: BoxDecoration(color: Color(0xff0097C4)),
          padding: EdgeInsets.only(top: 15),

          child: FutureBuilder<List<Usuario>>(
              future: _recuperarUsuario(),
              // ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text("Carregando Vagas"),
                          CircularProgressIndicator()
                        ],
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, indice) {
                          List<Usuario> listaItens = snapshot.data;
                          Usuario usuario = listaItens[indice];

                          return Center(
                            child: Card(
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                ListTile(
                                 contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                 title: Text(
                                  usuario.nome,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20,
                                    color: Colors.grey[800],)
                              ),
                            ),
                                ],
                              ),
                            ),
                          );

                        });
                    break;
                }
              }
          )
      ),
    );

  }
}
