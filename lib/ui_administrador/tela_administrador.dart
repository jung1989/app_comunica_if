import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/sistema/sistema_noticias_web.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return await SistemaAdmin.instance.carregarMensagens();
  }

  Future<List<Noticia>> carregarNoticias() async {
    return await SistemaAdmin.instance.carregarNoticias();
  }

  _atualizarTela() async {
    await atualizarNoticias();
    await atualizarMensagens();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text("Área administrativa", style: GoogleFonts.teko( fontSize: 25, fontWeight: FontWeight.bold, color: Cores.verde)),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.settings,
//              color: Cores.cinza,
//            ),
//            onPressed: () {
//              Navigator.pushNamed(context, Rotas.TELA_CONFIG_ADMINISTRADOR);
//            },
//          )
//        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Cores.verde,
                  unselectedLabelColor: Cores.cinza,

                  indicatorColor: Cores.verde,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.chat),
                      child:
                          Text("Mensagens",
                              style: TextStyle(color:Cores.cinza, fontSize: 10)),
                    ),
                    Tab(
                        icon: Icon(Icons.dvr),
                        child: Text("Notícias",
                            style: TextStyle(color: Cores.cinza, fontSize: 10))
                    ),
                    Tab(
                      icon: Icon(Icons.settings),
                        child:
                        Text("Funções",
                            style: TextStyle(color: Cores.cinza, fontSize: 10))
                          ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [painelMensagens(), painelNoticias(), _corpo()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: botaoSuspenso(),
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
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          //Padding(padding: EdgeInsets.all(10), child: botaoInserirMensagem()),
//          Padding(
//              padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
//              child: Text("Mensagens publicadas por você",
//                  style: TextStyle(
//                    fontSize: 20,
//                    color: Cores.corTextEscuro,
//                    fontWeight: FontWeight.bold,
//                  ))),
          Expanded(child: listaMensagens())
        ],
      ),
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
        return _mensagens.length > 0
            ?
              ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: _mensagens.length,
                itemBuilder: (context, index) {
                return mensagemCard(context, index, _mensagens, _atualizarTela);
              })
            :
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("Nenhuma mensagem publicada por você"),
              );
      },
      future: _futureMensagens,
    );
  }

  Widget painelNoticias() {
    return Container(
      color: Colors.white,
      child:  Column(
        children: <Widget>[
          //Padding(padding: EdgeInsets.all(10), child: botaoInserirNoticia()),
//          Padding(
//              padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
//              child: Text("Notícias publicadas por você",
//                  style: TextStyle(
//                    fontSize: 20,
//                    color: Cores.corTextEscuro,
//                    fontWeight: FontWeight.bold,
//                  ))),
          Expanded(child: listaNoticias())
        ],
      ),
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
        return _noticias.length > 0
        ?
          ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: _noticias.length,
            itemBuilder: (context, index) {
              return noticiaCard(context, index, _noticias);
            })
        :
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("Nenhuma notícia publicada por você"),
            )
        ;
      },
      future: _futureNoticias,
    );
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

  Widget botaoSuspenso() {
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      visible: true,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.note_add),
          backgroundColor: Cores.corBotoes,
          label: 'Notícia da web',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            await Navigator.pushNamed(context, Rotas.TELA_INSERIR_NOTICIA_WEB);
            _atualizarTela();
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.note_add),
          backgroundColor: Cores.corBotoes,
          label: 'Montar notícia',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            await Navigator.pushNamed(context, Rotas.TELA_INSERIR_NOTICIA);
            _atualizarTela();
          },
        ),
        SpeedDialChild(
            child: Icon(Icons.add_comment),
            backgroundColor: Cores.corBotoes,
            label: 'Nova mensagem',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              await Navigator.pushNamed(context, Rotas.TELA_INSERIR_MENSAGEM);
              _atualizarTela();
            }
        ),
      ],
    );
  }




  /// configurações

  Widget _corpo() {
    return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                _botaoInserirUsuario(),
                _botaoListarUsuarios(),
                _botaoInserirAdministrador(),
                _botaoInserirGrupo(),
                _botaoGerenciarDicas(),
                _botaoRedefinirSenha(),
                _botaoNoticiasWeb(),
                _botaoSair()
              ],
            ),
          ),
        )
    );
  }


  Widget _botaoInserirUsuario() {
    return  FlatButton(
      child: Text("Inserir usuário", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_USUARIO);
      },

    );
  }

  Widget _botaoRedefinirSenha() {
    return  FlatButton(
      child: Text("Redefinir senha", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_REDEFINIR_SENHA);
      },
    );
  }

  Widget _botaoInserirAdministrador() {
    return FlatButton(
      child: Text("Inserir administrador", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_ADMINISTRADOR);
      },
    );
  }

  Widget _botaoInserirGrupo() {
    return FlatButton(
      child: Text("Inserir grupo", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_INSERIR_GRUPO);
      },
    );
  }

  Widget _botaoGerenciarDicas() {
    return FlatButton(
      child: Text("Gerenciar dicas", style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_GERENCIAR_DICAS);
      },
    );
  }


  Widget _botaoSair() {
    return FlatButton(
      child: Text("Fazer logout do sistema", style: TextStyle(color: Colors.redAccent)),
      onPressed: () {
        SistemaLogin().sair();
        Navigator.pushNamedAndRemoveUntil(context, Rotas.TELA_INICIAL, (route) => false);
      },
    );
  }


  Widget _botaoListarUsuarios() {
    return FlatButton(
      child: Text('Listar usuários', style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        Navigator.pushNamed(context, Rotas.TELA_LISTAR_USUARIOS);
      },
    );
  }

  Widget _botaoNoticiasWeb() {
    return FlatButton(
      child: Text('Atualizar noticias da web', style: TextStyle(color: Cores.corTextMedio)),
      onPressed: () {
        SistemaNoticiasWeb.instance.verificarNovasNoticias();
      },
    );
  }
}
