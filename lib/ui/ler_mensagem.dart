import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:flutter/material.dart';

import 'padroes.dart';

Mensagem mensagem;
bool _isAdmin;

class LerMensagem extends StatefulWidget {
  LerMensagem(Mensagem m) {
    mensagem = m;
    _isAdmin = SistemaLogin.instance.usuario.perfil == Usuario.PERFIL_ADMINISTRADOR ? true : false;
    if(!_isAdmin) {
      MensagemHelper.atualizarMensagem(mensagem);
    }
  }

  @override
  _LerMensagemState createState() => _LerMensagemState();
}

class _LerMensagemState extends State<LerMensagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mensagem"),
        backgroundColor: Cores.corAppBarBackground,
        actions: <Widget>[
          _isAdmin
              ?
              Icon(Icons.comment,
                      color: Cores.corIconesClaro)
              :
              IconButton(
            icon: Icon(mensagem.favorita ? Icons.info : Icons.info_outline,
                color: Cores.corIconesClaro),
            onPressed: () {
              setState(() {
                mensagem.favorita = !mensagem.favorita;
                MensagemHelper.atualizarMensagem(mensagem);
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
            padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
            child: Text(
              mensagem.titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        Divider(
          height: 10,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                formatarDataHora(mensagem.dataHoraPublicacao),
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: Text(mensagem.conteudo,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontFamily: 'Serif')),
            )),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Autor: ${mensagem.administrador.nome}",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Serif',
                        color: Cores.corTextMedio))
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top : 50, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                    child: Text(
                      "Interessados: ${textoListaInteressados()}",
                      overflow:  TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Cores.corTextEscuro),
                    )),

              ],
            ))
      ],
    );
  }

  String textoListaInteressados() {
    String retorno = "";
    for(Grupo g in mensagem.gruposInteresse) {
      retorno += " ${g.nome} - ";
    }
    retorno = retorno.substring(0,retorno.length-3);
    return retorno;
  }
}
