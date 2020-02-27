import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AbaVagas.dart';
import 'package:flutter_app/TelaCadastroCandidato.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/TelaCandidatos.dart';
import 'model/Usuario.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensgagemErro = "";

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty){
      if( senha.isNotEmpty ){
        setState(() {
          _mensgagemErro= "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario( usuario );


      }else{
        setState(() {
          _mensgagemErro = "Preencha a senha!";
        });
      }

    }else{
      setState(() {
        _mensgagemErro = "Preencha o E-mail";
      });
    }
  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      if(usuario.email == "admin@admin.com" && usuario.senha == "admin"){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TelaCandidatos()
            ),ModalRoute.withName("/")
        );
      }else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AbaVagas()
              ),ModalRoute.withName("/")
          );
      }




    }).catchError((error){

      setState(() {
        _mensgagemErro = "Erro na autenticação. Verifique e-mail e senha!";
      });

    });

  }

  Future _verificarUsuarioLogado() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    FirebaseUser usuarioLogado = await auth.currentUser();

    if(usuarioLogado != null){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AbaVagas(),
          )
      );


    }else {

    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff0097C4)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)
                          )
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controllerSenha,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 15,),
                      child: RaisedButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                          ) ,
                        ),
                          color: Colors.grey[50],
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                          ),
                          onPressed:(){

                          _validarCampos();

                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: GestureDetector(
                            child: Text(
                              "Não tem conta? Cadastre-se!",
                              style: TextStyle(
                                color: Colors.grey[50],
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaCadastroCandidato(),
                                  )
                              );
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(
                          child: Text(
                            _mensgagemErro,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                            ),
                          )
                      )
                    )
                  ],
                ),
              )
            ),
          ),
    );
  }
}
