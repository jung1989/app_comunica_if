import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:app_comunica_if/ui/efeitos_visuais.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/componentes.dart';
import 'package:app_comunica_if/ui_usuario/grupos_interesse.dart';
import 'package:flutter/material.dart';

import '../ui/card_mensagem.dart';

class TelaUsuarioMensagens extends StatefulWidget {
  @override
  _TelaUsuarioMensagensState createState() => _TelaUsuarioMensagensState();
}

class _TelaUsuarioMensagensState extends State<TelaUsuarioMensagens> {

  Future _inicial;

  Future<List<Mensagem>> _futureMensagensLidas;
  Future<List<Mensagem>> _futureMensagensNaoLidas;
  Future<List<Mensagem>> _futureMensagensFavoritas;

  List<Mensagem> _mensagensLidas = List();
  List<Mensagem> _mensagensNaoLidas = List();
  List<Mensagem> _mensagensFavoritas = List();


  @override
  void initState() {
    super.initState();
    _inicial = atualizarMensagens();
  }

  Future atualizarMensagens() async {
    _futureMensagensLidas = carregarMensagensLidas();
    _futureMensagensNaoLidas = carregarMensagensNaoLidas();
    _futureMensagensFavoritas = carregarMensagensFavoritas();

    _mensagensLidas =  await _futureMensagensLidas;
    _mensagensNaoLidas =  await _futureMensagensNaoLidas;
    _mensagensFavoritas = await _futureMensagensFavoritas;
  }


  @override
  void setState(VoidCallback fn) {
    _inicial = atualizarMensagens();
    print("########### setstate invocado");
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
        title: Text("Mensagens", style: TextStyle(color: Cores.corTextClaro),),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort, color: Cores.corTextClaro),
            onPressed: () {
              _navegacaoTelaGrupos(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Cores.corTextClaro),
            onPressed: () {
              Navigator.pushNamed(context, Rotas.TELA_CONFIG_USUARIO);
            },
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container(
              child: Text("Carregando mensagens..."),
            );
          }
          return tabMensagens();
        },
        future: _inicial,
      ),
      bottomNavigationBar: barraInferior(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Cores.corIconesClaro,
        onPressed: () {
          setState(() {
            SistemaUsuario().carregarMensagens();
            atualizarMensagens();
          });
        },
      ),
    );
  }

  Widget tabMensagens() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: Material(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Cores.corPrimaria,
                tabs: [
                  Tab(icon: Icon(Icons.comment, color: Cores.corIconesClaro)),
                  Tab(icon: Icon(Icons.info, color: Cores.corIconesClaro)),
                  Tab(icon: Icon(Icons.archive, color: Cores.corIconesClaro)),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _listaMensagensNaoLidas(),
                _listaMensagensFavoritas(),
                _listaMensagensLidas(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _navegacaoTelaGrupos(BuildContext context) async {
    await Navigator.push(context, FadeRoute(page: GruposInteresse()));
    await atualizarMensagens();
    setState(() {});
  }

  _atualizarTela() {
    setState(() {

    });
  }


  Widget _listaMensagensLidas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return _mensagensLidas.length > 0
            ?
            ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount: _mensagensLidas.length,
              itemBuilder: (
                context,
                index,
              ) {
                return mensagemCard(context, index, _mensagensLidas, _atualizarTela);
              })
            :
            Center(
              child: Text(
                "Nenhuma mensagem arquivada"
              ),
            );
      },
      future: _futureMensagensLidas,
    );
  }

  Widget _listaMensagensNaoLidas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return _mensagensNaoLidas.length > 0
            ?
          ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemCount: _mensagensNaoLidas.length,
            itemBuilder: (
              context,
              index,
            ) {
              return mensagemCard(context, index, _mensagensNaoLidas, _atualizarTela);
            })
        :
        Center(
          child: Text(
              "Nenhuma mensagem nova"
          ),
        );
      },
      future: _futureMensagensNaoLidas,
    );
  }

  Widget _listaMensagensFavoritas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return _mensagensFavoritas.length > 0
          ?
          ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemCount: _mensagensFavoritas.length,
            itemBuilder: (
              context,
              index,
            ) {
              return mensagemCard(context, index, _mensagensFavoritas, _atualizarTela);
            })
        :
        Center(
            child: Text(
            "Nenhuma mensagem marcada como importante"
        ));
      },
      future: _futureMensagensFavoritas,
    );
  }

  Future<List<Mensagem>> carregarMensagensLidas() async {
     return await MensagemHelper.lerMensagensLidas(true);
  }

  Future<List<Mensagem>> carregarMensagensNaoLidas() async {
    return await MensagemHelper.lerMensagensLidas(false);
  }

  Future<List<Mensagem>> carregarMensagensFavoritas() async {
    return await MensagemHelper.lerMensagensFavoritas(true);
  }
}




/*

  Widget listaMensagensNaoLidasStream() {
    return StreamBuilder(
      stream: Firestore.instance.collection("mensagens").snapshots(),
      builder: (context, projectSnap) {
        switch(projectSnap.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:

            return Container(
              child: Text("Carregando mensagens..."),
            );

          case ConnectionState.done:
          case ConnectionState.active:
            print("Atualizado done...");

            return ListView.builder(
                padding: EdgeInsets.all(15.0),
                itemCount: _mensagensNaoLidas.length,
                itemBuilder: (
                    context,
                    index,
                    ) {
                  return mensagemCard(context, index, _mensagensNaoLidas, this);
                });
        }
        return null;

      },
    );
  }

 */