import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class InserirMensagem extends StatefulWidget {
  @override
  _InserirMensagemState createState() => _InserirMensagemState();
}

class _InserirMensagemState extends State<InserirMensagem> {
  GlobalKey<FormState> _chave = GlobalKey<FormState>();

  TextEditingController _controllerTitulo;
  TextEditingController _controllerConteudo;

  Future _futureGrupos;
  List<Grupo> _grupos = List();

  bool _isEnviandoMensagem = false;

  Mensagem _mensagem;

  @override
  void initState() {
    super.initState();

    _futureGrupos = carregarGrupos();

    _mensagem = Mensagem();
    _controllerTitulo = TextEditingController();
    _controllerConteudo = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova mensagem"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: montarMensagem(),
      ),
    );
  }

  Widget montarMensagem() {
    return Form(
      key: _chave,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            inputLinhaSimples("Título da mensagem", _controllerTitulo),
            SizedBox(height: 20),
            inputLinhaSimples("Conteúdo da mensagem", _controllerConteudo),
            SizedBox(height: 40),
            titulo("Grupos para envio"),
            listaGrupos(),
            SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Publicar mensagem"),
                  color: Cores.corBotoes,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_chave.currentState.validate()) {
                      publicarMensagem();
                    }
                  },
                )),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget listaGrupos() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return listaCheck();
      },
      future: _futureGrupos,
    );
  }

  Future carregarGrupos() async {
    _grupos = await SistemaAdmin().carregarGrupos();
    for (Grupo g in _grupos) {
      g.selecionado = false;
    }
  }

  bool _selecionarTodos = false;

  Widget listaCheck() {
    List<CheckboxListTile> checks = List();

    CheckboxListTile check = CheckboxListTile(
      activeColor: Cores.corIconesClaro,
      onChanged: (bool selecionado) {
        setState(() {
          for (Grupo g in _grupos) {
            g.selecionado = selecionado;
          }
          _selecionarTodos = selecionado;
        });
      },
      value: _selecionarTodos,
      title: Text("Selecionar todos"),
    );
    checks.add(check);

    for (Grupo g in _grupos) {
      check = CheckboxListTile(
        activeColor: Cores.corIconesClaro,
        onChanged: (bool selecionado) {
          setState(() {
            _selecionarTodos = false;
            g.selecionado = selecionado;
          });
        },
        value: g.selecionado,
        title: Text(g.nome),
      );
      checks.add(check);
    }
    return Column(
      children: checks,
    );
  }

  publicarMensagem() {
    _mensagem.titulo = _controllerTitulo.text;
    _mensagem.conteudo = _controllerConteudo.text;
    _mensagem.dataHoraPublicacao = DateTime.now();
    _mensagem.administrador = SistemaAdmin().administrador;

    bool alunos = false;
    bool servidores = false;

    List<Grupo> grupos = List();
    for (Grupo g in _grupos) {
      print("@@@ ${g.restricao}");
      if (g.selecionado) {
        grupos.add(g);
        if(g.restricao == Usuario.PERFIL_ALUNO) {
          alunos = true;
        }
        if(g.restricao == Usuario.PERFIL_SERVIDOR) {
          servidores = true;
        }
      }
    }
    _mensagem.gruposInteresse = grupos;

    /// restricao = 1 : somente servidores
    /// restricao = 2 : somente alunos
    /// restricao = 9 : alunos e professores

    _mensagem.restricao = 0;
    if(alunos && servidores) {
      _mensagem.restricao = 9;
    }
    else {
      if(alunos) {
        _mensagem.restricao = 2;
      }
      if(servidores) {
        _mensagem.restricao = 1;
      }
    }


    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Publicar?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  linhaTextoExpandida(
                      "Após publicada, a mensagem não poderá ser alterada."),
                  SizedBox(height: 20),
                  linhaTextoExpandida("Deseja realmente publicar?"),
                ],
              ),
              actions: <Widget>[
                Visibility(
                  visible: _isEnviandoMensagem,
                  child: Center(child: CircularProgressIndicator()),
                ),
                Visibility(
                  visible: !_isEnviandoMensagem,
                    child: FlatButton(
                      child: Text("Não"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                )),
                Visibility(
                  visible: !_isEnviandoMensagem,
                  child: FlatButton(
                      child: Text("Sim"),
                      onPressed: () async {
                        setState(() {
                          _isEnviandoMensagem = true;
                        });
                        await SistemaAdmin().gravarMensagem(_mensagem);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                )
              ],
            ));
  }
}
