import 'package:app_comunica_if/helper/banco_de_dados.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'autenticacao.dart';

class SistemaLogin {
  /// implementação do singleton
  static final SistemaLogin _instance = SistemaLogin._interno();

  factory SistemaLogin() => _instance;

  SistemaLogin._interno();

  static SistemaLogin get instance => _instance;

  /// autenticação contendo as credenciais do firebase
  Autenticacao autenticacao;

  /// instancias do usuário e administrador, dependendo do perfil
  Usuario usuario;

  /// inicialização do sistema
  Future iniciar() async {
    print("### Inciando autenticação...");
    if (autenticacao == null) {
      autenticacao = Autenticacao();
      FirebaseUser usuarioFire = await autenticacao.getUsuario();
      if (usuarioFire != null) {
        print("### Usuário já autenticado com firebase...");
        buscarPerfil(usuarioFire.email);
      } else {
        print("### Usuário não autenticado com firebase...");
      }
    }
  }

  void sair() {
    if (autenticacao != null) autenticacao.sair();

    autenticacao = null;
    usuario = null;

    BancoDeDados().fecharBanco();
  }

  Future<int> buscarPerfil(String email) async {
    print("### Buscando perfil do usuário... ");
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("perfis")
        .where("email", isEqualTo: email)
        .getDocuments();

    if (querySnapshot.documents.length > 0) {
      usuario = Usuario.fromMap(querySnapshot.documents[0].data);
      usuario.id = querySnapshot.documents[0].documentID;

      /// verificação de usuário ou administrador
      switch (usuario.perfil) {
        case Usuario.PERFIL_ADMINISTRADOR:
          SistemaAdmin.instance.login(usuario);
          break;
        case Usuario.PERFIL_ALUNO:
        case Usuario.PERFIL_SERVIDOR:
          await SistemaUsuario.instance.login(usuario);
          await SistemaUsuario.instance.iniciar();
          break;
      }
      return usuario.perfil;
    }
    return -1;
  }

  Future<String> verificarMatricula(String matricula) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("perfis")
        .where("matricula", isEqualTo: matricula)
        .where("ativo", isEqualTo: 0)
        .getDocuments();
    if (querySnapshot.documents.length > 0) {
      return querySnapshot.documents[0].documentID;
    } else {
      return "";
    }
  }
}
