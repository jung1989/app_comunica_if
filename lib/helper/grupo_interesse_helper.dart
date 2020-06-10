
import 'package:app_comunica_if/model/grupo.dart';
import 'package:sqflite/sqflite.dart';

import 'banco_de_dados.dart';

final String tabelaGrupoInteresse = "grupo_interesse";
final String colunaId = "id";
final String colunaNome = "titulo";
final String colunaSelecionado = "selecionado";

class GrupoInteresseHelper {

  static String queryCriacaoTabelaGruposInteresse() {
    return "CREATE TABLE $tabelaGrupoInteresse($colunaId INTEGER PRIMARY KEY ,"
        "$colunaNome TEXT , "
        "$colunaSelecionado INTEGER)";
  }


  /// CRUD MENSAGENS ///
  static Future<Grupo> gravarGrupo(Grupo grupo) async {
    Database banco = await BancoDeDados().banco;
    grupo.id = await banco.insert(tabelaGrupoInteresse, grupo.toMap());
    return grupo;
  }

  static Future<Grupo> lerGrupo(int id) async {
    Database banco = await BancoDeDados().banco;
    List<Map> consulta = await banco.query(tabelaGrupoInteresse,
        columns: [colunaId,colunaNome,colunaSelecionado],
        where: "$colunaId = ?",
        whereArgs: [id]);

    if(consulta.length > 0) {
      return Grupo.fromMap(consulta.first);
    }
    else {
      return null;
    }
  }

  static Future<List<Grupo>> lerGrupos() async {
    Database banco = await BancoDeDados().banco;
    List<Map> consulta = await banco.rawQuery("SELECT * FROM $tabelaGrupoInteresse");
    List<Grupo> lista = List();
    for(Map grupo in consulta) {
      lista.add(Grupo.fromMap(grupo));
    }
    return lista;
  }

  static Future<int> atualizarGrupo(Grupo grupo) async {
    Database banco = await BancoDeDados().banco;
    return await banco.update(tabelaGrupoInteresse, grupo.toMap(),
        where: "$colunaId = ?",
        whereArgs: [grupo.id]);
  }

  static Future<int> removerGrupo(int id) async {
    Database banco = await BancoDeDados().banco;
    return await banco.delete(tabelaGrupoInteresse,
        where: "$colunaId = ?",
        whereArgs: [id]);
  }


}