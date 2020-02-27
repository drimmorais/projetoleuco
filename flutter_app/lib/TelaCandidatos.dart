import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/TelaLogin.dart';
import 'package:flutter_app/model/Usuario.dart';
import 'package:flutter_app/model/Vaga.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaCandidatos extends StatefulWidget {
  @override
  _TelaCandidatosState createState() => _TelaCandidatosState();
}

class _TelaCandidatosState extends State<TelaCandidatos> {
  String _idUsuarioLogado;
  String _emailUsuarioLogado;


  _pesquisaUsuario() async {
    Firestore db = Firestore.instance;

    var pesquisa;

    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .where("nome", isGreaterThanOrEqualTo: pesquisa)
        .where("nome", isLessThanOrEqualTo: pesquisa + "\uf8ff")
        .getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      print("filtro nome: ${dados["nome"]} idade: ${dados["idade"]}");
    }
  }

  Future<List<Usuario>> _recuperarUsuario() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuarios").getDocuments();

    List<Usuario> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      Usuario usuario = Usuario();
      usuario.nome = dados["nome"];
      usuario.idade = dados["idade"];
      usuario.area = dados["area"];
      usuario.telefone = dados["telefone"];
      usuario.email = dados["email"];
      usuario.senha = dados["senha"];
      usuario.habilidades = dados["habilidades"];

      listaUsuarios.add(usuario);
    }
    return listaUsuarios;
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
        title: TextField(
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(40, 16, 40, 16),
              hintText: "Busque o Candidato",
              filled: true,
              fillColor: Colors.grey[100],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
        actions: <Widget>[
        ],
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
                          Text("Carregando Usuarios"),
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
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/perfilCandidatos",
                                          arguments: usuario);
                                    },
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    title: Text(usuario.nome,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.grey[800],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                    break;
                }
              })),
    );
  }
}
