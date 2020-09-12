import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';


TextEditingController _controllerTitulo;

class InserirNoticiaWeb extends StatefulWidget {

  InserirNoticiaWeb() {
    _controllerTitulo = TextEditingController();
  }

  @override
  _InserirNoticiaWebState createState() => _InserirNoticiaWebState();
}

class _InserirNoticiaWebState extends State<InserirNoticiaWeb> {
  Noticia noticia;

  final chaveScaffold = GlobalKey<ScaffoldState>();

  bool _isEnviandoNoticia = false;

  TextEditingController _controllerLink = TextEditingController();

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
        title: Text("Nova Notícia"),
        backgroundColor: Cores.corAppBarBackground,
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
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: inputLinhaSimples("Título da notícia", _controllerTitulo)),
              ],
            ),
          ),

          cardInserirLink(),

          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: RaisedButton(
                child: Text("Publicar notícia",
                    style: TextStyle(color: Colors.white)),
                color: Cores.corBotoes,
                onPressed: () {
                  if(_controllerLink.text.isNotEmpty && _controllerTitulo.text.isNotEmpty) {
                    publicarNoticia();
                  }
                  else {
                    // TODO MENSAGEM DE ERRO
                    print('Campos em branco');
                  }
                }),
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

    noticia.linkWeb = _controllerLink.text;

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

  //card para inserção de links na notícia
  Widget cardInserirLink() {
    return  Padding(
          padding: EdgeInsets.all(10),
          child: inputLinhaSimples("Link da notícia", _controllerLink),


    );
  }

}

class Chaves {
  static int chaveRemovivelPrevia = 1;
}
