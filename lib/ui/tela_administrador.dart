
import 'package:flutter/material.dart';

import 'inserir_mensagem.dart';

class TelaAdministrador extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Administrador"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Inserir mensagem"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InserirMensagem()));
            }
          )
        ],
      ),
    );
  }
}
