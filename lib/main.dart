import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/principal.dart';
import 'package:app_comunica_if/ui/tela_administrador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';


void main() {

  runApp(MaterialApp(
    home: Inicial(),
    theme: ThemeData(
      fontFamily: "Raleway",
        primarySwatch: Colors.green
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Principal()));

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




