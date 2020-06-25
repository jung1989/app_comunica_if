import 'dart:io';

import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
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

  Future _futureConteudos;

  Future _carregarConteudos(Noticia n) async {
    noticia.conteudos = await SistemaAdmin().carregarConteudos(n);
  }

  @override
  void initState() {
    super.initState();
    _futureConteudos = _carregarConteudos(noticia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notícia"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null) {
              return Container(
                child: Text("Carregando conteúdos..."),
              );
            }
            return Column(
                children:
                montarNoticia(noticia)
            );
          },
          future: _futureConteudos,
        )

      ),
    );
  }

}


