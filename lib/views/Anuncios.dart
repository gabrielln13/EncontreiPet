import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei_pet/main.dart';
import 'package:encontrei_pet/views/widgets/ItemAnuncio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/Anuncio.dart';
import '../util/Configuracoes.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  late List<DropdownMenuItem<String>> _listaItensDropPorte;
  late List<DropdownMenuItem<String>> _listaItensDropChip;
  late List<DropdownMenuItem<String>> _listaItensDropSexo;
  late List<DropdownMenuItem<String>> _listaItensDropTemperamento;
  late List<DropdownMenuItem<String>> _listaItensDropIdade;
  late List<DropdownMenuItem<String>> _listaItensDropEspecie;
  late List<DropdownMenuItem<String>> _listaItensDropEstados;

  final _controler = StreamController<QuerySnapshot>.broadcast();

  String? _itemSelecionadoPorte;
  String? _itemSelecionadoChip;
  String? _itemSelecionadoSexo;
  String? _itemSelecionadoTemperamento;
  String? _itemSelecionadoIdade;
  String? _itemSelecionadoEspecie;
  String? _itemSelecionadoEstado;

  late DocumentSnapshot lastDocument;
  bool hasMore = true;

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future _verificaUsuarioLogado() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
  }

  _carregarItensDropdown() {
    //Listas de PORTE
    _listaItensDropPorte = Configuracoes.getPorte();
    //Listas de CHIP
    _listaItensDropChip = Configuracoes.getChip();
    //Listas de SEXO
    _listaItensDropSexo = Configuracoes.getSexo();
    //Listas de TEMPERAMENTO
    _listaItensDropTemperamento = Configuracoes.getTemperamento();
    //Listas de IDADE
    _listaItensDropIdade = Configuracoes.getIdade();
    //Listas de ESPECIE
    _listaItensDropEspecie = Configuracoes.getEspecie();
    //Listas de ESTADO
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? usuarioLogado = await auth.currentUser;
    // if(usuarioLogado != null){
    //   final uid = usuarioLogado.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .where("situacao", isEqualTo: "Disponível")
        // .where("idUsuario", isNotEqualTo: uid)
        .orderBy("dataCadastro", descending: true)
        .snapshots();
    stream.listen((dados) {
      _controler.add(dados);
    });
  // }
  }

  Future<Stream<QuerySnapshot>?> _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");

    if (_itemSelecionadoSexo != null) {
      query = query.where("sexo", isEqualTo: _itemSelecionadoSexo);
    }
    if (_itemSelecionadoPorte != null) {
      query = query.where("porte", isEqualTo: _itemSelecionadoPorte);
    }
    if (_itemSelecionadoChip != null) {
      query = query.where("chip", isEqualTo: _itemSelecionadoChip);
    }
    if (_itemSelecionadoTemperamento != null) {
      query = query.where("temperamento", isEqualTo: _itemSelecionadoTemperamento);
    }
    if (_itemSelecionadoIdade != null) {
      query = query.where("idade", isEqualTo: _itemSelecionadoIdade);
    }
    if (_itemSelecionadoEspecie != null) {
      query = query.where("especie", isEqualTo: _itemSelecionadoEspecie);
    }
    if (_itemSelecionadoEstado != null) {
      query = query.where("uf", isEqualTo: _itemSelecionadoEstado);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controler.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();

    _carregarItensDropdown();
    _verificaUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando anúncios...",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Anúncios",
          style: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,

        //FILTROS
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {


                    return AlertDialog(
                      title: Text("Filtros"),
                      content:StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                //FILTRO ESTADO
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoEstado,
                                  items: _listaItensDropEstados,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (uf) {
                                    setState(() {
                                      _itemSelecionadoEstado = uf as String?;
                                    });
                                  },
                                ),

                                //FILTRO ESPECIE
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoEspecie,
                                  items: _listaItensDropEspecie,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (especie) {
                                    setState(() {
                                      _itemSelecionadoEspecie = especie as String?;
                                    });
                                  },
                                ),

                                //FILTRO SEXO
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoSexo,
                                  items: _listaItensDropSexo,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (sexo) {
                                    setState(() {
                                      _itemSelecionadoSexo = sexo as String?;
                                    });
                                  },
                                ),

                                // FILTRO PORTE
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoPorte,
                                  items: _listaItensDropPorte,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (porte) {
                                    setState(() {
                                      _itemSelecionadoPorte = porte as String?;
                                    });
                                  },
                                ),

                                //FILTRO IDADE
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoIdade,
                                  items: _listaItensDropIdade,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (idade) {
                                    setState(() {
                                      _itemSelecionadoIdade = idade as String?;
                                    });
                                  },
                                ),

                                //FILTRO TEMPERAMENTO
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoTemperamento,
                                  items: _listaItensDropTemperamento,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (temperamento) {
                                    setState(() {
                                      _itemSelecionadoTemperamento = temperamento as String?;
                                    });
                                  },
                                ),

                                //FILTRO CHIP
                                DropdownButton(
                                  iconEnabledColor: temaPadrao.primaryColor,
                                  value: _itemSelecionadoChip,
                                  items: _listaItensDropChip,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  onChanged: (chip) {
                                    setState(() {
                                      _itemSelecionadoChip = chip as String?;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                              child: Text("Limpar filtros",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),),
                              onPressed: () {
                                _adicionarListenerAnuncios();
                                _itemSelecionadoSexo = _listaItensDropSexo[0].value;
                                _itemSelecionadoPorte = _listaItensDropPorte[0].value;
                                _itemSelecionadoChip = _listaItensDropChip[0].value;
                                _itemSelecionadoTemperamento = _listaItensDropTemperamento[0].value;
                                _itemSelecionadoIdade = _listaItensDropIdade[0].value;
                                _itemSelecionadoEspecie = _listaItensDropEspecie[0].value;
                                _itemSelecionadoEstado = _listaItensDropEstados[0].value;
                                Navigator.of(context).pop();
                              },
                            ),
                            MaterialButton(
                              child: Text("Aplicar",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),),
                              onPressed: () {
                                _filtrarAnuncios();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            },
          ),
        ],

      ),

      body: Container(
        child: Column(
          children: <Widget>[
            //LISTAGEM DE ANÚNCIOS
            StreamBuilder(
              stream: _controler.stream,
              //        db.collection("anuncios").orderBy(
              // "dataCadastro", descending: true).snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot =
                    snapshot.data as QuerySnapshot;

                    if (querySnapshot.docs.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Nenhum anúncio!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> anuncios =
                            querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot =
                            anuncios[indice];
                            Anuncio anuncio =
                            Anuncio.fromDocumentSnapshot(documentSnapshot);

                            return ItemAnuncio(
                              anuncio: anuncio,
                              onTapItem: () {
                                Navigator.pushNamed(
                                    context, "/detalhes-anuncio",
                                    arguments: anuncio);
                              },
                            );
                          }),
                    );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
