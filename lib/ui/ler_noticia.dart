import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/ui/montar_noticia.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

Noticia noticia;

class LerNoticia extends StatefulWidget {

  LerNoticia(Noticia n) {
    noticia = n;
  }

  @override
  _LerNoticiaState createState() => _LerNoticiaState();
}

class _LerNoticiaState extends State<LerNoticia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notícia"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children:
            montarNoticia(noticia)
        ),
      ),
    );
  }

}


