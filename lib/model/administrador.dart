
import 'mensagem.dart';

class Administrador {

  int id;
  String nome;
  String email;

  List<Mensagem> mensagens;

  Administrador() {}

  Administrador.criarComNome(String nome) {
    this.nome = nome;
  }
}