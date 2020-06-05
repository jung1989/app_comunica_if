import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/componentes.dart';
import 'package:flutter/material.dart';

import '../ui/card_noticia.dart';

class TelaUsuarioNoticias extends StatefulWidget {
  @override
  _TelaUsuarioNoticiasState createState() => _TelaUsuarioNoticiasState();
}

class _TelaUsuarioNoticiasState extends State<TelaUsuarioNoticias> {
  List<Mensagem> mensagens;

  @override
  Widget build(BuildContext context) {
    mensagens = BancoFiciticio.mensagensBanco;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
        title: Text("Notícias"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Cores.corIconesClaro,),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Cores.corPrimaria,
                  tabs: [
                    Tab(icon: Icon(Icons.description, color: Cores.corIconesClaro)),
                    Tab(icon: Icon(Icons.star, color: Cores.corIconesClaro)),
                    Tab(icon: Icon(Icons.archive, color: Cores.corIconesClaro)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  listaNoticias(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: barraInferior(context),
    );
  }







  Widget listaNoticias() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: BancoFiciticio.noticiasBanco.length,
        itemBuilder: (context, index) {
          return noticiaCard(context, index, BancoFiciticio.noticiasBanco);
        });
  }


}

