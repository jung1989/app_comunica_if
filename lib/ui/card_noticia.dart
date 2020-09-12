import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui/tela_noticia_web.dart';
import 'package:flutter/material.dart';

import 'ler_noticia.dart';

Widget noticiaCard(
    BuildContext context, int index, List<Noticia> listaTemporaria) {
  return GestureDetector(
    onTap: () async {
      if(listaTemporaria[index].linkWeb.isNotEmpty) {
        print("### abrindo noticia web ");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TelaNoticiaWeb(listaTemporaria[index].linkWeb)));

      }
      else {
        print("### abrindo noticia local");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LerNoticia(listaTemporaria[index])));
      }

    },
    child: Card(
      elevation: 5,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.description,
                    color: Cores.verde,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      listaTemporaria[index].titulo,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Cores.corTextEscuro),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
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
