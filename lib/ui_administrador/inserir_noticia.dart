import 'dart:io';

import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


TextEditingController _controllerTitulo;

class InserirNoticia extends StatefulWidget {

  InserirNoticia() {
    _controllerTitulo = TextEditingController();
  }

  @override
  _InserirNoticiaState createState() => _InserirNoticiaState();
}

class _InserirNoticiaState extends State<InserirNoticia> {
  Noticia noticia;

  Conteudo ultimoConteudoRemovido;
  int ultimoIndiceRemovido;



  final chaveScaffold = GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  bool _isEnviandoNoticia = false;

  int ordemConteudo = 1;

  @override
  void initState() {
    noticia = Noticia();
    noticia.dataHoraPublicacao = DateTime.now();
    noticia.linkWeb = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: chaveScaffold,
      appBar: AppBar(
        title: tituloAppBar("Nova Notícia"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: false,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: montarPrevia()
        ),
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
          SizedBox(height: 50),
          cardInserirParagrafo(),
          cardInserirLink(),
          cardInserirImagem(),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: RaisedButton(
                child: Text("Publicar notícia",
                    style: TextStyle(color: Colors.white)),
                color: Cores.corBotoes,
                onPressed: publicarNoticia),
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
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Publicar?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    linhaTextoExpandida(
                        "Após publicada, a notícia não poderá ser alterada."),
                    SizedBox(height: 20),
                    linhaTextoExpandida("Deseja realmente publicar?"),
                  ],
                ),
                actions: <Widget>[
                  Visibility(
                    visible: _isEnviandoNoticia,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                        child: CircularProgressIndicator()),
                  ),
                  Visibility(
                      visible: !_isEnviandoNoticia,
                      child: FlatButton(
                        child: Text("Não"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  Visibility(
                    visible: !_isEnviandoNoticia,
                    child: FlatButton(
                        child: Text("Sim"),
                        onPressed: () async {
                          setState(() {
                            _isEnviandoNoticia = true;
                          });
                          await Future.delayed(Duration(seconds: 1));
                          await SistemaAdmin().gravarNoticia(noticia);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                  ),
                ],
              );
            }));
  }

  //card para inserção de parágrafos na notícia
  Widget cardInserirParagrafo() {
    TextEditingController paragrafoController = TextEditingController();
    return Card(
      elevation: 5,
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
                  Icons.add,
                  size: 40,
                  color: Cores.corBotoes,
                ),
                onPressed: () {
                  Conteudo c = Conteudo();
                  c.texto = paragrafoController.text;
                  c.tipo = Conteudo.TIPO_PARAGRAFO;
                  c.ordem = ordemConteudo++;
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
      elevation: 5,
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
                  Icons.add,
                  size: 40,
                  color: Cores.corBotoes,
                ),
                onPressed: () {
                  Conteudo c = Conteudo();
                  c.texto = controller.text;
                  c.tipo = Conteudo.TIPO_LINK;
                  c.ordem = ordemConteudo++;
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
              side: BorderSide(color: Cores.corBotoes)),
          color: Cores.corBotoes,
          label: Text("Nova imagem", style: TextStyle(color: Colors.white)),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Conteudo c = Conteudo();
            getImage(c).then((valor) {
              c.tipo = Conteudo.TIPO_IMAGEM;
              c.ordem = ordemConteudo++;
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
      conteudo.texto = pickedFile.path;
      conteudo.imagem = File(pickedFile.path);
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
                      child: noticia.conteudos[c].texto == null
                          ? Text("Sem imagem...")
                          : Image.file(
                              noticia.conteudos[c].imagem,
                              fit: BoxFit.fitWidth,
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
