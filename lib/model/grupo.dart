

import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';

class Grupo {

  Grupo() {
    this.selecionado = false;
  }

  Grupo.nomeado(String id, String nome) {
    this.id = id;
    this.nome = nome;
    this.selecionado = false;
  }

  String id;
  String nome;
  bool selecionado;

  Grupo.fromMap(Map map) {
    id = map[colunaIdGrupo];
    nome = map[colunaNome];
    selecionado = map[colunaSelecionado]==0?false:true;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      colunaIdGrupo: id,
      colunaNome: nome,
      colunaSelecionado: selecionado?1:0
    };
    if(id != null) {
      map[colunaIdGrupo] = id;
    }
    return map;
  }





  @override
  String toString() {
    return "$nome";
  }


}