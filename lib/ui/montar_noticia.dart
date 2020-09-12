import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/ui/padroes.dart';
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
          child: Text(
            noticia.titulo,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  conteudos.add(Padding(
    padding: EdgeInsets.only(right: 10, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          formatarDataHora(noticia.dataHoraPublicacao),
        )
      ],
    ),
  ));

  for (Conteudo conteudo in noticia.conteudos) {
    switch (conteudo.tipo) {
      case Conteudo.TIPO_PARAGRAFO: //textos
        conteudos.add(Padding(
            padding: EdgeInsets.all(10),
            child: Text(conteudo.texto,
                style: TextStyle(fontSize: 16, fontFamily: 'Serif'))));
        break;
      case Conteudo.TIPO_IMAGEM: //imagens
        conteudos.add(Padding(
            padding: EdgeInsets.all(10),
            child: conteudo.texto == null
                ? Text("Sem imagem...")
                : Image.network(
                    conteudo.texto,
                    fit: BoxFit.fitWidth,
                  )));
        break;

      case Conteudo.TIPO_LINK: //links
        conteudos.add(Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
                child: new Text(conteudo.texto,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    )),
                onTap: () => _launchURL(conteudo.texto))));
        break;
    }
  }
  conteudos.add(Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Autor: ${noticia.administrador.nome}",
              style: TextStyle(
                  fontSize: 14, fontFamily: 'Serif', color: Cores.corTextMedio))
        ],
      )));
  return conteudos;
}

_launchURL(String url) async {

  if(!url.contains("http://") && !url.contains("https://")) {
    print("### Adicionado http://...");
    url = "http://$url";
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}