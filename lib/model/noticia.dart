
import 'dart:io';

import 'package:app_comunica_if/helper/conteudo_noticia_helper.dart';
import 'package:app_comunica_if/helper/noticia_helper.dart';
import 'package:app_comunica_if/model/usuario.dart';

class Noticia {

  String id;
  Usuario administrador;
  String titulo;
  DateTime dataHoraPublicacao;
  bool favorita = false;
  List<Conteudo> conteudos = List();

  String linkWeb = "";

  Noticia();

  Noticia.fromMap(Map map) {
    administrador = Usuario.construirComNome(map[colunaNomeAdministrador]);
    id = map[colunaId];
    titulo = map[colunaTitulo];
    dataHoraPublicacao = DateTime.fromMillisecondsSinceEpoch(map[colunaDataHoraPublicacao]);
    favorita = map[colunaFavorita]==0?false:true;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      colunaId: id,
      colunaTitulo: titulo,
      colunaNomeAdministrador: administrador.nome,
      colunaDataHoraPublicacao: dataHoraPublicacao.millisecondsSinceEpoch,
      colunaFavorita: favorita?1:0
      /// colocar conteudos
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  /// constrói uma notícia a partir no map obtido da consulta no Firebase
  Noticia.fromMapFirebase(Map map) {
    administrador = Usuario.construirComNome(map[colunaNomeAdministrador]);
    titulo = map[colunaTitulo];
    dataHoraPublicacao = DateTime.fromMillisecondsSinceEpoch(map[colunaDataHoraPublicacao]);
    linkWeb = map.containsKey('web') ? map['web'] : "";
  }

  /// converte a notícia para uma map para gravação no Firebase
  Map toMapFirebase() {
    Map<String, dynamic> map = {
      colunaTitulo: titulo,
      colunaNomeAdministrador: administrador.nome,
      colunaDataHoraPublicacao: dataHoraPublicacao.millisecondsSinceEpoch,
      'web' : linkWeb,
    };
    return map;
  }

}

class Conteudo {

  static const int TIPO_PARAGRAFO = 1;
  static const int TIPO_IMAGEM = 2;
  static const int TIPO_LINK = 3;

  String id;
  int tipo;
  String texto;
  int idNoticia;
  int ordem;

  File imagem;

  Conteudo();

  Conteudo.fromMap(Map map) {
    id = map[colunaId];
    tipo = map[colunaTipoConteudo];
    texto = map[colunaTextoConteudo];
    idNoticia = map[colunaIdNoticiaFK];
    ordem = map[colunaOrdem];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      colunaId: id,
      colunaTipoConteudo: tipo,
      colunaTextoConteudo: texto,
      colunaIdNoticiaFK: idNoticia,
      colunaOrdem: ordem
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  /// converte o conteúdo para uma map para gravação no Firebase
  Map toMapFireBase() {
    Map<String, dynamic> map = {
      colunaOrdem : ordem,
      colunaTipoConteudo: tipo,
      colunaTextoConteudo: texto,
    };
    return map;
  }

  /// constrói um conteúdo a partir no map obtido da consulta no Firebase
  Conteudo.fromMapFirebase(Map map) {
    tipo = map[colunaTipoConteudo];
    texto = map[colunaTextoConteudo];
    ordem = map[colunaOrdem];
  }

}