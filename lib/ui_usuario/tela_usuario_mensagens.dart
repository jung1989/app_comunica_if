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

    _mensagensLidas = await _futureMensagensLidas;
    _mensagensNaoLidas = await _futureMensagensNaoLidas;
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
      appBar: _barraSuperior(),
      body: _corpo(),
      bottomNavigationBar: barraInferior(context),
      floatingActionButton: _botaoAtualizar(),
    );
  }

  Widget _corpo() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            color: Cores.corFundo,
            child: Text("Carregando mensagens..."),
          );
        }
        return _tabMensagens();
      },
      future: _inicial,
    );
  }

  Widget _barraSuperior() {
    return AppBar(
      backgroundColor: Cores.corAppBarBackground,
      centerTitle: false,
      title: tituloAppBar(
        "Mensagens",
      ),
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lightbulb_outline, color: Cores.corIconesAppBar),
          onPressed: () {
            Navigator.pushNamed(context, Rotas.TELA_DICAS);
          },
        ),
        IconButton(
          icon: Icon(Icons.sort, color: Cores.corIconesAppBar),
          onPressed: () {
            _navegacaoTelaGrupos(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: Cores.corIconesAppBar),
          onPressed: () {
            Navigator.pushNamed(context, Rotas.TELA_CONFIG_USUARIO);
          },
        )
      ],
    );
  }

  Widget _botaoAtualizar() {
    return FloatingActionButton(
      child: Icon(Icons.refresh),
      backgroundColor: Cores.corIconesClaro,
      onPressed: () {
        setState(() {
          SistemaUsuario().carregarMensagens();
          atualizarMensagens();
        });
      },
    );
  }

  Widget _tabMensagens() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: Material(
              color: Cores.corFundo,
              child: TabBar(
                labelColor: Cores.verde,
                unselectedLabelColor: Cores.cinza,
                indicatorColor: Cores.verde,
                tabs: [
                  Tab(
                    icon: Icon(Icons.comment),
                    child: Text("Novas",
                        style: TextStyle(color: Cores.cinza, fontSize: 10)),
                  ),
                  Tab(icon: Icon(Icons.info),
                    child: Text("Importantes",
                        style: TextStyle(color: Cores.cinza, fontSize: 10)),),
                  Tab(icon: Icon(Icons.archive),
                      child: Text("Arquivadas",
                      style: TextStyle(color: Cores.cinza, fontSize: 10)),),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _listaPadrao(_mensagensNaoLidas, _futureMensagensNaoLidas),
                _listaPadrao(_mensagensFavoritas, _futureMensagensFavoritas),
                _listaPadrao(_mensagensLidas, _futureMensagensLidas),
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
    setState(() {});
  }

  Widget _listaPadrao(List lista, Future future) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return lista.length > 0
            ? Container(
                color: Cores.corFundo,
                child: ListView.builder(
                    padding: EdgeInsets.all(15.0),
                    itemCount: lista.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      return mensagemCard(
                          context, index, lista, _atualizarTela);
                    }),
              )
            : Container(
                color: Cores.corFundo,
                child: Center(child: Text("Nenhuma mensagem")),
              );
      },
      future: future,
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
