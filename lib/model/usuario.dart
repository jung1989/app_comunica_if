
import 'package:app_comunica_if/model/grupo.dart';

class Usuario {

  String matricula;
  String nome;
  String email;
  DateTime ultimoAcesso;

  List<Grupo> gruposInteresse = List();


  String codigoParaFiltroMensagens() {
    String retorno = "";
    for(Grupo g in gruposInteresse) {
      retorno += "${g.nome} ";
    }
    return retorno;
  }

}