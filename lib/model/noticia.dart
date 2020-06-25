
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

  Noticia() {}

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
      //TODO colocar conteudos
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  Noticia.fromMapFirebase(Map map) {
    administrador = Usuario.construirComNome(map[colunaNomeAdministrador]);
    titulo = map[colunaTitulo];
    dataHoraPublicacao = DateTime.fromMillisecondsSinceEpoch(map[colunaDataHoraPublicacao]);
  }

  Map toMapFirebase() {
    Map<String, dynamic> map = {
      colunaTitulo: titulo,
      colunaNomeAdministrador: administrador.nome,
      colunaDataHoraPublicacao: dataHoraPublicacao.millisecondsSinceEpoch,
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

  Conteudo() {}

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

  Map toMapFireBase() {
    Map<String, dynamic> map = {
      colunaOrdem : ordem,
      colunaTipoConteudo: tipo,
      colunaTextoConteudo: texto,
    };
    return map;
  }

  Conteudo.fromMapFirebase(Map map) {
    tipo = map[colunaTipoConteudo];
    texto = map[colunaTextoConteudo];
    ordem = map[colunaOrdem];
  }

}