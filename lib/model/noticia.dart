
import 'dart:io';

import 'package:app_comunica_if/helper/mensagem_helper.dart';

import 'administrador.dart';

class Noticia {

  int id;
  Administrador administrador;
  String titulo;
  DateTime dataHoraPublicacao;
  bool favorita = false;
  List<Conteudo> conteudos = List();

  Noticia() {}

  Noticia.fromMap(Map map) {
    administrador = Administrador.criarComNome(map[colunaNomeAdministrador]);
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

}

class Conteudo {

  static const int TIPO_PARAGRAFO = 1;
  static const int TIPO_IMAGEM = 2;
  static const int TIPO_LINK = 3;

  int id;
  int tipo;
  String texto;
  int idNoticia;

  Conteudo() {}

  Conteudo.fromMap(Map map) {
    id = map[colunaId];
    tipo = map[colunaTipoConteudo];
    texto = map[colunaTextoConteudo];
    idNoticia = map[colunaIdNoticiaFK];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      colunaId: id,
      colunaTipoConteudo: tipo,
      colunaTextoConteudo: texto,
      colunaIdNoticiaFK: idNoticia
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

}