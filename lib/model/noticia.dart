
import 'dart:io';

class Noticia {
  String titulo;

  DateTime dataHoraPublicacao;

  List<Conteudo> conteudos = List();
}

class Conteudo {

  int tipo;
  String texto;

}