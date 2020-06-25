
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaConfiguracoesUsuario extends StatefulWidget {
  @override
  _TelaConfiguracoesUsuarioState createState() => _TelaConfiguracoesUsuarioState();
}

class _TelaConfiguracoesUsuarioState extends State<TelaConfiguracoesUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: true,
          title: Text("Configurações"),
        ),
        body: corpo()
    );
  }

  Widget corpo() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          botaoSair()
        ],
      ),
    );
  }



  Widget botaoSair() {
    return FlatButton(
      child: Text("Fazer logout do sistema", style: TextStyle(color: Colors.redAccent)),
      onPressed: () {
        SistemaLogin().sair();
        Navigator.pushNamedAndRemoveUntil(context, Rotas.TELA_INICIAL, (route) => false);
      },
    );
  }
}
