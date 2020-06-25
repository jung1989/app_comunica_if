
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaConfiguracoesAdministrador extends StatefulWidget {
  @override
  _TelaConfiguracoesAdministradorState createState() => _TelaConfiguracoesAdministradorState();
}

class _TelaConfiguracoesAdministradorState extends State<TelaConfiguracoesAdministrador> {
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
      child: SizedBox(
        width: double.infinity,
        child: Column(
        children: <Widget>[
          botaoInserirUsuario(),
          botaoInserirAdministrador(),
          botaoInserirGrupo(),
          botaoSair()
        ],
      ),
      )
    );
  }

  Widget botaoInserirUsuario() {
    return  FlatButton(
        child: Text("Inserir usuáriio", style: TextStyle(color: Cores.corTextMedio)),
        onPressed: () {
          Navigator.pushNamed(context, Rotas.TELA_INSERIR_USUARIO);
        },

    );
  }

  Widget botaoInserirAdministrador() {
    return FlatButton(
      child: Text("Inserir administrador", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_ADMINISTRADOR);
      },
    );
  }

  Widget botaoInserirGrupo() {
    return FlatButton(
      child: Text("Inserir grupo", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_GRUPO);
      },
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