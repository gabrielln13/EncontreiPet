import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {

  // Configuraçoes para PORTE
  static List<DropdownMenuItem<String>> getPorte() {
    List<DropdownMenuItem<String>> itensDropPorte = [];

    //ITENS
    itensDropPorte.add(
        DropdownMenuItem(child: Text(
          "Porte", style: TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    itensDropPorte.add(
        DropdownMenuItem(child: Text("Pequeno"), value: "Pequeno",)
    );

    itensDropPorte.add(
        DropdownMenuItem(child: Text("Médio"), value: "Médio",)
    );

    itensDropPorte.add(
        DropdownMenuItem(child: Text("Grande"), value: "Grande",)
    );

    return itensDropPorte;
  }

// Configuraçoes para TEMPERAMENTO
  static List<DropdownMenuItem<String>> getTemperamento() {
    List<DropdownMenuItem<String>> itensDropTemperamento = [];

    //ITENS
    itensDropTemperamento.add(
        DropdownMenuItem(child: Text(
          "Temperamento", style: TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    itensDropTemperamento.add(
        DropdownMenuItem(child: Text("Dócil"), value: "Dócil",)
    );

    itensDropTemperamento.add(
        DropdownMenuItem(child: Text("Bravo"), value: "Bravo",)
    );
    return itensDropTemperamento;
  }

  // Configuraçoes para CHIP
  static List<DropdownMenuItem<String>> getChip() {
    List<DropdownMenuItem<String>> itensDropChip = [];

    //ITENS
    itensDropChip.add(
        DropdownMenuItem(child: Text(
          "Possui Chip?", style: TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    itensDropChip.add(
        DropdownMenuItem(child: Text("Sim"), value: "Sim",)
    );

    itensDropChip.add(
        DropdownMenuItem(child: Text("Não"), value: "Não",)
    );
    return itensDropChip;
  }

  // Configuraçoes para SEXO
  static List<DropdownMenuItem<String>> getSexo() {
    List<DropdownMenuItem<String>> itensDropSexo = [];

    //ITENS
    itensDropSexo.add(
        DropdownMenuItem(child: Text(
          "Sexo", style: TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    itensDropSexo.add(
        DropdownMenuItem(child: Text("Macho"), value: "Macho",)
    );

    itensDropSexo.add(
        DropdownMenuItem(child: Text("Fêmea"), value: "Fêmea",)
    );
    return itensDropSexo;
  }

  // Configuraçoes para SITUAÇÃO
  static List<DropdownMenuItem<String>> getSituacao() {
    List<DropdownMenuItem<String>> itensDropSituacao = [];

    //ITENS
    itensDropSituacao.add(
        DropdownMenuItem(child: Text(
          "Situação", style:  TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    itensDropSituacao.add(
        DropdownMenuItem(child: Text("Disponível"), value: "Disponível",)
    );

    itensDropSituacao.add(
        DropdownMenuItem(child: Text("Indisponível"), value: "Indisponível",)
    );
    return itensDropSituacao;
  }

  // Configuraçoes para ESPECIE
  static List<DropdownMenuItem<String>> getEspecie() {
    List<DropdownMenuItem<String>> itensDropEspecie = [];

    //ITENS
    itensDropEspecie.add(
        DropdownMenuItem(child: Text(
          "Espécie", style:  TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    itensDropEspecie.add(
        DropdownMenuItem(child: Text("Cachorro"), value: "Cachorro",)
    );

    itensDropEspecie.add(
        DropdownMenuItem(child: Text("Gato"), value: "Gato",)
    );
    return itensDropEspecie;
  }

  // Configuraçoes para SITUAÇÃO
  static List<DropdownMenuItem<String>> getIdade() {
    List<DropdownMenuItem<String>> idade = [];

    //ITENS
    idade.add(
        DropdownMenuItem(child: Text(
          "Idade", style:  TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    for (int i = 1; i <= 10; i++) {
      idade.add(DropdownMenuItem(
        child: Text(i.toString()),
        value: i.toString(),
      ));
    }
    return idade;
  }

  // Configuraçoes para ESTADOS
  static List<DropdownMenuItem<String>> getEstados(){

    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    //ITENS
    listaItensDropEstados.add(
        DropdownMenuItem(child: Text(
          "UF", style: TextStyle(
            color: Color(0xff2BBDEE)
        ),
        ), value: null,)
    );

    for( var estado in Estados.listaEstadosSigla ){
      listaItensDropEstados.add(
          DropdownMenuItem(child: Text(estado), value: estado,)
      );
    }

    return listaItensDropEstados;

  }

}