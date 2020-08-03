import 'dart:io';

import 'package:app_comunica_if/helper/banco_de_dados.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/notificacoes.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'autenticacao.dart';

class SistemaLogin {

  static const double VERSAO = 2.0;

  /// implementação do singleton
  static final SistemaLogin _instance = SistemaLogin._interno();

  factory SistemaLogin() => _instance;

  SistemaLogin._interno();

  static SistemaLogin get instance => _instance;

  /// autenticação contendo as credenciais do firebase
  Autenticacao autenticacao;

  /// instancias do usuário e administrador, dependendo do perfil
  Usuario usuario;

  double versaoMaisRecente;

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

  Future<double> verificaVersao() async {
    print("### Verificando versão do aplicativo...");
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("versao")
        .getDocuments();

    if (querySnapshot.documents.length > 0) {
      print("### Verificando versão atual do aplicativo: $VERSAO");
      versaoMaisRecente = querySnapshot.documents[0].data['versao'] * 1.0;
      print("### Verificando mais recente do aplicativo: $versaoMaisRecente");
      return versaoMaisRecente;
    }
    return 0.0;
  }

  Future<int> buscarPerfil(String email) async {
    print("### Buscando perfil do usuário... ");

    autenticacao.firebaseUser = await autenticacao.getUsuario();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("perfis")
        .where("email", isEqualTo: email)
        .getDocuments();

    if (querySnapshot.documents.length > 0) {
      usuario = Usuario.fromMap(querySnapshot.documents[0].data);
      usuario.id = querySnapshot.documents[0].documentID;

      //TODO VERIFICAR ATUALIZACAO DO ULTIMO ACESSO
      Map<String, dynamic> acesso = {
        "ultimo_acesso" : DateTime.now().millisecondsSinceEpoch
      };
      DocumentReference perfilCarregado = Firestore.instance.collection("perfis").document(usuario.id);
      await perfilCarregado.updateData(acesso);

      /// verificação de usuário ou administrador
      switch (usuario.perfil) {
        case Usuario.PERFIL_ADMINISTRADOR:
          SistemaAdmin.instance.login(usuario);

          break;
        case Usuario.PERFIL_ALUNO:
        case Usuario.PERFIL_SERVIDOR:
          SistemaUsuario.instance.login(usuario);
          await SistemaUsuario.instance.iniciar();
          break;
      }
      await GerenciadorNotificacoes.instance.gravarToken(usuario.perfil);
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
  
  /// efetua a gravação do token do aplicativo relacionado ao usuário
  gravarToken(String fcmToken) async {
    var docRef = Firestore.instance
        .collection("tokens")
        .document(usuario.id);
    
    await docRef.setData({
      'token' : fcmToken,
      'criacao' : FieldValue.serverTimestamp(),
      'plataforma' : Platform.operatingSystem
    });
  }
}
