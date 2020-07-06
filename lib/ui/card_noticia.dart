import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

import 'ler_noticia.dart';

Widget noticiaCard(
    BuildContext context, int index, List<Noticia> listaTemporaria) {
  return GestureDetector(
    onTap: () async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LerNoticia(listaTemporaria[index])));
    },
    child: Card(
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
                    color: Cores.corIconesClaro,
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
                height: 5,
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
