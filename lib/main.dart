import 'package:app_comunica_if/ui/principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/mensagem.dart';

List<Mensagem> mensagensBanco = List();

void main() {
  carregarMensagens();
  runApp(MaterialApp(
    home: Inicial(),
    theme: ThemeData(
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
            Text("Como você se sente hoje?"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                botaoSentimento(1, "MT"),
                botaoSentimento(2, "T"),
                botaoSentimento(3, "N"),
                botaoSentimento(4, "F"),
                botaoSentimento(5, "MF")
              ],
            )
          ],
        )
    );
  }

  Widget botaoSentimento(int sentimento, String imagem) {
    return Expanded(child: FlatButton(
        textColor: Colors.black,
        child: Text(imagem),
        onPressed: () {
          switch (sentimento) {
            case 1:
            //muito triste
              break;
            case 2:
            //triste
              break;
            case 3:
            //normal
              break;
            case 4:
            //feliz
              break;
            case 5:
            //muito feliz
              break;
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Principal()));
        }));
  }
}

void carregarMensagens() {
  mensagensBanco.clear();

  Mensagem m1 = Mensagem();
  m1.titulo = "Título 1";
  m1.conteudo = "Conteúdo da mensagem inserida manualmente";
  m1.lida = true;
  m1.dataHoraPublicacao = DateTime.now();
  mensagensBanco.add(m1);

  Mensagem m2 = Mensagem();
  m2.titulo = "Título 2";
  m2.conteudo = "Mensagem inserida manualmente";
  m2.lida = false;
  m2.dataHoraPublicacao = DateTime.now();
  mensagensBanco.add(m2);

  Mensagem m3;
  for(int c = 3; c < 10; c++) {
    m3 = Mensagem();
    m3.titulo = "Título $c";
    m3.conteudo = "Mensagem inserida manualmente";
    m3.lida = false;
    m3.dataHoraPublicacao = DateTime.now();
    mensagensBanco.add(m3);
  }

}
