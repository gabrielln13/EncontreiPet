
import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String? _id;
  String? _nome;
  String? _raca;
  String? _cor;
  String? _porte;
  String? _temperamento;
  String? _idade;
  String? _chip;
  String? _numeroChip;
  String? _situacao;
  String? _sexo;
  String? _vacinacao;
  String? _doenca;
  String? _descricao;
  String? _especie;
  Timestamp? _dataCadastro;
  String? _idUsuario;
  String? _cep;
  String? _cidade;
  String? _uf;
  String? _bairro;
  String? _logradouro;
  String? _quadra;
  String? _numero;
  String? _lote;
  List<String>? _fotos;


  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    this.id = documentSnapshot.id;
    this.nome = map["nome"];
    this.raca = map["raca"];
    this.cor = map["cor"];
    this.porte = map["porte"];
    this.temperamento = map["temperamento"];
    this.idade = map["idade"];
    this.chip = map["chip"];
    this.numeroChip = map["numeroChip"];
    this.situacao = map["situacao"];
    this.sexo = map["sexo"];
    this.vacinacao = map["vacinacao"];
    this.doenca = map["doenca"];
    this.descricao = map["descricao"] ?? "";
    this.especie = map["especie"];
    this.dataCadastro = map["dataCadastro"];
    this.idUsuario = map["idUsuario"];
    this.cep = map["cep"];
    this.cidade = map["cidade"];
    this.uf = map["uf"];
    this.bairro = map["bairro"];
    this.logradouro = map["logradouro"];
    this.quadra = map["quadra"];
    this.numero = map["numero"];
    this.lote = map["lote"];
    this.fotos = List<String>.from(map["fotos"]);
  }


  Anuncio.gerarId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios"); //acessar pasta anuncio
    this.id = anuncios.doc().id; // pegar id gerado do anuncio e inicializá-lo
    this.fotos = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "nome": nome,
      "raca": raca,
      "cor": cor,
      "porte": porte,
      "temperamento": temperamento,
      "idade": idade,
      "chip": chip,
      "numeroChip": numeroChip,
      "situacao": situacao,
      "sexo": sexo,
      "vacinacao": vacinacao,
      "doenca": doenca,
      "descricao": descricao,
      "especie": especie,
      "dataCadastro": dataCadastro,
      "idUsuario": idUsuario,
      "cep": cep,
      "cidade": cidade,
      "uf": uf,
      "bairro": bairro,
      "logradouro": logradouro,
      "quadra": quadra,
      "numero": numero,
      "lote": lote,
      "fotos": fotos
    };

    return map;
  }

  List<String> get fotos => _fotos!;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get lote => _lote!;

  set lote(String value) {
    _lote = value;
  }

  String get numero => _numero!;

  set numero(String value) {
    _numero = value;
  }

  String get quadra => _quadra!;

  set quadra(String value) {
    _quadra = value;
  }

  String get logradouro => _logradouro!;

  set logradouro(String value) {
    _logradouro = value;
  }

  String get bairro => _bairro!;

  set bairro(String value) {
    _bairro = value;
  }

  String get uf => _uf!;

  set uf(String value) {
    _uf = value;
  }

  String get cidade => _cidade!;

  set cidade(String value) {
    _cidade = value;
  }

  String get cep => _cep!;

  set cep(String value) {
    _cep = value;
  }

  String get idUsuario => _idUsuario!;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  Timestamp get dataCadastro => _dataCadastro!;

  set dataCadastro(Timestamp value) {
    _dataCadastro = value;
  }

  String get especie => _especie!;

  set especie(String value) {
    _especie = value;
  }

  String get descricao => _descricao!;

  set descricao(String value) {
    _descricao = value;
  }

  String get doenca => _doenca!;

  set doenca(String value) {
    _doenca = value;
  }

  String get vacinacao => _vacinacao!;

  set vacinacao(String value) {
    _vacinacao = value;
  }

  String get sexo => _sexo!;

  set sexo(String value) {
    _sexo = value;
  }

  String get situacao => _situacao!;

  set situacao(String value) {
    _situacao = value;
  }

  String get numeroChip => _numeroChip!;

  set numeroChip(String value) {
    _numeroChip = value;
  }

  String get chip => _chip!;

  set chip(String value) {
    _chip = value;
  }

  String get idade => _idade!;

  set idade(String value) {
    _idade = value;
  }

  String get temperamento => _temperamento!;

  set temperamento(String value) {
    _temperamento = value;
  }

  String get porte => _porte!;

  set porte(String value) {
    _porte = value;
  }

  String get cor => _cor!;

  set cor(String value) {
    _cor = value;
  }

  String get raca => _raca!;

  set raca(String value) {
    _raca = value;
  }

  String get nome => _nome!;

  set nome(String value) {
    _nome = value;
  }

  String get id => _id!;

  set id(String value) {
    _id = value;
  }
}