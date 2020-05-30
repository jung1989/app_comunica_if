import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

import 'card_mensagem.dart';
import 'card_noticia.dart';
import 'inserir_mensagem.dart';
import 'inserir_noticia.dart';

class TelaAdministrador extends StatefulWidget {
  @override
  _TelaAdministradorState createState() => _TelaAdministradorState();
}

class _TelaAdministradorState extends State<TelaAdministrador> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.description)),
              ],
            ),
            centerTitle: true,
            title: Text("Área administrativa"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
              )
            ],
          ),
          body: TabBarView(
            children: [
              listaMensagens(),
              listaNoticias()
            ],
          ),
        ));
  }

  Widget botaoInserirMensagem() {
    return RaisedButton.icon(
        label: Text("Inserir mensagem"),
        icon: Icon(Icons.add),
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InserirMensagem()));
        });
  }

  Widget listaMensagens() {
    return Column(
      children: <Widget>[
        //botaoInserirMensagem(),

        Padding(
          padding: EdgeInsets.all(10),
          child: cardNovaMensagem(context),
        ),
        Text("Mensagens publicadas por você"),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount:
              BancoFiciticio
                  .mensagensPorAdmin(SistemaAdmin().administrador)
                  .length,
              itemBuilder: (context, index) {
                return mensagemCard(context, index,
                    BancoFiciticio.mensagensPorAdmin(
                        SistemaAdmin().administrador));
              }),
        )
      ],
    );
  }


  Widget listaNoticias() {
    return Column(
      children: <Widget>[
        //botaoInserirMensagem(),

        Padding(
          padding: EdgeInsets.all(10),
          child: cardNovaNoticia(context),
        ),
        Text("Notícias publicadas por você"),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount:
              BancoFiciticio
                  .noticiasPorAdmin(SistemaAdmin().administrador)
                  .length,
              itemBuilder: (context, index) {
                return noticiaCard(context, index,
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
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => InserirMensagem()));
    },
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.green,
              child:  Icon(
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
        )
      ),
    ),
  );
}


Widget cardNovaNoticia(BuildContext context) {

  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InserirNoticia()));
    },
    child: Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.green,
                child:  Icon(
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
          )
      ),
    ),
  );
}