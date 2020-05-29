import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

Mensagem mensagem;

class InserirMensagem extends StatefulWidget {
  @override
  _InserirMensagemState createState() => _InserirMensagemState();
}

class _InserirMensagemState extends State<InserirMensagem> {

  GlobalKey<FormState> _chave = GlobalKey<FormState>();

  TextEditingController _controllerTitulo;
  TextEditingController _controllerConteudo;

  List<Grupo> _grupos = List();

  @override
  void initState() {

    _grupos = BancoFiciticio.gruposBanco;

    mensagem = Mensagem();
    _controllerTitulo = TextEditingController();
    _controllerConteudo = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova mensagem"),
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
            listaCheck(),
            SizedBox(height: 20),
            RaisedButton(
              child: Text("Publicar mensagem"),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                if(_chave.currentState.validate()) {
                  publicarMensagem();
                }
              },
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }


  bool _selecionarTodos = false;
  Widget listaCheck() {
    List<CheckboxListTile> checks = List();

    CheckboxListTile check = CheckboxListTile(
      onChanged: (bool selecionado) {
        setState(() {
          for(Grupo g in _grupos) {
            g.selecionado = selecionado;
          }
          _selecionarTodos = selecionado;
        });
      },
      value: _selecionarTodos,
      title: Text(
          "Selecionar todos"
      ),
    );
    checks.add(check);

    print(_grupos.length);
    for(Grupo g in _grupos) {
      check = CheckboxListTile(
        onChanged: (bool selecionado) {
          setState(() {
            _selecionarTodos = false;
            g.selecionado = selecionado;
          });
        },
        value: g.selecionado,
        title: Text(
          g.nome
        ),
      );
      checks.add(check);
    }
    return Column(
      children: checks,
    );
  }

  publicarMensagem() {
    mensagem.titulo = _controllerTitulo.text;
    mensagem.conteudo = _controllerConteudo.text;
    mensagem.dataHoraPublicacao = DateTime.now();

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Publicar?"),
              content:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      linhaTextoExpandida("Após publicada, a mensagem não poderá ser alterada."),
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
                      if (BancoFiciticio.inserirMensagem(mensagem)) {
                        Navigator.pop(context);
                      }
                      Navigator.pop(context);
                    }),
              ],
            ));
  }
}
