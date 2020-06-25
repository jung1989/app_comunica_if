import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/autenticacao.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/efeitos_visuais.dart';
import 'package:app_comunica_if/ui/tela_login.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Future _iniciarSistema;

  @override
  void initState() {
    super.initState();
    _iniciarSistema = iniciarSistema();
  }

  Future iniciarSistema() async {
    print("### Iniciando sistema...");
    await SistemaLogin.instance.iniciar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: painelEntrar());
  }

  Widget painelEntrar() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Center(
            child: Text("Carregando sistema..."),
          );
        }
        return botaoEntrar();
      },
      future: _iniciarSistema,
    );
  }

  Widget botaoEntrar() {
    return Center(
        child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
                child: Text("Entrar"),
                onPressed: () {
                  /// verificação para redirecionamento caso usuário esteja logado
                  if (SistemaLogin.instance.usuario != null) {
                    switch (SistemaLogin.instance.usuario.perfil) {
                      case Usuario.PERFIL_ALUNO:
                      case Usuario.PERFIL_SERVIDOR:
                        Navigator.pushReplacement(
                            context, FadeRoute(page: TelaUsuarioMensagens()));
                        break;
                      case Usuario.PERFIL_ADMINISTRADOR:
                        Navigator.pushReplacement(
                            context, FadeRoute(page: TelaAdministrador()));
                        break;
                    }
                  } else {
                    Navigator.pushReplacementNamed(context, Rotas.TELA_LOGIN);
                  }
                })));
  }
}
