import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/componentes.dart';
import 'package:flutter/material.dart';

import '../ui/card_mensagem.dart';

class TelaUsuarioMensagens extends StatefulWidget {
  @override
  _TelaUsuarioMensagensState createState() => _TelaUsuarioMensagensState();
}

class _TelaUsuarioMensagensState extends State<TelaUsuarioMensagens> {
  List<Mensagem> mensagens;


  @override
  Widget build(BuildContext context) {
    mensagens = BancoFiciticio.mensagensBanco;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: true,
          title: Text("Mensagens"),
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
                      Tab(
                          icon: BancoFiciticio.mensagensNaoLidas().length > 0
                              ? Icon(Icons.playlist_add, color: Cores.corIconesClaro)
                              : Icon(Icons.playlist_add_check, color: Cores.corIconesClaro)),
                      Tab(icon: Icon(Icons.star, color: Cores.corIconesClaro)),
                      Tab(icon: Icon(Icons.archive, color: Cores.corIconesClaro)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    listaMensagensNaoLidas(),
                    listaMensagensFavoritas(),
                    listaMensagensLidas(),
                  ],
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: barraInferior(context),
    );
  }

  Widget listaMensagens() {
    print("Tamanho ${BancoFiciticio.mensagensBanco.length}");
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: mensagens.length,
        itemBuilder: (context, index) {
          return mensagemCard(context, index, BancoFiciticio.mensagensBanco);
        });
  }

  Widget listaMensagensLidas() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: BancoFiciticio.mensagensLidas().length,
        itemBuilder: (
          context,
          index,
        ) {
          return mensagemCard(context, index, BancoFiciticio.mensagensLidas());
        });
  }

  Widget listaMensagensNaoLidas() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: BancoFiciticio.mensagensNaoLidas().length,
        itemBuilder: (
          context,
          index,
        ) {
          return mensagemCard(
              context, index, BancoFiciticio.mensagensNaoLidas());
        });
  }

  Widget listaMensagensFavoritas() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: BancoFiciticio.mensagensFavoritas().length,
        itemBuilder: (
          context,
          index,
        ) {
          return mensagemCard(
              context, index, BancoFiciticio.mensagensFavoritas());
        });
  }
}
