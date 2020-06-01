import 'dart:io';

import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class InserirNoticia extends StatefulWidget {
  @override
  _InserirNoticiaState createState() => _InserirNoticiaState();
}

class _InserirNoticiaState extends State<InserirNoticia> {
  Noticia noticia;

  Conteudo ultimoConteudoRemovido;
  int ultimoIndiceRemovido;

  TextEditingController _controllerTitulo = TextEditingController();

  final chaveScaffold = GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

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
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Column(
            children: montarPreviaNoticia(noticia),
          ),
          cardInserirParagrafo(),
          cardInserirLink(),
          cardInserirImagem(),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: RaisedButton(
                child: Text("Publicar notícia",
                  style: TextStyle(fontSize: 24, color: Colors.white)),
                color: Colors.green,
                onPressed: publicarNoticia
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  publicarNoticia() {
    noticia.titulo = _controllerTitulo.text;

    noticia.dataHoraPublicacao = DateTime.now();
    noticia.administrador = SistemaAdmin().administrador;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Publicar?"),
          content:
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              linhaTextoExpandida("Após publicada, a notícia não poderá ser alterada."),
              SizedBox(height: 20),
              linhaTextoExpandida("Deseja realmente publicar?"),
            ],
          ),

          actions: <Widget>[
            FlatButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  if (BancoFiciticio.inserirNoticia(noticia)) {
                    Navigator.pop(context);
                  }
                  Navigator.pop(context);
                }),
          ],
        ));
  }

  //card para inserção de parágrafos na notícia
  Widget cardInserirParagrafo() {
    TextEditingController paragrafoController = TextEditingController();
    return Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Expanded(
                child: inputLinhaSimples("Novo parágrafo", paragrafoController),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 40,
                  color: Colors.green,
                ),
                onPressed: () {
                  Conteudo c = Conteudo();
                  c.texto = paragrafoController.text;
                  c.tipo = Conteudo.TIPO_PARAGRAFO;
                  setState(() {
                    noticia.conteudos.add(c);
                    paragrafoController.clear();
                  });
                },
              )
            ],
          )),
    );
  }

  //card para inserção de links na notícia
  Widget cardInserirLink() {
    TextEditingController controller = TextEditingController();
    return Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: inputLinhaSimples("Novo link", controller),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 40,
                  color: Colors.green,
                ),
                onPressed: () {
                  Conteudo c = Conteudo();
                  c.texto = controller.text;
                  c.tipo = Conteudo.TIPO_LINK;
                  setState(() {
                    noticia.conteudos.add(c);
                    controller.clear();
                  });
                },
              )
            ],
          )),
    );
  }

  //card para inserção de imagens na notícia
  Widget cardInserirImagem() {
    TextEditingController controller = TextEditingController();
    return Padding(
        padding: EdgeInsets.all(10),
        child: RaisedButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green)),
          color: Colors.green,
          label: Text("Nova imagem", style: TextStyle(color: Colors.white)),
          icon: Icon(
            Icons.add_a_photo,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            Conteudo c = Conteudo();
            getImage(c).then((valor) {
              c.tipo = Conteudo.TIPO_IMAGEM;
              setState(() {
                noticia.conteudos.add(c);
                controller.clear();
              });
            });
          },
        ));
  }

  Future getImage(Conteudo conteudo) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      conteudo.arquivo = File(pickedFile.path);
    });
  }

  List<Widget> montarPreviaNoticia(Noticia noticia) {
    List<Widget> conteudos = List();

    conteudos.add(Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
              child: inputLinhaSimples("Título da notícia", _controllerTitulo)),
        ],
      ),
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

    for (int c = 0; c < noticia.conteudos.length; c++) {
      switch (noticia.conteudos[c].tipo) {
        case Conteudo.TIPO_PARAGRAFO: //textos
          conteudos.add(removivel(
              Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(noticia.conteudos[c].texto,
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Serif')))),
              c));
          break;
        case Conteudo.TIPO_IMAGEM: //imagens
          conteudos.add(removivel(
              Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                      width: double.infinity,
                      child: noticia.conteudos[c].arquivo == null
                          ? Text("Sem imagem...")
                          : Image.file(
                              noticia.conteudos[c].arquivo,

                              fit: BoxFit.fitWidth,
                              //formatar imagem
                            ))),
              c));
          break;
        case Conteudo.TIPO_LINK: //links
          conteudos.add(removivel(
              Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                          child: new Text(noticia.conteudos[c].texto,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              )),
                          onTap: () => launch(noticia.conteudos[c].texto)))),
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
                  noticia.conteudos
                      .insert(ultimoIndiceRemovido, ultimoConteudoRemovido);
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
