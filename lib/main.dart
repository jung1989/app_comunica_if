import 'package:app_comunica_if/ui/principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



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




