import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/TelaLogin.dart';
import 'package:flutter_app/model/Vaga.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbaVagas extends StatefulWidget {
  @override
  _AbaVagasState createState() => _AbaVagasState();
}

class _AbaVagasState extends State<AbaVagas>{

  String _idUsuarioLogado;
  String _emailUsuarioLogado;

 // TextEditingController _textEditingController = TextEditingController();

  //TabController _tabController;

  List<String> itensMenu = [
    "Perfil","Editar Perfil", "Deslogar", "Excluir Perfil"
  ];


_pesquisaVagas() async{
  Firestore db = Firestore.instance;

  var pesquisa;

  QuerySnapshot querySnapshot = await db.collection("vagas")
      .where("nome", isGreaterThanOrEqualTo: pesquisa)
      .where("nome", isLessThanOrEqualTo: pesquisa + "\uf8ff" )
      .getDocuments();
  for( DocumentSnapshot item in querySnapshot.documents ){
    var dados = item.data;
    print("filtro nome: ${dados["nome"]} idade: ${dados["idade"]}");
  }

}


  Future<List<Vaga>> _recuperarVagas() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection("vagas").getDocuments();

    List<Vaga> listaVagas = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      Vaga vaga = Vaga();
      vaga.nome = dados["nome"];
      vaga.nivel = dados["nivel"];
      vaga.requisitos = dados ["requisitos"];
      vaga.descricao = dados ["descricao"];
      vaga.email = dados["email"];

      listaVagas.add(vaga);
    }
      return listaVagas;
  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
    _emailUsuarioLogado = usuarioLogado.email;

  }

  _escolhaMenuItem(String itemEscolhido){

    switch( itemEscolhido ){
      case "Perfil":
        Navigator.pushNamed(context, "/perfilCandidato");
        break;
      case "Editar Perfil":
        Navigator.pushNamed(context, "/editar");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Excluir Perfil":
        Navigator.pushNamed(context, "/excluir");
        break;
    }

    // print("Item esclhido" + itemEscolhido);

  }

  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TelaLogin()
        )
    );

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
              hintText: "Encontre sua vaga",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>
                  (
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },)
        ],
      ),
      body: Container(
          decoration: BoxDecoration(color: Color(0xff0097C4)),
          padding: EdgeInsets.only(top: 15),
          child: FutureBuilder<List<Vaga>>(
              future: _recuperarVagas(),
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
                          List<Vaga> listaItens = snapshot.data;
                          Vaga vaga = listaItens[indice];
                          return Center(
                            child: Card(
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                ListTile(
                                  onTap: (){
                                    Navigator.pushNamed(context, "/perfilVaga",
                                    arguments: vaga);
                                  },
                                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  title: Text(
                                  vaga.nome,
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
