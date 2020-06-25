import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaInserirGrupo extends StatefulWidget {
  @override
  _TelaInserirGrupoState createState() => _TelaInserirGrupoState();
}

class _TelaInserirGrupoState extends State<TelaInserirGrupo> {
  final _formKey = new GlobalKey<FormState>();
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  String _nome;
  String _errorMessage;

  bool _isLoading;

  int _numeroRestricao = Usuario.PERFIL_SERVIDOR;

  // Check if form is valid before perform login or signup
  bool validarESalvar() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validarESalvar()) {
      try {

        bool verifica = await SistemaAdmin.instance.gravarGrupo(_nome, _numeroRestricao);

        if (verifica) {
          print("### Grupo inserido com sucesso...");
          _formKey.currentState.reset();

          final snack = SnackBar(
            content: Text("Grupo cadastrado!"),
            duration: Duration(seconds: 5),

          );
          _chaveScaffold.currentState.showSnackBar(snack);
        } else {
          print("### Erro ao inserir grupo...");
          setState(() {
            _isLoading = false;
            _errorMessage = "Grupo já cadastrado";
          });
        }

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = "Erro ao cadastrar";
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _chaveScaffold,
        appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: true,
          title: Text("Cadastrar grupo"),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              logo(),
              radios(),
              inputNome(),
              botaoCadastrar(),
              mensagemErro(),
            ],
          ),
        ));
  }

  Widget mensagemErro() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Center(
          child: Text(
            _errorMessage,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Icon(Icons.person_add, size: 90, color: Cores.corBotoes),
      ),
    );
  }


  Widget inputNome() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
            hintText: 'Nome',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => _nome = value.trim(),
      ),
    );
  }

  Widget botaoCadastrar() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Cores.corBotoes,
            child: new Text('Cadastrar',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }


  Widget radios() {
    return Column(
      children: <Widget>[
        RadioListTile(
          title: Text("Servidor"),
          value: Usuario.PERFIL_SERVIDOR,
          groupValue: _numeroRestricao,
          onChanged: _radioModificado,
        ),
        RadioListTile(
          title: Text("Aluno"),
          value: Usuario.PERFIL_ALUNO,
          groupValue: _numeroRestricao,
          onChanged: _radioModificado,
        )
      ],
    );
  }

  void _radioModificado(int valor) {
    setState(() {
      _numeroRestricao = valor;
    });
    //
  }

}
