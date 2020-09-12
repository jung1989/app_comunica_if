
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/sistema/sistema_noticias_web.dart';
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
        appBar: _barraSuperior(),
        body: _corpo(),
        bottomNavigationBar: _barraInferior(),
    );
  }
  
  Widget _corpo() {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
        children: <Widget>[
          _botaoInserirUsuario(),
          _botaoListarUsuarios(),
          _botaoInserirAdministrador(),
          _botaoInserirGrupo(),
          _botaoGerenciarDicas(),
          _botaoRedefinirSenha(),
          _botaoNoticiasWeb(),
          _botaoSair()
        ],
      ),
      )
    );
  }

  Widget _barraSuperior() {
    return AppBar(
      backgroundColor: Cores.corAppBarBackground,
      centerTitle: true,
      title: Text("Configurações"),
    );
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

  Widget _botaoInserirUsuario() {
    return  FlatButton(
        child: Text("Inserir usuário", style: TextStyle(color: Cores.corTextMedio)),
        onPressed: () {
          Navigator.pushNamed(context, Rotas.TELA_INSERIR_USUARIO);
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

  Widget _botaoInserirAdministrador() {
    return FlatButton(
      child: Text("Inserir administrador", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_ADMINISTRADOR);
      },
    );
  }

  Widget _botaoInserirGrupo() {
    return FlatButton(
      child: Text("Inserir grupo", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_GRUPO);
      },
    );
  }

  Widget _botaoGerenciarDicas() {
    return FlatButton(
      child: Text("Gerenciar dicas", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_GERENCIAR_DICAS);
      },
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


  Widget _botaoListarUsuarios() {
    return FlatButton(
      child: Text('Listar usuários', style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_LISTAR_USUARIOS);
      },
    );
  }

  Widget _botaoNoticiasWeb() {
    return FlatButton(
      child: Text('Atualizar noticias da web', style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        SistemaNoticiasWeb.instance.verificarNovasNoticias();
      },
    );
  }
}
