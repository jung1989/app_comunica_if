import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/notificacoes.dart';
import 'package:app_comunica_if/sistema/sistema_dicas.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui/tela_login.dart';
import 'package:app_comunica_if/ui/tela_inicial.dart';
import 'package:app_comunica_if/ui/tela_redefinir_senha.dart';
import 'package:app_comunica_if/ui_administrador/inserir_administrador.dart';
import 'package:app_comunica_if/ui_administrador/inserir_grupo.dart';
import 'package:app_comunica_if/ui_administrador/inserir_mensagem.dart';
import 'package:app_comunica_if/ui_administrador/inserir_noticia.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_administrador/tela_configuracoes.dart';
import 'package:app_comunica_if/ui_administrador/tela_importar_alunos.dart';
import 'package:app_comunica_if/ui_administrador/tela_inserir_noticia_web.dart';
import 'package:app_comunica_if/ui_administrador/tela_inserir_usuario.dart';
import 'package:app_comunica_if/ui_administrador/tela_listar_dicas.dart';
import 'package:app_comunica_if/ui_administrador/tela_listar_usuarios.dart';
import 'package:app_comunica_if/ui_usuario/tela_configuracoes.dart';
import 'package:app_comunica_if/ui_usuario/tela_dicas.dart';
import 'file:///C:/Repositorios/app_comunica_if/lib/ui_administrador/tela_inserir_dica.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_noticias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Cores.corAppBarBackground,
        fontFamily: "Raleway",
      ),
      title: "Comunica IF",
      routes: {
        Rotas.INICIAL: (context) => Inicial(),
        Rotas.TELA_LOGIN: (context) => TelaLogin(),
        Rotas.TELA_INICIAL: (context) => TelaInicial(),
        Rotas.TELA_CONFIG_USUARIO: (context) => TelaConfiguracoesUsuario(),
        Rotas.TELA_CONFIG_ADMINISTRADOR: (context) =>
            TelaConfiguracoesAdministrador(),
        Rotas.TELA_INSERIR_USUARIO: (context) => TelaInserirUsuario(),
        Rotas.TELA_INSERIR_ADMINISTRADOR: (context) =>
            TelaInserirAdministrador(),
        Rotas.TELA_INSERIR_GRUPO: (context) => TelaInserirGrupo(),
        Rotas.TELA_MENSAGENS_USUARIO: (context) => TelaUsuarioMensagens(),
        Rotas.TELA_NOTICIAS_USUARIO: (context) => TelaUsuarioNoticias(),
        Rotas.TELA_ADMINISTRADOR: (context) => TelaAdministrador(),
        Rotas.TELA_GERENCIAR_DICAS: (context) => TelaListarDicas(),
        Rotas.TELA_INSERIR_DICA: (context) => TelaInseirDica(),
        Rotas.TELA_REDEFINIR_SENHA: (context) => TelaRedefinirSenha(),
        Rotas.TELA_INSERIR_MENSAGEM: (context) => InserirMensagem(),
        Rotas.TELA_INSERIR_NOTICIA: (context) => InserirNoticia(),
        Rotas.TELA_INSERIR_NOTICIA_WEB: (context) => InserirNoticiaWeb(),
        Rotas.TELA_IMPORTAR_ALUNOS: (context) => TelaImportarAlunos(),
        Rotas.TELA_LISTAR_USUARIOS: (context) => TelaListarUsuarios(),
        Rotas.TELA_DICAS: (context) => TelaDicas(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}


class Inicial extends StatefulWidget {
  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> with SingleTickerProviderStateMixin {
  Future _iniciarSistema;

  AnimationController _controllerAnimacao;
  Animation _animacao;

  ///TODO VERIFICAR MESSAGING
  //FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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

    _iniciarSistema = tempoEspera();
    GerenciadorNotificacoes.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: abertura()));
  }

  Widget abertura() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logoIF(),


              ],
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logoIF(),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Para continuar, seu aplicativo deve ser atualizado!",
                  style: TextStyle(color: Colors.redAccent),
                ),
                //quadrado()
              ],
            ),
          );
        }
      },
      future: _iniciarSistema,
    );
  }

  Widget logo() {
    return Image.asset(
      "imagens/logocinzatitulo.png",
      fit: BoxFit.fitWidth,
    );
  }

  Future tempoEspera() async {
    print("### Espera inicial...");

    double versaoMaisRecente = await SistemaLogin.instance.verificaVersao();

    if (SistemaLogin.VERSAO >= versaoMaisRecente.floor()) {
      await SistemaDicas.instance.inicializar();
      await Future.delayed(Duration(seconds: 3));
      await Navigator.pushReplacementNamed(context, Rotas.TELA_INICIAL);
      //await Navigator.pushReplacement(context, FadeRoute(page: TelaInicial()));
    } else {}
  }



  Widget logoIF() {
    _controllerAnimacao.forward();
    return FadeTransition(
      opacity: _animacao,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              quadrado(Cores.verde, true),
              quadrado(Cores.verde, true),
              espaco(),
              circulo(Colors.red)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              quadrado(Cores.verde, true),
              quadrado(Cores.verde, false),
              espaco(),
              quadrado(Cores.verde, true),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              quadrado(Cores.verde, true),
              quadrado(Cores.verde, true),
              espaco(),
              quadrado(Cores.verde, true),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Comunica IF", style: GoogleFonts.teko( fontSize: 45, fontWeight: FontWeight.bold, color: Cores.verde))
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("IFSul Câmpus Camaquã", style: GoogleFonts.teko( fontSize: 20, fontWeight: FontWeight.bold, color: Cores.verde))
            ],
          )

        ],


      ),
    );

  }

  Widget espaco() {
    return SizedBox(
      width: 20,
    );
  }

  Widget quadrado(Color cor, bool vazio) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: cor.withOpacity(vazio?1:0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(vazio?0.0:0),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget circulo(Color cor) {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.0),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
