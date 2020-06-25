import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/tela_login.dart';
import 'package:app_comunica_if/ui/tela_inicial.dart';
import 'package:app_comunica_if/ui_administrador/inserir_administrador.dart';
import 'package:app_comunica_if/ui_administrador/inserir_grupo.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_administrador/tela_configuracoes.dart';
import 'package:app_comunica_if/ui_administrador/tela_inserir_usuario.dart';
import 'package:app_comunica_if/ui_usuario/tela_configuracoes.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_noticias.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Raleway",
      ),
      title: "Bem vindo!",
      routes: {
        Rotas.INICIAL : (context) => Inicial(),
        Rotas.TELA_LOGIN : (context) => TelaLogin(),
        Rotas.TELA_INICIAL: (context) => TelaInicial(),
        Rotas.TELA_CONFIG_USUARIO: (context) => TelaConfiguracoesUsuario(),
        Rotas.TELA_CONFIG_ADMINISTRADOR: (context) => TelaConfiguracoesAdministrador(),
        Rotas.TELA_INSERIR_USUARIO: (context) => TelaInserirUsuario(),
        Rotas.TELA_INSERIR_ADMINISTRADOR: (context) => TelaInserirAdministrador(),
        Rotas.TELA_INSERIR_GRUPO: (context) => TelaInserirGrupo(),
        Rotas.TELA_MENSAGENS_USUARIO: (context) => TelaUsuarioMensagens(),
        Rotas.TELA_NOTICIAS_USUARIO: (context) => TelaUsuarioNoticias(),
        Rotas.TELA_ADMINISTRADOR: (context) => TelaAdministrador()
      },
    );
  }
}

class Inicial extends StatefulWidget {
  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {

  Future _iniciarSistema;

  ///TODO VERIFICAR MESSAGING
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _iniciarSistema = tempoEspera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: abertura()));
  }

  Widget abertura() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando sistema..."),
          );
        }
        return Container(
          child: Center(
              child: Text("Esperando...")
          ),
        );
      },
      future: _iniciarSistema,
    );
  }

  Future tempoEspera() async {
    print("### Espera inicial...");
    await Future.delayed(Duration(seconds: 5));
    await Navigator.pushReplacementNamed(context, Rotas.TELA_INICIAL);
  }
}
