
import 'dart:io';

import 'administrador.dart';

class Noticia {
  Administrador administrador;
  String titulo;
  DateTime dataHoraPublicacao;
  List<Conteudo> conteudos = List();
}

class Conteudo {

  static const int TIPO_PARAGRAFO = 1;
  static const int TIPO_IMAGEM = 2;
  static const int TIPO_LINK = 3;

  int tipo;
  String texto;

}