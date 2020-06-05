import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_noticias.dart';
import 'package:flutter/material.dart';

// barra inferior utilizada nas telas do usuário
Widget barraInferior(BuildContext context) {
  return BottomAppBar(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.only(top: 1, bottom: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.message, color: Cores.corIconesClaro),
                Text("Mensagens", style: TextStyle(color: Cores.corTextEscuro))
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, SlideLeftRoute(page:  TelaUsuarioMensagens()));
              //Navigator.push(
                 // context, MaterialPageRoute(builder: (context) => TelaUsuarioMensagens()));
            },
          ),
          FlatButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.description, color: Cores.corIconesClaro),
                  Text("Notícias", style: TextStyle(color: Cores.corTextEscuro))
                ],
              ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, SlideRightRoute(page:  TelaUsuarioNoticias()));
//              Navigator.push(
//                  context, MaterialPageRoute(builder: (context) => TelaUsuarioNoticias()));
            },
          ),
        ],
      ),
    ),
  );
}


class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
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
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
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
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end:Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

