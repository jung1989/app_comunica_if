

import 'package:app_comunica_if/model/noticia.dart';
import 'package:sqflite/sqflite.dart';

import 'banco_de_dados.dart';
import 'noticia_helper.dart';

final String tabelaConteudoNoticia = "conteudo_noticia";

final String colunaTextoConteudo = "texto_conteudo";
final String colunaTipoConteudo = "tipo_conteudo";
final String colunaIdNoticiaFK = "id_noticia";
final String colunaOrdem = "ordem";

class ConteudoNoticia {

  static String queryCriacaoTabelaConteudoNoticia() {
    return "CREATE TABLE $tabelaConteudoNoticia($colunaId TEXT PRIMARY KEY ,"
        "$colunaTipoConteudo INTEGER , "
        "$colunaTextoConteudo TEXT , "
        "$colunaNomeAdministrador TEXT ,"
        "$colunaIdNoticiaFK INTEGER , "
        "FOREIGN KEY($colunaIdNoticiaFK) REFERENCES $tabelaNoticia($colunaId))";
  }

  /// CRUD CONTEUDO NOTICIA ///
  static Future<Conteudo> gravarConteudo(Conteudo conteudo) async {
    Database conteudos = await BancoDeDados().banco;
    await conteudos.insert(tabelaConteudoNoticia, conteudo.toMap());
    return conteudo;
  }

  static Future<Conteudo> lerConteudo(int id) async {
    Database conteudos = await BancoDeDados().banco;
    List<Map> consulta = await conteudos.query(tabelaConteudoNoticia,
        columns: [
          colunaId,
          colunaTextoConteudo,
          colunaTipoConteudo,
          colunaIdNoticiaFK
        ],
        where: "$colunaId = ?",
        whereArgs: [id]);

    if (consulta.length > 0) {
      return Conteudo.fromMap(consulta.first);
    }
    else {
      return null;
    }
  }

  static Future<List<Conteudo>> lerConteudosPorNoticia(String idNoticia) async {
    Database conteudos = await BancoDeDados().banco;
    List<Map> consulta = await conteudos.query(tabelaConteudoNoticia,
        columns: [
          colunaId,
          colunaTextoConteudo,
          colunaTipoConteudo,
          colunaIdNoticiaFK
        ],
        where: "$colunaIdNoticiaFK = ?",
        whereArgs: [idNoticia]);


    List<Conteudo> lista = List();
    for (Map conteudo in consulta) {
      lista.add(Conteudo.fromMap(conteudo));
    }
    return lista;
  }

  static Future<int> atualizarConteudo(Conteudo conteudo) async {
    Database conteudos = await BancoDeDados().banco;
    return await conteudos.update(tabelaConteudoNoticia, conteudo.toMap(),
        where: "$colunaId = ?",
        whereArgs: [conteudo.id]);
  }

  static Future<int> removerConteudo(int id) async {
    Database conteudos = await BancoDeDados().banco;
    return await conteudos.delete(tabelaConteudoNoticia,
        where: "$colunaId = ?",
        whereArgs: [id]);
  }

}
