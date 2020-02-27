
class Usuario {

  String _nome;
  String _area;
  String _idade;
  String _telefone;
  String _email;
  String _senha;
  String _habilidades;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic>map = {
      "nome" : this.nome,
      "area": this.area,
      "idade": this.idade,
      "telefone": this.telefone,
      "email": this.email,
      "senha": this.senha,
      "habilidades": this.habilidades,
    };

    return map;
  }

  String get habilidades => _habilidades;

  set habilidades(String value) {
    _habilidades = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get idade => _idade;

  set idade(String value) {
    _idade = value;
  }

  String get area => _area;

  set area(String value) {
    _area = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


}