import 'package:app_comunica_if/model/mensagem.dart';
import 'package:flutter/material.dart';

Mensagem mensagem;

class LerMensagem extends StatefulWidget {
  LerMensagem(Mensagem m) {
    mensagem = m;
  }

  @override
  _LerMensagemState createState() => _LerMensagemState();
}

class _LerMensagemState extends State<LerMensagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mensagem.titulo),
        actions: <Widget>[
          IconButton(
            icon: Icon(mensagem.favorita ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                mensagem.favorita = !mensagem.favorita;
                print("Mensagem ${mensagem.titulo} favoritada");
              });
            },
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: montarMensagem(),
      ),
    );
  }

  Widget montarMensagem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                formatarDataHora(),
                //formatar data e hora da noticia
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Text(mensagem.conteudo,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, fontFamily: 'Serif')))
      ],
    );
  }

  String formatarDataHora() {
    return "${mensagem.dataHoraPublicacao.day} / "
        "${mensagem.dataHoraPublicacao.month} / "
        "${mensagem.dataHoraPublicacao.year} ";
  }
}
