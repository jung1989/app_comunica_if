import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ler_mensagem.dart';

Widget mensagemCard(
    BuildContext context, int index, List<Mensagem> listaTemporaria) {
  return GestureDetector(
    onTap: () {
      listaTemporaria[index].lida = true;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LerMensagem(listaTemporaria[index])));
    },
    child: Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    listaTemporaria[index].lida ? Icons.drafts : Icons.email,
                    color: Cores.corIconesClaro,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                    listaTemporaria[index].titulo,
                    overflow:  TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Cores.corTextEscuro),
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      previaConteudo(listaTemporaria[index].conteudo),
                      style: TextStyle(fontSize: 16, color: Cores.corTextMedio),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatarDataHora(listaTemporaria[index].dataHoraPublicacao),
                  ),
                ),
              ),
            ],
          )),
    ),
  );
}

String previaConteudo(String texto) {
  if (texto.length > 30) {
    return "${texto.substring(0, 30)}...";
  }
  return texto;
}
