import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';
import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:sqflite/sqflite.dart';

import 'banco_de_dados.dart';

final String tabelaMensagemGrupo = "mensagem_grupo";

final String colunaId = "id";
final String colunaIdMensagemFK = "id_mensagem";
final String colunaIdGrupoFK = "id_grupo";

class MensagemGrupoHelper {

  static String queryCriacaoTabelaMensagemGrupo() {
    return "CREATE TABLE $tabelaMensagemGrupo("
        "$colunaIdMensagemFK TEXT ,"
        "$colunaIdGrupoFK TEXT , "
        "FOREIGN KEY($colunaIdMensagemFK) REFERENCES $tabelaMensagem($colunaId),"
        "FOREIGN KEY($colunaIdGrupoFK) REFERENCES $tabelaGrupoInteresse($colunaId))";
  }

  static Future gravarMensagemGrupo(Mensagem mensagem) async {
    Database banco = await BancoDeDados().banco;
    for(Grupo g in mensagem.gruposInteresse) {
      Map<String, dynamic> map = {
        colunaIdMensagemFK : mensagem.id,
        colunaIdGrupoFK : g.id
      };
      print(" **** $map");
      await banco.insert(tabelaMensagemGrupo, map);
    }
    return mensagem;
  }
}