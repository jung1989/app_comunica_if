
import 'package:app_comunica_if/helper/mensagem_grupo_helper.dart';
import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/helper/conteudo_noticia_helper.dart';
import 'package:app_comunica_if/helper/noticia_helper.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'grupo_interesse_helper.dart';

class BancoDeDados {
  static final BancoDeDados _instance = BancoDeDados._interno();

  factory BancoDeDados() => _instance;

  BancoDeDados._interno();

  Database _banco;

  Future<Database> get banco async {
    if(_banco != null) {
      return _banco;
    }
    else {
      print("### BANCO DE DADOS -> iniciado...");
      _banco = await _iniciarBanco();
      return _banco;
    }
  }

  Future<Database> _iniciarBanco() async {
    final caminhoBanco = await getDatabasesPath();
    final caminho = join(caminhoBanco, "banco_${SistemaUsuario().usuario.email}.db");

    return openDatabase(caminho, version: 1,
        onCreate: (Database banco, int novaVersao) async {
          await banco.execute(MensagemHelper.queryCriacaoTabelaMensagens());
          await banco.execute(NoticiaHelper.queryCriacaoTabelaNoticias());
          await banco.execute(ConteudoNoticia.queryCriacaoTabelaConteudoNoticia());
          await banco.execute(GrupoInteresseHelper.queryCriacaoTabelaGruposInteresse());
          await banco.execute(MensagemGrupoHelper.queryCriacaoTabelaMensagemGrupo());
        },
        onUpgrade: (Database banco, va, vn) {
          banco.execute("DROP TABLE IF EXISTS $tabelaMensagem");
          banco.execute("DROP TABLE IF EXISTS $tabelaNoticia");
          banco.execute("DROP TABLE IF EXISTS $tabelaConteudoNoticia");
          banco.execute("DROP TABLE IF EXISTS $tabelaGrupoInteresse");
          banco.execute("DROP TABLE IF EXISTS $tabelaMensagemGrupo");


          banco.execute(MensagemHelper.queryCriacaoTabelaMensagens());
          banco.execute(NoticiaHelper.queryCriacaoTabelaNoticias());
          banco.execute(ConteudoNoticia.queryCriacaoTabelaConteudoNoticia());
          banco.execute(GrupoInteresseHelper.queryCriacaoTabelaGruposInteresse());
          banco.execute(MensagemGrupoHelper.queryCriacaoTabelaMensagemGrupo());
        }
    );
  }

  void fecharBanco() {
    if(_banco != null) {
      _banco.close();
      _banco = null;
      print("### BANCO DE DADOS -> finalizado...");
    }

  }
}