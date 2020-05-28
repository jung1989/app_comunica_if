import 'package:app_comunica_if/model/noticia.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<Widget> montarNoticia(Noticia noticia) {
  List<Widget> conteudos = List();

  conteudos.add(Padding(
    padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(noticia.titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

      ],
    ),
  ));

  conteudos.add(Divider(
    height: 10,
    thickness: 1,
    indent: 10,
    endIndent: 10,
  ));

  conteudos.add(
    Padding(
      padding: EdgeInsets.only(right: 10, bottom: 10),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(formatarDataHora(noticia),
            //formatar data e hora da noticia
          )
        ],
      ),
    )

  );

  for(Conteudo conteudo in noticia.conteudos) {
    switch(conteudo.tipo) {
      case 1: //textos
        conteudos.add(Padding(
          padding: EdgeInsets.all(10),
          child: Text(conteudo.texto,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Serif'
            )

        )));
      break;
      case 2: //imagens
        conteudos.add(Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(conteudo.texto,
            height: 100,
            fit: BoxFit.fitWidth,
            //formatar imagem
          )));

        break;

      case 3://links
        conteudos.add(Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
                child: new Text(conteudo.texto,

                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    )),
                onTap: () => launch(conteudo.texto)
            )
        ));

        break;

    }

  }
  return conteudos;
}

String formatarDataHora(Noticia noticia) {
  return "${noticia.dataHoraPublicacao.day} / "
      "${noticia.dataHoraPublicacao.month} / "
      "${noticia.dataHoraPublicacao.year} ";
}