import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaInserirAdministrador extends StatefulWidget {
  @override
  _TelaInserirAdministradorState createState() => _TelaInserirAdministradorState();
}

class _TelaInserirAdministradorState extends State<TelaInserirAdministrador> {
  final _formKey = new GlobalKey<FormState>();
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  String _matricula;
  String _nome;
  String _errorMessage;
  String _email;
  String _senha;

  bool _isLoading;

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
        Usuario novoAdministrador = Usuario();
        novoAdministrador.nome = _nome;
        novoAdministrador.matricula = _matricula;
        novoAdministrador.email = _email;
        novoAdministrador.perfil = Usuario.PERFIL_ADMINISTRADOR;
        novoAdministrador.ativo = true;
        novoAdministrador.ultimoAcesso = DateTime.fromMillisecondsSinceEpoch(0);

        print(SistemaLogin.instance.autenticacao);
        bool verifica = await SistemaLogin.instance.autenticacao.cadastrarAdministrador(novoAdministrador, _senha);

        if (verifica) {
          print("### Administrador inserido com sucesso...");
          _formKey.currentState.reset();

          final snack = SnackBar(
            content: Text("Administrador cadastrado!"),
            duration: Duration(seconds: 5),

          );
          _chaveScaffold.currentState.showSnackBar(snack);

        } else {
          print("### Erro ao inserir administrador...");
          setState(() {
            _isLoading = false;
            _errorMessage = "Matrícula já cadastrada";
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
          title: Text("Cadastrar administrador"),
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
              inputMatricula(),
              inputNome(),
              inputEmail(),
              inputSenha(),
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

  Widget inputMatricula() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            labelText: 'Matrícula ou SIAPE',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            //hintText: 'Matrícula ou SIAPE',
            icon: new Icon(
              Icons.vpn_key,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => _matricula = value.trim(),
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
            labelText: 'Nome',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            //hintText: 'Nome',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => _nome = value.trim(),
      ),
    );
  }

  Widget inputEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
            labelText: 'Email',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            //hintText: 'Email',
            icon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget inputSenha() {
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
            labelText: 'Senha',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            //hintText: 'Senha',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => _senha = value.trim(),
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


}
