

import 'dart:math';

import 'package:app_comunica_if/model/dica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SistemaDicas {
  /// implementação do singleton
  static final SistemaDicas _instance = SistemaDicas._interno();

  factory SistemaDicas() => _instance;

  static SistemaDicas get instance => _instance;

  List<Dica> _dicas;

  SistemaDicas._interno();

  Future<void> inicializar() async {
    _dicas = await carregarDicas();
  }

  Dica buscarDicaAleatoria()  {
    return _dicas[Random().nextInt(_dicas.length)];
  }

  /// carregamento de todas as dicas armazenadas no Firebase
  Future<List<Dica>> carregarDicas() async {
    List<Dica> dicas = List();
    QuerySnapshot querySnapshot =
    await Firestore.instance.collection("dicas")
    .where("ativo",isEqualTo: true)
        .getDocuments();
    querySnapshot.documents.forEach((dica) {
      Dica d = Dica.fromMap(dica.data);
      d.id = dica.documentID;
      dicas.add(d);
    });
    return dicas;
  }

}