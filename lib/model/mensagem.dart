import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/model/administrador.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:path/path.dart';

import 'grupo.dart';

class Mensagem {

  Administrador administrador;
  int           id;
  String        titulo;
  String        conteudo;
  DateTime        dataHoraPublicacao;
  bool          lida;
  bool          favorita;

  List<Grupo> gruposInteresse = List();

  Mensagem() {
    titulo = "";
    conteudo = "";
    lida = false;
    favorita = false;
    gruposInteresse = List();
  }

  Mensagem.fromMap(Map map) {
    administrador = Administrador.criarComNome(map[colunaNomeAdministrador]);
    id = map[colunaId];
    titulo = map[colunaTitulo];
    conteudo = map[colunaConteudo];
    dataHoraPublicacao = DateTime.fromMillisecondsSinceEpoch(map[colunaDataHoraPublicacao]);
    lida = map[colunaLida]==0?false:true;
    favorita = map[colunaFavorita]==0?false:true;
    administrador = Administrador.criarComNome(map[colunaNomeAdministrador]);
    //gruposIteresse = map[colunaGruposInteresse].
  }

  Map toMap() {
    Map<String, dynamic> map = {
      colunaId: id,
      colunaTitulo: titulo,
      colunaConteudo: conteudo,
      colunaDataHoraPublicacao: dataHoraPublicacao.millisecondsSinceEpoch,
      colunaLida: lida?1:0,
      colunaFavorita: favorita?1:0,
      colunaNomeAdministrador : administrador.nome
      //colunaGruposInteresse: gruposIteresse.toString();
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  String codigoParaFiltroMensagens() {
    String retorno = "";
    for(Grupo g in gruposInteresse) {
      retorno += "${g.nome} ";
    }
    return retorno;
  }

  String idsGruposInteresseParaTexto() {
    String retorno = "";
    if (gruposInteresse.length > 0) {
      retorno += "${gruposInteresse[0].id}";
    }
    for (int c = 1; c < gruposInteresse.length; c++) {
      retorno += ",${gruposInteresse[c].id}";
    }
    return retorno;
  }

    List<int> textoGruposInteresseParaIds(String texto) {
      List<int> retorno = List();
      
      var idsTexto = texto.split(",");

      for(String t in idsTexto) {
        retorno.add(int.parse(t));
      }



      return retorno;
    }
}