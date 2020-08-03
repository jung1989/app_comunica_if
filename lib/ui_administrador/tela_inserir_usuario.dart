import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaInserirUsuario extends StatefulWidget {
  @override
  _TelaInserirUsuarioState createState() => _TelaInserirUsuarioState();
}

class _TelaInserirUsuarioState extends State<TelaInserirUsuario> {
  final _formKey = new GlobalKey<FormState>();
  final _chaveScaffold = GlobalKey<ScaffoldState>();

  String _matricula;
  String _nome;
  String _errorMessage;
  int _numeroPerfil = Usuario.PERFIL_SERVIDOR;

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
        Usuario novoUsuario = Usuario();
        novoUsuario.nome = _nome;
        novoUsuario.matricula = _matricula;
        novoUsuario.perfil = _numeroPerfil;
        novoUsuario.ativo = false;
        novoUsuario.ultimoAcesso = DateTime.fromMillisecondsSinceEpoch(0);

        bool verifica = await SistemaAdmin.instance.gravarUsuario(novoUsuario);
        if (verifica) {
          print("### Usuário inserido com sucesso...");
          _formKey.currentState.reset();

          final snack = SnackBar(
            content: Text("Usuário cadastrado!"),
            duration: Duration(seconds: 5),
          );
          _chaveScaffold.currentState.showSnackBar(snack);
        } else {
          print("### Erro ao inserir usuário...");
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
          title: Text("Cadastrar usuário"),
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

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0,bottom: 16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              logo(),
              radios(),
              inputMatricula(),
              inputNome(),
              botaoCadastrar(),
              _botaoListarUsuarios(),
              botaoImportarAlunos(),
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
            //hintText: 'Matrícula ou SIAPE',
            labelText: 'Matrícula ou SIAPE',
            labelStyle: TextStyle(color: Cores.corTextMedio),
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
              Icons.lock,
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

  Widget _botaoListarUsuarios() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Cores.corBotoes,
            child: new Text('Listar usuários',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              Navigator.pushNamed(context, Rotas.TELA_LISTAR_USUARIOS);
            }
          ),
        ));
  }

  Widget botaoImportarAlunos() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new FlatButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: Cores.corBotoes,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.file_upload, color: Colors.white),
                SizedBox(
                  width: 15,
                ),
                Text('Importar alunos',
                    style: TextStyle(fontSize: 20.0, color: Colors.white))
              ],
            ),
            onPressed: () async {
              Navigator.pushNamed(context, Rotas.TELA_IMPORTAR_ALUNOS);
            },
          ),
        ));
  }

  Widget radios() {
    return Column(
      children: <Widget>[
        RadioListTile(
          title: Text("Servidor"),
          value: Usuario.PERFIL_SERVIDOR,
          groupValue: _numeroPerfil,
          onChanged: _radioModificado,
          activeColor: Cores.corTextMedio,
        ),
        RadioListTile(
          title: Text("Aluno"),
          value: Usuario.PERFIL_ALUNO,
          groupValue: _numeroPerfil,
          onChanged: _radioModificado,
          activeColor: Cores.corTextMedio,
        )
      ],
    );
  }

  void _radioModificado(int valor) {
    setState(() {
      _numeroPerfil = valor;
      print(_numeroPerfil);
    });
    //
  }
}
