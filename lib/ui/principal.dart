import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/ui/lerMensagem.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  List<Mensagem> mensagens = List();

  @override
  Widget build(BuildContext context) {
    mensagens = mensagensBanco;
    return Scaffold(
      appBar: AppBar (
        centerTitle: true,
        title: Text("Principal"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
          ),
          IconButton(
            icon: Icon(Icons.markunread),
          ),
          IconButton(
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: listaMensagens(),



    );
  }

  Widget listaMensagens() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: mensagens.length,
        itemBuilder: (context, index) {
          return _mensagemCard(context, index);
        });
  }

  Widget _mensagemCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          mensagens[index].lida = true;
          print("tap ${mensagens[index].lida}");
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LerMensagem(mensagens[index])));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Icon(mensagens[index].lida?Icons.drafts:Icons.email, size: 50, color: Colors.green,),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(mensagens[index].titulo,
                    style: TextStyle(fontSize: 25),),
                  Text("${mensagens[index].conteudo.substring(0,20)}...",
                    style: TextStyle(fontSize: 20, color: Colors.black12),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
