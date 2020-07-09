
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:app_comunica_if/ui/card_noticia.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/componentes.dart';
import 'package:flutter/material.dart';

class TelaUsuarioNoticias extends StatefulWidget {
  @override
  _TelaUsuarioNoticiasState createState() => _TelaUsuarioNoticiasState();
}

class _TelaUsuarioNoticiasState extends State<TelaUsuarioNoticias> {

  Future _futureNoticias;

  List<Noticia> _noticias = List();

  @override
  void initState() {
    super.initState();
    _futureNoticias = carregarNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
        title: Text("Notícias", style: TextStyle(color: Cores.corTextClaro)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Cores.corTextClaro,),
            onPressed: () {
              Navigator.pushNamed(context, Rotas.TELA_CONFIG_USUARIO);
            },
          ),
        ],
      ),
      body: listaNoticias(),
      bottomNavigationBar: barraInferior(context),
    );
  }

  Widget listaNoticias() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return Container(
          color: Cores.corFundo,
          child: ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount: _noticias.length,
              itemBuilder: (context, index) {
                return noticiaCard(context, index, _noticias);
              }),
        );
      },
      future: _futureNoticias,
    );
  }

  Future carregarNoticias() async {
    _noticias = await SistemaUsuario().carregarTodasNoticias();
  }
}

