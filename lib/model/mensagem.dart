

import 'package:app_comunica_if/model/administrador.dart';

class Mensagem {

  Mensagem() {
    titulo = "";
    conteudo = "";
    lida = false;
    favorita = false;
  }

  Administrador administrador;
  int           id;
  String        titulo;
  String        conteudo;
  DateTime      dataHoraPublicacao;
  bool          lida;
  bool          favorita;


}