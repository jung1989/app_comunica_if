
import 'package:app_comunica_if/model/grupo.dart';

class Usuario {

  static const int PERFIL_ADMINISTRADOR = 0;
  static const int PERFIL_SERVIDOR = 1;
  static const int PERFIL_ALUNO = 2;

  String id;
  String matricula;
  String nome;
  String email;
  DateTime ultimoAcesso;
  bool ativo;
  int perfil;

  List<Grupo> gruposInteresse = List();

  Usuario();

  Usuario.fromMap(Map map) {
    nome = map['nome'];
    matricula = map['matricula'];
    email = map['email'];
    ultimoAcesso = DateTime.fromMillisecondsSinceEpoch(map['ultimo_acesso']);
    ativo = map['ativo']==1?true:false;
    perfil = map['perfil'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'nome': nome,
      'matricula': matricula,
      'email' : email,
      'ultimo_acesso' : ultimoAcesso.millisecondsSinceEpoch,
      'ativo' : ativo?1:0,
      'perfil' : perfil
    };
    return map;
  }

  Usuario.construirComNome(String nome) {
    this.nome = nome;
  }

}