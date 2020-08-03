import 'package:app_comunica_if/model/dica.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_dicas.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/efeitos_visuais.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with SingleTickerProviderStateMixin {
  Future<int> _iniciarSistema;

  AnimationController _controllerAnimacao;
  Animation _animacao;

  Dica _dica;

  bool _visivel = false;

  String _mensagemVersao = "";

  @override
  void initState() {
    super.initState();

    _controllerAnimacao = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2)
    );
    _animacao = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controllerAnimacao);


    _iniciarSistema = iniciarSistema();
    _dica = SistemaDicas.instance.buscarDicaAleatoria();

    if (SistemaLogin.VERSAO < SistemaLogin.instance.versaoMaisRecente) {
      _mensagemVersao =
          "Uma nova versão do aplicativo está disponível. Atualize assim que possível.";
    }
  }

  Future<int> iniciarSistema() async {
    print("### Iniciando sistema...");
    await SistemaLogin.instance.iniciar();
    await Future.delayed(Duration(seconds: 3));
    verificarLogin();
    setState(() {
      _visivel = true;
    });
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: barraSuperior(),
      body: painelLogo(),
      //bottomNavigationBar: barraInferior(),
    );
  }

  Widget barraSuperior() {
    return AppBar(
      title: Text("Uma dica para você!"),
      backgroundColor: Cores.corAppBarBackground,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _dica = SistemaDicas.instance.buscarDicaAleatoria();
            });
          },
        )
      ],
    );
  }

  Widget painelLogo() {
    _controllerAnimacao.forward();
    return FadeTransition(
      opacity: _animacao,
      child: Container(
      child: Center(
        child: Image.asset("imagens/logo10anos.jpeg", fit: BoxFit.fitWidth,),
      ),
    ));
  }

  Widget barraInferior() {
    return BottomAppBar(
        //color: Cores.corPretoTransparente,
        child: botaoEntrar());
  }

  Widget painelDica() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          imagemDica(),
          //textoDica()
        ],
      ),
    );
  }

  Widget textoDica() {
    return Container(
        //color: Cores.corFundo,
        child: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Text(_dica.texto ?? "Sem texto...",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20, fontFamily: 'Roboto')),
    ));
  }

  Widget imagemDica() {
    return Container(
       margin: EdgeInsets.only(top: 20, bottom: 20,left: 10, right: 10),
        padding: EdgeInsets.only(),
        child:  Image.network(_dica.caminhoImagem),
        decoration: BoxDecoration(
            color: Colors.white,

            boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]));
  }

  Widget painelEntrar() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState != ConnectionState.done) {
          return Center(
            child: Text("Carregando sistema..."),
          );
        } else {
          return botaoEntrar();
        }
      },
      future: _iniciarSistema,
    );
  }

  verificarLogin() {
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
      //Navigator.pushReplacement(context, FadeRoute(page: TelaLogin()));
      Navigator.pushReplacementNamed(context, Rotas.TELA_LOGIN);
    }
  }

//  Widget botaoEntrar() {
//    return Center(
//        child: SizedBox(
//            width: double.infinity,
//            child: RaisedButton(
//                child: Text("Entrar"),
//                onPressed: () {
//                  /// verificação para redirecionamento caso usuário esteja logado
//                  if (SistemaLogin.instance.usuario != null) {
//                    switch (SistemaLogin.instance.usuario.perfil) {
//                      case Usuario.PERFIL_ALUNO:
//                      case Usuario.PERFIL_SERVIDOR:
//                        Navigator.pushReplacement(
//                            context, FadeRoute(page: TelaUsuarioMensagens()));
//                        break;
//                      case Usuario.PERFIL_ADMINISTRADOR:
//                        Navigator.pushReplacement(
//                            context, FadeRoute(page: TelaAdministrador()));
//                        break;
//                    }
//                  } else {
//                    Navigator.pushReplacementNamed(context, Rotas.TELA_LOGIN);
//                  }
//                })));
//  }

  Widget botaoEntrar() {
    return Container(
      padding: EdgeInsets.only(),
      child: SizedBox(
        height: 60,
        child: Center(
            child: AnimatedCrossFade(
          crossFadeState:
              !_visivel ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 400),
          firstChild: Text("$_mensagemVersao Aguarde um instante..."),
          secondChild: SizedBox(
            height: 60,
            width: double.infinity,
            child: RaisedButton(
                color: Cores.corIconesClaro,
                child: Text("Entrar",
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                onPressed: verificarLogin),
          ),
        )),
      ),
    );
  }
}
