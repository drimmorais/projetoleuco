
class Vaga {
  String _nome;
  String _nivel;
  String _requisitos;
  String _descricao;
  String _email;

  Vaga();

  Map<String, dynamic> toMap(){
    Map<String, dynamic>map = {
      "nome" : this.nome,
      "nivel": this.nivel,
      "requisitos": this.requisitos,
      "descricao": this.descricao,
      "email": this.email,
    };

    return map;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get requisitos => _requisitos;

  set requisitos (String value) {
    _requisitos = value;
  }

  String get nivel => _nivel;

  set nivel(String value) {
    _nivel = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


}