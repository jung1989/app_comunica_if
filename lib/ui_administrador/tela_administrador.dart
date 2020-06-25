import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

import '../ui/card_mensagem.dart';
import '../ui/card_noticia.dart';
import 'inserir_mensagem.dart';
import 'inserir_noticia.dart';

class TelaAdministrador extends StatefulWidget {
  @override
  _TelaAdministradorState createState() => _TelaAdministradorState();
}

class _TelaAdministradorState extends State<TelaAdministrador> {

  Future<List<Mensagem>> _futureMensagens;
  List<Mensagem> _mensagens = List();

  Future<List<Noticia>> _futureNoticias;
  List<Noticia> _noticias = List();

  @override
  void initState() {
    super.initState();
    atualizarMensagens();
    atualizarNoticias();
  }

  Future atualizarMensagens() async {
    _futureMensagens = carregarMensagens();
    _mensagens =  await _futureMensagens;
  }

  Future atualizarNoticias() async {
    _futureNoticias = carregarNoticias();
    _noticias =  await _futureNoticias;
  }

  Future<List<Mensagem>> carregarMensagens() async {
    return await SistemaAdmin.instance.carregarMensagensPorAdministrador();
  }

  Future<List<Noticia>> carregarNoticias() async {
    return await SistemaAdmin.instance.carregarNoticiasPorAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
        title: Text("Área administrativa"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Cores.corIconesClaro,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Rotas.TELA_CONFIG_ADMINISTRADOR);
            },
          )
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Cores.corPrimaria,
                  tabs: [
                    Tab(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.chat, color: Cores.corIconesClaro),
                          Text("Mensagens",
                              style: TextStyle(color: Cores.corTextEscuro)),
                        ],
                      ),
                    ),
                    Tab(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.description, color: Cores.corIconesClaro),
                        Text("Notícias",
                            style: TextStyle(color: Cores.corTextEscuro))
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [painelMensagens(), painelNoticias()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BOTÕES ///

  Widget botaoInserirMensagem() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Cores.corBotoes)),
        color: Cores.corBotoes,
        label: Text("Inserir mensagem",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        icon: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () async{
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => InserirMensagem()));
          _mensagens = await carregarMensagens();
          setState(() {

          });
        });
  }

  Widget botaoInserirNoticia() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Cores.corBotoes)),
        color: Cores.corBotoes,
        label: Text("Inserir notícia",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        icon: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => InserirNoticia()));
          _noticias = await carregarNoticias();
          setState(() {

          });
        });
  }

  /// PAINEIS ///

  Widget painelMensagens() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10), child: botaoInserirMensagem()),
        Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            child: Text("Mensagens publicadas por você",
                style: TextStyle(
                  fontSize: 20,
                  color: Cores.corTextEscuro,
                  fontWeight: FontWeight.bold,
                ))),
        Expanded(child: listaMensagens())
      ],
    );
  }

  Widget listaMensagens() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: _mensagens.length,
            itemBuilder: (context, index) {
              return mensagemCard(context, index, _mensagens,this);
            });
      },
      future: _futureMensagens,
    );
  }



  Widget painelNoticias() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10), child: botaoInserirNoticia()),
        Padding(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            child: Text("Notícias publicadas por você",
                style: TextStyle(
                  fontSize: 20,
                  color: Cores.corTextEscuro,
                  fontWeight: FontWeight.bold,
                ))),
        Expanded(child: listaNoticias())
      ],
    );
  }

  Widget listaNoticias() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando noticias..."),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: _noticias.length,
            itemBuilder: (context, index) {
              return noticiaCard(context, index, _noticias);
            });
      },
      future: _futureNoticias,
    );
  }
}

Widget cardNovaMensagem(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InserirMensagem()));
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
                  "Inserir nova mensagem",
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          )),
    ),
  );
}

Widget cardNovaNoticia(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InserirNoticia()));
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
                  "Inserir nova notícia",
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          )),
    ),
  );
}
