class Usuario{

  late String _cpf;
  late String _nome;
  late String _email;
  late String _telefone;
  late String _senha;

  Usuario();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "cpf"      : this.cpf,
      "nome"     : this.nome,
      "email"    : this.email,
      "telefone" : this.telefone,

    };

    return map;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }
}