import 'package:app_comunica_if/model/mensagem.dart';
import 'package:flutter/material.dart';

class LerMensagem extends StatelessWidget {

  Mensagem _mensagem;

  LerMensagem(Mensagem mensagem) {
    this._mensagem = mensagem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mensagem.titulo),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_mensagem.conteudo, style: TextStyle(fontSize: 20),),
            Text(formatarMensagem())
          ],
        ),
      ),
    );
  }

  String formatarMensagem() {
    return "${_mensagem.dataHoraPublicacao.day} / "
           "${_mensagem.dataHoraPublicacao.month} / "
           "${_mensagem.dataHoraPublicacao.year} ";
  }
}
