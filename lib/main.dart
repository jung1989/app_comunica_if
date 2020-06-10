import 'package:app_comunica_if/helper/banco_de_dados.dart';
import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/helper/noticia_helper.dart';
import 'package:app_comunica_if/model/administrador.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicial(),
    theme: ThemeData(
      fontFamily: "Raleway",

    ),
    title: "Bem vindo!",
  ));

  SistemaUsuario().iniciar();
}

class Inicial extends StatefulWidget {
  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child:
            RaisedButton(
                child: Text("Protótipo Usuário!"),
                onPressed: () {
                  SistemaAdmin().login("", "");
                  Navigator.push(context, FadeRoute(page:  TelaUsuarioMensagens()));
                })),
        SizedBox(
          width: double.infinity,
          child:
            RaisedButton(
                child: Text("Protótipo Administrador"),
                onPressed: () {
                  SistemaAdmin().login("", "");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TelaAdministrador()));
                }))
          ],
        )
    );
  }


}

testeBanco() async {
  BancoDeDados teste = BancoDeDados();

  Administrador adm = Administrador.criarComNome("Admin Teste Banco");

  Mensagem m = Mensagem();
  m.titulo = "Titulo teste banco";
  m.conteudo = "Conteudo de teste da mensagem do banco";
  m.lida = false;
  m.favorita = false;
  m.administrador = adm;
  m.dataHoraPublicacao = DateTime.now();

  Noticia n = Noticia();
  n.titulo = "Titulo noticia teste banco";
  n.dataHoraPublicacao = DateTime.now();
  n.favorita = false;
  n.administrador = adm;
  n.id = 104;

  Conteudo c = Conteudo();
  c.tipo = Conteudo.TIPO_PARAGRAFO;
  c.texto = "Conteudo 1 da noticia";
  c.idNoticia = n.id;

  n.conteudos.add(c);

  MensagemHelper.gravarMensagem(m);
  n = await  NoticiaHelper.gravarNoticia(n);

  MensagemHelper.lerMensagens().then(
      (retorno) {
        for(Mensagem m in retorno ) {
          print(m.toMap());
        }
      }
  );

  NoticiaHelper.lerNoticias().then(
          (retorno) {
        for(Noticia n in retorno ) {
          print(n.toMap());
          for(Conteudo c in n.conteudos ) {
            print(" >>> ${c.toMap()}");
          }
        }
      }
  );


  NoticiaHelper.dataHoraUltimaNoticiaArmazenada().then((data) {
    print(data.toString());
  });


}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}


