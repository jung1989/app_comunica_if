import 'package:app_comunica_if/sistema/sistema_admin.dart';
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
            RaisedButton(
                child: Text("Protótipo Usuário"),
                onPressed: () {
                  SistemaAdmin().login("", "");
                  Navigator.push(context, FadeRoute(page:  TelaUsuarioMensagens()));
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => TelaUsuarioMensagens()));

                }),
            RaisedButton(
                child: Text("Protótipo Administrador"),
                onPressed: () {
                  SistemaAdmin().login("", "");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TelaAdministrador()));
                })
          ],
        )
    );
  }


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


