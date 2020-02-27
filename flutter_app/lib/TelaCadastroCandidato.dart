import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/AbaVagas.dart';
import 'package:flutter_app/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TelaCadastroCandidato extends StatefulWidget {
  @override
  _TelaCadastroCandidatoState createState() => _TelaCadastroCandidatoState();
}

class _TelaCadastroCandidatoState extends State<TelaCadastroCandidato> {

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerArea = TextEditingController();
  TextEditingController _controllerIdade = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerHabilidades = TextEditingController();
  String _mensgagemErro = "";
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagem) async {

    File imagemSelecionada;
    switch( origemImagem ){
      case "camera" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if( _imagem != null ){
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  Future _uploadImagem() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perfil")
        .child(_idUsuarioLogado + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent){

      if( storageEvent.type == StorageTaskEventType.progress ){
        setState(() {
          _subindoImagem = true;
        });
      }else if( storageEvent.type == StorageTaskEventType.success ){
        setState(() {
          _subindoImagem = false;
        });
      }

    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });

  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });

  }


  _atualizarUrlImagemFirestore(String url){

    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData( dadosAtualizar );

  }

  _validarCampos() {
    String nome = _controllerNome.text;
    String area = _controllerArea.text;
    String idade = _controllerIdade.text;
    String telefone = _controllerTelefone.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String habilidades = _controllerHabilidades.text;

    if (nome.isNotEmpty && nome.length >= 3) {
      if (area.isNotEmpty) {
        if (idade.isNotEmpty && idade.length <= 3) {
          if (telefone.isNotEmpty && telefone.length >= 11) {
            if (email.isNotEmpty && email.contains("@")) {
              if (senha.isNotEmpty && senha.length > 6) {
                if (habilidades.isNotEmpty) {
                  Usuario usuario = Usuario();
                  usuario.nome = nome;
                  usuario.area = area;
                  usuario.idade = idade;
                  usuario.telefone = telefone;
                  usuario.email = email;
                  usuario.senha = senha;
                  usuario.habilidades = habilidades;

                  _cadastrarusuario(usuario);
                } else {
                  setState(() {
                    _mensgagemErro = "Poxa, conta para gente suas habilidades?";
                  });
                }
              } else {
                setState(() {
                  _mensgagemErro =
                  "Senha Inválida! Digite mais de 6 caracteres";
                });
              }
            } else {
              setState(() {
                _mensgagemErro = "E-mail Inválido";
              });
            }
          } else {
            setState(() {
              _mensgagemErro = "Telefone Inválido";
            });
          }
        } else {
          setState(() {
            _mensgagemErro = "Idade inválida";
          });
        }
      } else {
        setState(() {
          _mensgagemErro = "Preencha sua formação";
        });
      }
    } else {
      setState(() {
        _mensgagemErro = "Preencha o Nome";
      });
    }
  }

  _cadastrarusuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) {

      Firestore db = Firestore.instance;
      
      db.collection("usuarios")
      .document( firebaseUser.uid)
      .setData(usuario.toMap());

      print("passou");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AbaVagas(),
          )
      );

    }).catchError((error) {

      setState(() {
        _mensgagemErro =
        "Erro ao cadastrar, verifique os campos e tente novamente";
      });
    });
  }
  

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Conte um pouco sobre você!"),
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xff0097C4)),
          padding: EdgeInsets.all(16),
          child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[400],
                      backgroundImage:
                      _urlImagemRecuperada != null
                          ? NetworkImage(_urlImagemRecuperada)
                          :null
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            child: Text("Câmera"),
                            onPressed: (){
                              _recuperarImagem("camera");

                            }
                        ),
                        FlatButton(
                          child: Text("Galeria"),
                          onPressed: (){
                            _recuperarImagem("galeria");
                          },
                        )],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: TextField(
                        controller: _controllerNome,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Qual seu nome completo?",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: TextField(
                        controller: _controllerArea,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "O que você estuda/estudou? E onde?",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: TextField(
                        controller: _controllerIdade,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Qual sua idade?",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: TextField(
                        controller: _controllerTelefone,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Qual seu telefone? Com DDD =D",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: TextField(
                        controller: _controllerEmail,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Qual seu e-mail?",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: TextField(
                        controller: _controllerSenha,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Qual vai ser a sua senha?",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: _controllerHabilidades,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 16,),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                100, 50, 100, 50),
                            hintText: "Principais Habilidade",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 15,),
                      child: RaisedButton(
                          child: Text(
                            "Concluir",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.grey[50],
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          onPressed: () {
                            _validarCampos();
                          }
                      ),
                    ),
                    Center(
                        child: Text(
                          _mensgagemErro,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                          ),
                        )
                    )
                  ],
                ),
              )),
        ),
      );
    }
  }
