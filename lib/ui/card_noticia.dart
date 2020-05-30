
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:flutter/material.dart';

import 'ler_noticia.dart';

Widget noticiaCard(BuildContext context, int index,List<Noticia> listaTemporaria) {

  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LerNoticia(listaTemporaria[index])));
    },
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child:  Icon(
                    Icons.art_track,
                  ),
                ),

                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    listaTemporaria[index].titulo,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Ler notícia...",
                  style: TextStyle(
                    color: Colors.black54
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}