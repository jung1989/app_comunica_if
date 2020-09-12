
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
        body: _corpo(),
      bottomNavigationBar: _barraInferior(),
    );
  }

  Widget CorpoConfiguracoes() {
    return SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              _botaoRedefinirSenha(),
              _botaoSair()
            ],
          ),
        ));
  }

  Widget _corpo() {
    return SingleChildScrollView(
        child: SizedBox(
        width: double.infinity,
        child: Column(
        children: <Widget>[
          _botaoRedefinirSenha(),
          _botaoSair()
        ],
      ),
    ));
  }


  Widget _barraInferior() {
    return BottomAppBar(
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text("Olá ${SistemaLogin.instance.usuario.nome}"),
        ),
      ),
    );
  }

  Widget _botaoSair() {
    return FlatButton(
      child: Text("Fazer logout do sistema", style: TextStyle(color: Colors.redAccent)),
      onPressed: () {
        SistemaLogin().sair();
        Navigator.pushNamedAndRemoveUntil(context, Rotas.TELA_INICIAL, (route) => false);
      },
    );
  }

  Widget _botaoRedefinirSenha() {
    return  FlatButton(
      child: Text("Redefinir senha", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_REDEFINIR_SENHA);
      },
    );
  }
}




