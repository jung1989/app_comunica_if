import 'package:app_comunica_if/model/dica.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_dicas.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/efeitos_visuais.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Future<int> _iniciarSistema;

  Dica _dica;

  bool _visivel = false;

  @override
  void initState() {
    super.initState();
    _iniciarSistema = iniciarSistema();
    _dica = SistemaDicas.instance.buscarDicaAleatoria();
  }

  Future<int> iniciarSistema() async {
    print("### Iniciando sistema...");
    await SistemaLogin.instance.iniciar();
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      _visivel = true;
    });
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uma dica para você!"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _dica = SistemaDicas.instance.buscarDicaAleatoria();
              });
            },
          )
        ],
      ),
        body: painelDica(),
      bottomNavigationBar: barraInferior(),
    );
  }

  Widget barraInferior() {
    return BottomAppBar(
      //color: Cores.corPretoTransparente,
      child: botaoEntrar()
    );
  }

  Widget painelDica() {
    return SingleChildScrollView(

      child:  Column(
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
          child: Text(_dica.texto?? "Sem texto...",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontFamily: 'Roboto')),
        )
    );
  }

  Widget imagemDica() {
    return SizedBox(
        width: double.infinity,
        child: Image.network(_dica.caminhoImagem)
    );
  }

  Widget painelEntrar() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState != ConnectionState.done) {
          return Center(
            child: Text("Carregando sistema..."),
          );
        }
        else {
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
    return  Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 40,
        child: Center(
          child: AnimatedCrossFade(
            crossFadeState: !_visivel ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500),
            firstChild: Text("Aguarde um instante..."),
            secondChild: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Cores.corIconesClaro)),
                color: Cores.corIconesClaro,
                child: Text("Entrar", style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: verificarLogin
            ),
          )
        ),
      ),
    );
  }
}
