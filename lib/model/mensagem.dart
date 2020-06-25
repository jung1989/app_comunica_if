import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';
import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/model/usuario.dart';

import 'grupo.dart';

class Mensagem {

  Usuario   administrador;
  String    id;
  String    titulo;
  String    conteudo;
  DateTime  dataHoraPublicacao;
  bool      lida;
  bool      favorita;

  List<Grupo> gruposInteresse = List();

  Mensagem() {
    titulo = "";
    conteudo = "";
    lida = false;
    favorita = false;
    gruposInteresse = List();
  }

  Mensagem.fromMap(Map map) {
    id = map[colunaId];
    titulo = map[colunaTitulo];
    conteudo = map[colunaConteudo];
    dataHoraPublicacao = DateTime.fromMillisecondsSinceEpoch(map[colunaDataHoraPublicacao]);
    lida = map[colunaLida]==0?false:true;
    favorita = map[colunaFavorita]==0?false:true;
    administrador = Usuario.construirComNome(map[colunaNomeAdministrador]);
    gruposInteresse = listaGruposFromMap(map[colunaGruposInteresse]);
  }

  /// utilizado para armazenamento no SQFLITE
  Mensagem.fromMapSemGrupo(Map map) {
    id = map[colunaId];
    titulo = map[colunaTitulo];
    conteudo = map[colunaConteudo];
    dataHoraPublicacao = DateTime.fromMillisecondsSinceEpoch(map[colunaDataHoraPublicacao]);
    lida = map[colunaLida]==0?false:true;
    favorita = map[colunaFavorita]==0?false:true;
    administrador = Usuario.construirComNome(map[colunaNomeAdministrador]);
  }

  Map toMap() {
    Map<String, dynamic> map = {
      colunaId: id,
      colunaTitulo: titulo,
      colunaConteudo: conteudo,
      colunaDataHoraPublicacao: dataHoraPublicacao.millisecondsSinceEpoch,
      colunaLida: lida?1:0,
      colunaFavorita: favorita?1:0,
      colunaNomeAdministrador : administrador.nome,
      colunaGruposInteresse: listaGruposToMap()
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  /// utilizado para armazenamento no SQFLITE
  Map toMapSemGrupo() {
    Map<String, dynamic> map = {
      colunaId: id,
      colunaTitulo: titulo,
      colunaConteudo: conteudo,
      colunaDataHoraPublicacao: dataHoraPublicacao.millisecondsSinceEpoch,
      colunaLida: lida?1:0,
      colunaFavorita: favorita?1:0,
      colunaNomeAdministrador : administrador.nome,
    };
    if(id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  List<Grupo> listaGruposFromMap(Map map) {
    List<Grupo> lista = List();
    map.forEach( (key, value) {
      Grupo g = Grupo.fromMap(map[key]);
      g.id = key;
      lista.add(g);
    });
    return lista;
  }

  /// retorna um map da lista de grupos de interesse do usuário
  Map listaGruposToMap() {
    Map<String, Map<String, dynamic>> map = Map();
    gruposInteresse.forEach( (grupo) {
      Map<String, dynamic> m = {
        colunaNome : grupo.nome,
        colunaSelecionado : grupo.selecionado
      };
      map["${grupo.id}"] = m;
    });
    return map;
  }


}