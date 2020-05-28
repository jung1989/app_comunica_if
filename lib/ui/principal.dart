import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/ler_mensagem.dart';
import 'package:flutter/material.dart';

import 'card_mensagem.dart';
import 'card_noticia.dart';
import 'ler_noticia.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<Mensagem> mensagens;

  @override
  Widget build(BuildContext context) {
    mensagens = BancoFiciticio.mensagensBanco;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    icon: BancoFiciticio.mensagensNaoLidas().length>0
                        ? Icon(Icons.chat)
                        : Icon(Icons.chat_bubble_outline)
                    ),
                Tab(icon: Icon(Icons.description)),
                Tab(icon: Icon(Icons.star)),
                Tab(icon: Icon(Icons.archive )),

              ],
            ),
            centerTitle: true,
            title: Text("Principal"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
              )
            ],
          ),
          body: TabBarView(
            children: [
              listaMensagensNaoLidas(),
              listaNoticias(),
              listaMensagensFavoritas(),
              listaMensagensLidas(),

            ],
          ),
        ));
  }

  Widget listaNoticias() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: BancoFiciticio.noticiasBanco.length,
        itemBuilder: (context, index) {
          return noticiaCard(context, index);
        });
  }

  Widget listaMensagens() {
    print("Tamanho ${BancoFiciticio.mensagensBanco.length}");
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: mensagens.length,
        itemBuilder: (context, index) {
          return mensagemCard(context, index, 0);
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
          return mensagemCard(context, index, 1);
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
          return mensagemCard(context, index, 2);
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
          return mensagemCard(context, index, 3);
        });
  }












}

