import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:flutter/material.dart';

import 'ler_mensagem.dart';

Widget mensagemCard(BuildContext context, int index, List<Mensagem> listaTemporaria) {

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
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.green,
              child:  Icon(
                listaTemporaria[index].lida ? Icons.drafts : Icons.email,
              ),
            ),

            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  listaTemporaria[index].titulo,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  previaConteudo(listaTemporaria[index].conteudo),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );


}

String previaConteudo(String texto) {
  if(texto.length > 20 ) {
    return "${texto.substring(0,20)}...";
  }
  return texto;
}