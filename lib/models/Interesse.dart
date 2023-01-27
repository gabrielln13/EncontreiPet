
import 'package:cloud_firestore/cloud_firestore.dart';

class Interesse{
  String? _id;
  String? _idUsuarioInteressado;
  String? _descricao;
  Timestamp? _dataCadastro;
  String? _idAnuncio;

  Interesse();

  Interesse.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot.id;
    this.idUsuarioInteressado = documentSnapshot["idUsuarioInteressado"];
    this.descricao  = documentSnapshot["descricao"];
    this.dataCadastro  = documentSnapshot["dataCadastro"];
    this.idAnuncio = documentSnapshot["idAnuncio"];

  }



  Interesse.gerarId(){

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference interesse = db.collection("interesse-adocao"); //acessar pasta interesse de adoção
    this.id = interesse.doc().id; // pegar id gerado do interesse e inicializá-lo
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : id,
      "idUsuarioInteressado" : idUsuarioInteressado,
      "descricao" : descricao,
      "dataCadastro" : dataCadastro,
      "idAnuncio" : idAnuncio,
    };

    return map;
  }

  String get idAnuncio => _idAnuncio!;

  set idAnuncio(String value) {
    _idAnuncio = value;
  }

  Timestamp get dataCadastro => _dataCadastro!;

  set dataCadastro(Timestamp value) {
    _dataCadastro = value;
  }

  String get descricao => _descricao!;

  set descricao(String value) {
    _descricao = value;
  }

  String get idUsuarioInteressado => _idUsuarioInteressado!;

  set idUsuarioInteressado(String value) {
    _idUsuarioInteressado = value;
  }

  String get id => _id!;

  set id(String value) {
    _id = value;
  }
}