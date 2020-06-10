import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/componentes.dart';
import 'package:app_comunica_if/ui_usuario/grupos_interesse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../ui/card_mensagem.dart';

class TelaUsuarioMensagens extends StatefulWidget {
  @override
  _TelaUsuarioMensagensState createState() => _TelaUsuarioMensagensState();
}

class _TelaUsuarioMensagensState extends State<TelaUsuarioMensagens> {

  List<Mensagem> mensagens;

  List<Mensagem> mensagensLidas;
  List<Mensagem> mensagensNaoLidas;
  List<Mensagem> mensagensFavoritas;

  @override
  Widget build(BuildContext context)  {
    mensagens = BancoFiciticio.mensagensBanco;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: true,
          title: Text("Mensagens"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings, color: Cores.corIconesClaro),
              onPressed: () {
                //Navigator.push(context, FadeRoute(page:  GruposInteresse()) );
                _navegacaoTelaGrupos(context);
              }
              ,
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

  _navegacaoTelaGrupos(BuildContext context) async {
    await Navigator.push(context, FadeRoute(page:  GruposInteresse()) ).then(
        (valor) {
          setState(() {
            mensagensNaoLidas = BancoFiciticio.mensagensPorGrupo();
          });
        }
    );
  }

  Widget listaMensagensLidas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemCount: mensagensLidas.length,
            itemBuilder: (
                context,
                index,
                ) {
              return mensagemCard(context, index, mensagensLidas);
            });
      },
      future: carregarMensagensLidas(),
    );
  }

  Widget listaMensagensNaoLidas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemCount: mensagensNaoLidas.length,
            itemBuilder: (
                context,
                index,
                ) {
              return mensagemCard(context, index, mensagensNaoLidas);
            });
      },
      future: carregarMensagensNaoLidas(),
    );
  }

  Widget listaMensagensFavoritas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemCount: mensagensFavoritas.length,
            itemBuilder: (
                context,
                index,
                ) {
              return mensagemCard(context, index, mensagensFavoritas);
            });
      },
      future: carregarMensagensFavoritas(),
    );
  }


  Future carregarMensagensLidas() async {
    mensagensLidas = await MensagemHelper.lerMensagensLidas(true);
  }

  Future carregarMensagensNaoLidas() async {
    mensagensNaoLidas = await MensagemHelper.lerMensagensLidas(false);
  }

  Future carregarMensagensFavoritas() async {
    mensagensFavoritas = await MensagemHelper.lerMensagensFavoritas(true);
  }

}
