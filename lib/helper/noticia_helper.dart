
import 'package:app_comunica_if/helper/banco_de_dados.dart';
import 'package:app_comunica_if/helper/conteudo_noticia_helper.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:sqflite/sqflite.dart';

final String tabelaNoticia = "noticia";
final String colunaId = "id";
final String colunaTitulo = "titulo";
final String colunaDataHoraPublicacao = "data_hora_publicacao";
final String colunaLida = "lida";
final String colunaFavorita = "favorita";
final String colunaNomeAdministrador = "nome_administrador";

class NoticiaHelper {

  static String queryCriacaoTabelaNoticias() {
    return "CREATE TABLE $tabelaNoticia($colunaId TEXT PRIMARY KEY ,"
        "$colunaTitulo TEXT , "
        "$colunaDataHoraPublicacao INTEGER , "
        "$colunaFavorita INTEGER , "
        "$colunaNomeAdministrador TEXT )";
  }

  /// CRUD NOTICIAS ///
  static Future<Noticia> gravarNoticia(Noticia noticia) async {
    Database noticias = await BancoDeDados().banco;
    await noticias.insert(tabelaNoticia, noticia.toMap());
    for (Conteudo c in noticia.conteudos) {
      //print("Gravando ${c.toMap()}");
      ConteudoNoticia.gravarConteudo(c);
    }
    return noticia;
  }

  static Future<Noticia> lerNoticia(int id) async {
    Database noticias = await BancoDeDados().banco;
    List<Map> consulta = await noticias.query(tabelaNoticia,
        columns: [
          colunaId,
          colunaTitulo,
          colunaNomeAdministrador,
          colunaFavorita
        ],
        where: "$colunaId = ?",
        whereArgs: [id]);

    if (consulta.length > 0) {
      return Noticia.fromMap(consulta.first);
    }
    else {
      return null;
    }
  }

  static Future<List> lerNoticias() async {
    Database noticias = await BancoDeDados().banco;
    List<Map> consulta = await noticias.rawQuery(
        "SELECT * FROM $tabelaNoticia");

    List<Noticia> lista = List();
    for (Map noticia in consulta) {
      Noticia n = Noticia.fromMap(noticia);
      n.conteudos = await ConteudoNoticia.lerConteudosPorNoticia(n.id);
      lista.add(n);
    }
    return lista;
  }

  static Future<int> atualizarNoticia(Noticia noticia) async {
    Database noticias = await BancoDeDados().banco;
    return await noticias.update(tabelaNoticia, noticia.toMap(),
        where: "$colunaId = ?",
        whereArgs: [noticia.id]);
  }

  static Future<int> removerNoticia(int id) async {
    Database noticias = await BancoDeDados().banco;
    return await noticias.delete(tabelaNoticia,
        where: "$colunaId = ?",
        whereArgs: [id]);
  }

  static Future<DateTime> dataHoraUltimaNoticiaArmazenada() async {
    Database noticias = await BancoDeDados().banco;
    List<Map> consulta = await noticias.query(tabelaNoticia,
        columns: [colunaDataHoraPublicacao],
        orderBy: colunaDataHoraPublicacao);

    if(consulta.length > 0) {
      return DateTime.fromMillisecondsSinceEpoch(consulta.last[colunaDataHoraPublicacao]);
    }
  }

}