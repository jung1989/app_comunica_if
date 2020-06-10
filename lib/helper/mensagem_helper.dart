

import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';
import 'package:app_comunica_if/helper/mensagem_grupo_helper.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'banco_de_dados.dart';


final String tabelaMensagem = "mensagem";


final String colunaId = "id";
final String colunaTitulo = "titulo";
final String colunaConteudo = "conteudo";
final String colunaDataHoraPublicacao = "data_hora_publicacao";
final String colunaLida = "lida";
final String colunaFavorita = "favorita";
final String colunaNomeAdministrador = "nome_administrador";
final String colunaTextoConteudo = "texto_conteudo";
final String colunaTipoConteudo = "tipo_conteudo";
final String colunaIdNoticiaFK = "id_noticia";

class MensagemHelper {

  static String queryCriacaoTabelaMensagens() {
    return "CREATE TABLE $tabelaMensagem($colunaId INTEGER PRIMARY KEY ,"
        "$colunaTitulo TEXT , "
        "$colunaConteudo TEXT , "
        "$colunaDataHoraPublicacao INTEGER , "
        "$colunaLida INTEGER , "
        "$colunaFavorita INTEGER , "
        "$colunaNomeAdministrador TEXT )";
  }



  /// CRUD MENSAGENS ///
  static Future<Mensagem> gravarMensagem(Mensagem mensagem) async {
    Database mensagens = await BancoDeDados().banco;
    mensagem.id = await mensagens.insert(tabelaMensagem, mensagem.toMap());
    MensagemGrupoHelper.gravarMensagemGrupo(mensagem);
    return mensagem;
  }

  static Future<Mensagem> lerMensagem(int id) async {
    Database banco = await BancoDeDados().banco;
    List<Map> consulta = await banco.query(tabelaMensagem,
      columns: [colunaId,colunaTitulo,colunaConteudo,colunaNomeAdministrador,colunaLida,colunaFavorita],
      where: "$colunaId = ?",
      whereArgs: [id]);

    if(consulta.length > 0) {
      Mensagem mensagem = Mensagem.fromMap(consulta.first);
      List<Map> consultaGrupos = await banco.rawQuery("SELECT g.$colunaId, g.$colunaNome, g.$colunaSelecionado"
                                                " FROM $tabelaGrupoInteresse g , $tabelaMensagem m, $tabelaMensagemGrupo mg"
                                                " WHERE mg.$colunaIdMensagemFK = m.$colunaId AND "
                                                        "mg.$colunaIdGrupoFK = g.$colunaId");

      for(Map grupo in consultaGrupos) {
        mensagem.gruposInteresse.add(Grupo.fromMap(grupo));
      }

      return mensagem;
    }
    else {
      return null;
    }
  }


  static Future<List<Grupo>> lerMensagensGrupo(Mensagem mensagem) async {

    Database banco = await BancoDeDados().banco;

    List<Map> consultaGrupos = await banco.rawQuery(
        " SELECT "
            "g.$colunaId, g.$colunaNome, g.$colunaSelecionado"
        " FROM $tabelaGrupoInteresse g "
            " INNER JOIN $tabelaMensagemGrupo mg ON mg.$colunaIdGrupoFK = g.$colunaId"
            " INNER JOIN $tabelaMensagem m       ON mg.$colunaIdMensagemFK = m.$colunaId"
        " GROUP BY g.$colunaId");

//    print(consultaGrupos);
//
//    List<Map> consultaTeste = await banco.rawQuery("SELECT * FROM $tabelaMensagemGrupo");
//    print(">>>> $consultaTeste");

    List<Grupo> lista = List();

    for(Map grupo in consultaGrupos) {
      lista.add(Grupo.fromMap(grupo));
    }
    return lista;
  }

    static Future<List<Mensagem>> lerMensagensLidas(bool lidas) async {
    Database banco = await BancoDeDados().banco;

    List<Map> consulta = await banco.rawQuery(
        " SELECT "
            " m.$colunaId, m.$colunaTitulo, m.$colunaConteudo, m.$colunaNomeAdministrador, m.$colunaLida, m.$colunaFavorita, m.$colunaDataHoraPublicacao "
        " FROM $tabelaMensagem m "
            " INNER JOIN $tabelaMensagemGrupo mg ON mg.$colunaIdMensagemFK = m.$colunaId"
            " INNER JOIN $tabelaGrupoInteresse g ON mg.$colunaIdGrupoFK    = g.$colunaId"
        " WHERE m.$colunaLida = ${lidas?1:0} AND g.$colunaSelecionado = 1"
        " GROUP BY m.$colunaId");

    List<Mensagem> lista = List();
    for(Map m in consulta) {
      Mensagem mensagem = Mensagem.fromMap(m);
      mensagem.gruposInteresse = await lerMensagensGrupo(mensagem);
      lista.add(mensagem);
    }
    return lista;
  }

  static Future<List<Mensagem>> lerMensagensFavoritas(bool favoritas) async {
    Database banco = await BancoDeDados().banco;

    List<Map> consulta = await banco.rawQuery(
        " SELECT "
            " m.$colunaId, m.$colunaTitulo, m.$colunaConteudo, m.$colunaNomeAdministrador, m.$colunaLida, m.$colunaFavorita, m.$colunaDataHoraPublicacao "
            " FROM $tabelaMensagem m "
            " INNER JOIN $tabelaMensagemGrupo mg ON mg.$colunaIdMensagemFK = m.$colunaId"
            " INNER JOIN $tabelaGrupoInteresse g ON mg.$colunaIdGrupoFK    = g.$colunaId"
            " WHERE m.$colunaFavorita = ${favoritas?1:0} AND g.$colunaSelecionado = 1"
            " GROUP BY m.$colunaId");

    List<Mensagem> lista = List();
    for(Map mensagem in consulta) {
      lista.add(Mensagem.fromMap(mensagem));
    }
    return lista;
  }

  static Future<List> lerMensagens() async {
    Database mensagens = await BancoDeDados().banco;
    List<Map> consulta = await mensagens.rawQuery("SELECT * FROM $tabelaMensagem");
    List<Mensagem> lista = List();
    for(Map mensagem in consulta) {
      lista.add(Mensagem.fromMap(mensagem));
    }
    return lista;
  }

  static Future<int> atualizarMensagem(Mensagem mensagem) async {
    Database mensagens = await BancoDeDados().banco;
    print(mensagem.toMap());
    return await mensagens.update(tabelaMensagem, mensagem.toMap(),
                                  where: "$colunaId = ?",
                                  whereArgs: [mensagem.id]);
  }

  static Future<int> removerMensagem(int id) async {
    Database mensagens = await BancoDeDados().banco;
    return await mensagens.delete(tabelaMensagem,
                                  where: "$colunaId = ?",
                                  whereArgs: [id]);
  }






  /// FUNCOES AUXILIARES


  static Future<DateTime> dataHoraUltimaMensagemArmazenada() async {
    Database mensagens = await BancoDeDados().banco;
    List<Map> consulta = await mensagens.query(tabelaMensagem,
        columns: [colunaDataHoraPublicacao],
        orderBy: colunaDataHoraPublicacao);

    if(consulta.length > 0) {
      return DateTime.fromMillisecondsSinceEpoch(consulta.last[colunaDataHoraPublicacao]);
    }
  }


  static List<Mensagem> filtrarMensagensPorGrupos(List<Mensagem> mensagensBanco) {
    List<Mensagem> mensagens = List();

    int c =0;

    for(Mensagem m in mensagensBanco) {
      for(Grupo gm in m.gruposInteresse) {
        print(">>>>>>> ${gm.nome}");

        for (Grupo gu in SistemaUsuario().usuario.gruposInteresse) {
          if (gu.selecionado && gm.id == gu.id) {
            c++;
            print(" $c >>> ${gu.nome}");
            mensagens.add(m);
            break;
          }
        }
      }
    }

    return mensagens;
  }
}