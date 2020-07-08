import 'dart:async';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Autenticacao {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  Future<String> logar(String email, String senha) async {
    AuthResult resultado = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: senha);

    _firebaseUser = resultado.user;
    return _firebaseUser.email;
  }


  FirebaseUser get firebaseUser => _firebaseUser;

  set firebaseUser(FirebaseUser value) {
    _firebaseUser = value;
  }

  Future<String> cadastrarUsuario(String email, String senha, String id) async {
    //TODO arrumar para solicitar cadastro
    AuthResult resultado = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: senha);

    Map<String, dynamic> perfil = {
      "ativo" : 1,
      "email" : email,
      "ultimo_acesso" : DateTime.now().millisecondsSinceEpoch
    };
    DocumentReference perfilCarregado = Firestore.instance.collection("perfis").document(id);
    await perfilCarregado.updateData(perfil);

    _firebaseUser = resultado.user;
    return _firebaseUser.uid;
  }

  Future<bool> cadastrarAdministrador(Usuario administrador, String senha) async {
    //TODO arrumar para solicitar cadastro
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: administrador.email, password: senha);

    return await SistemaAdmin.instance.gravarUsuario(administrador);
  }

  Future<FirebaseUser> getUsuario() async {
    FirebaseUser usuario = await _firebaseAuth.currentUser();
    return usuario;
  }

  Future<void> sair() async {
    return _firebaseAuth.signOut();
  }

  Future<void> enviarEmailDeVerificacao() async {
    FirebaseUser usuario = await _firebaseAuth.currentUser();
    usuario.sendEmailVerification();
  }

  Future<void> redefinirSenha(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isEmailVerificado() async {
    FirebaseUser usuario = await _firebaseAuth.currentUser();
    return usuario.isEmailVerified;
  }

  bool isLogado() {
    return _firebaseAuth.currentUser() != null;
  }
}