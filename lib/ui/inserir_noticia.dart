import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'montar_noticia.dart';
import 'previa_noticia.dart';



class InserirNoticia extends StatefulWidget {
  @override
  _InserirNoticiaState createState() => _InserirNoticiaState();
}

class _InserirNoticiaState extends State<InserirNoticia> {

  Noticia noticia;

  Conteudo ultimoConteudoRemovido;
  int ultimoIndiceRemovido;

  final chaveScaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    noticia = Noticia();
    noticia.dataHoraPublicacao = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: chaveScaffold,
      appBar: AppBar(
        title: Text("Nova Notícia"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: montarPrevia(),
      ),
    );
  }

  Widget montarPrevia() {
    return Column(
      children: <Widget>[
        cardInserirConteudo(context, "Novo parágrafo", null),
        cardInserirConteudo(context, "Novo link", null),
        cardInserirConteudo(context, "Nova imagem", null),
        SizedBox(
          height: 50,
        ),
        Column(
          children: montarPreviaNoticia(noticia),
        )
      ],
    );
  }

  publicarNoticia() {
//    mensagem.titulo = _controllerTitulo.text;
//    mensagem.conteudo = _controllerConteudo.text;
//    mensagem.dataHoraPublicacao = DateTime.now();
//    mensagem.administrador = SistemaAdmin().administrador;
//
//    showDialog(
//        context: context,
//        builder: (_) => AlertDialog(
//          title: Text("Publicar?"),
//          content:
//          Column(
//            mainAxisSize: MainAxisSize.min,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              linhaTextoExpandida("Após publicada, a mensagem não poderá ser alterada."),
//              SizedBox(height: 20),
//              linhaTextoExpandida("Deseja realmente publicar?"),
//            ],
//          ),
//
//          actions: <Widget>[
//            FlatButton(
//              child: Text("Não"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//            FlatButton(
//                child: Text("Sim"),
//                onPressed: () {
//                  if (BancoFiciticio.inserirMensagem(mensagem)) {
//                    Navigator.pop(context);
//                  }
//                  Navigator.pop(context);
//                }),
//          ],
//        ));
  }

  Widget cardInserirConteudo(
      BuildContext context, String texto, StatefulWidget sw) {
    return GestureDetector(
      onTap: () {
        Conteudo c = Conteudo();
        c.texto = "sdhoad sdonsaodi sdohnd asodhn  ";
        c.tipo = Conteudo.TIPO_PARAGRAFO;
        setState(() {
          noticia.conteudos.add(c);
        });
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => sw));
      },
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.add,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    texto,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              ],
            )),
      ),
    );
  }

  List<Widget> montarPreviaNoticia(Noticia noticia) {
    List<Widget> conteudos = List();

    conteudos.add(Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
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
            //formatar data e hora da noticia
          )
        ],
      ),
    ));

    for (int c = 0; c < noticia.conteudos.length; c++) {
      switch (noticia.conteudos[c].tipo) {
        case Conteudo.TIPO_PARAGRAFO: //textos
          conteudos.add(removivel(
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(noticia.conteudos[c].texto,
                      style: TextStyle(fontSize: 16, fontFamily: 'Serif'))),
              c));
          break;
        case Conteudo.TIPO_IMAGEM: //imagens
          conteudos.add(removivel(
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    noticia.conteudos[c].texto,
                    height: 100,
                    fit: BoxFit.fitWidth,
                    //formatar imagem
                  )),
              c));

          break;

        case Conteudo.TIPO_LINK: //links
          conteudos.add(removivel(
              Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                      child: new Text(noticia.conteudos[c].texto,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          )),
                      onTap: () => launch(noticia.conteudos[c].texto))),
              c));

          break;
      }
    }
    return conteudos;
  }

  Widget removivel(Widget w, int index) {
    print(Chaves.chaveRemovivelPrevia);
    return Dismissible(
      key: Key("${Chaves.chaveRemovivelPrevia++}"),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: AlignmentDirectional(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: w,
      onDismissed: (direcao) {
        setState(() {
          print("$index removido");
          ultimoConteudoRemovido = noticia.conteudos[index];
          ultimoIndiceRemovido = index;
          noticia.conteudos.removeAt(index);

          final snack = SnackBar(
            content: Text("Conteúdo removido!"),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "Desfazer?",
              onPressed: () {
                setState(() {
                  noticia.conteudos.insert(ultimoIndiceRemovido, ultimoConteudoRemovido);
                });
              },
            ),
          );
          chaveScaffold.currentState.showSnackBar(snack);
        });

      },
    );
  }
}

class Chaves {
  static int chaveRemovivelPrevia = 1;
}
