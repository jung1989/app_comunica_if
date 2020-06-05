import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

import '../ui/card_mensagem.dart';
import '../ui/card_noticia.dart';
import 'inserir_mensagem.dart';
import 'inserir_noticia.dart';

class TelaAdministrador extends StatefulWidget {
  @override
  _TelaAdministradorState createState() => _TelaAdministradorState();
}

class _TelaAdministradorState extends State<TelaAdministrador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
        title: Text("Área administrativa"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Cores.corIconesClaro,),
          )
        ],
      ),
      body: DefaultTabController(
        length: 2,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.chat, color: Cores.corIconesClaro),
                          Text("Mensagens",
                              style: TextStyle(color: Cores.corTextEscuro)),
                        ],
                      ),
                    ),
                    Tab(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.description, color: Cores.corIconesClaro),
                        Text("Notícias",
                            style: TextStyle(color: Cores.corTextEscuro))
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [painelMensagens(), painelNoticias()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BOTÕES ///

  Widget botaoInserirMensagem() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Cores.corBotoes)),
        color: Cores.corBotoes,
        label: Text("Inserir mensagem", style: TextStyle(fontSize: 20, color: Colors.white)),
        icon: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InserirMensagem()));
        });
  }

  Widget botaoInserirNoticia() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Cores.corBotoes)),
        color: Cores.corBotoes,
        label: Text("Inserir notícia", style: TextStyle(fontSize: 20, color: Colors.white)),
        icon: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InserirNoticia()));
        });
  }


   /// PAINEIS ///

  Widget painelMensagens() {
    return Column(
      children: <Widget>[

    Padding(padding: EdgeInsets.only(top:20, right: 10, left: 10, bottom: 10),
    child: Text("Mensagens publicadas por você",
            style: TextStyle(fontSize: 20, color: Cores.corTextEscuro, fontWeight: FontWeight.bold,))),
        Padding(padding: EdgeInsets.all(10), child: botaoInserirMensagem()),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount:
                  BancoFiciticio.mensagensPorAdmin(SistemaAdmin().administrador)
                      .length,
              itemBuilder: (context, index) {
                return mensagemCard(
                    context,
                    index,
                    BancoFiciticio.mensagensPorAdmin(
                        SistemaAdmin().administrador));
              }),
        )
      ],
    );
  }

  Widget painelNoticias() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top:20, right: 10, left: 10, bottom: 10),
            child: Text("Notícias publicadas por você",
                style: TextStyle(fontSize: 20, color: Cores.corTextEscuro, fontWeight: FontWeight.bold,))),
        Padding(padding: EdgeInsets.all(10), child: botaoInserirNoticia()),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount:
                  BancoFiciticio.noticiasPorAdmin(SistemaAdmin().administrador)
                      .length,
              itemBuilder: (context, index) {
                return noticiaCard(
                    context,
                    index,
                    BancoFiciticio.noticiasPorAdmin(
                        SistemaAdmin().administrador));
              }),
        )
      ],
    );
  }
}

Widget cardNovaMensagem(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InserirMensagem()));
    },
    child: Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.add,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Inserir nova mensagem",
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          )),
    ),
  );
}



Widget cardNovaNoticia(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InserirNoticia()));
    },
    child: Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.add,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Inserir nova notícia",
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          )),
    ),
  );
}
