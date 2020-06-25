import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/autenticacao.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_administrador/tela_administrador.dart';
import 'package:app_comunica_if/ui_usuario/tela_usuario_mensagens.dart';
import 'package:flutter/material.dart';

import 'efeitos_visuais.dart';

class TelaLogin extends StatefulWidget {
  TelaLogin();

  @override
  State<StatefulWidget> createState() => new _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _senha;
  String _matricula;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  /// efetua a validação dos campos do formulário
  bool validarESalvar() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  ///
  void validarESubmeter() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validarESalvar()) {
      String emailUsuario = "";
      try {
        if (_isLoginForm) {
          /// caso esteja tentando entrar no sistema
          emailUsuario =
              await SistemaLogin.instance.autenticacao.logar(_email, _senha);
          int perfil = await SistemaLogin().buscarPerfil(emailUsuario);
          switch (perfil) {
            case Usuario.PERFIL_ALUNO:
            case Usuario.PERFIL_SERVIDOR:
              Navigator.pushNamedAndRemoveUntil(context, Rotas.TELA_MENSAGENS_USUARIO, (route) => false);
              break;
            case Usuario.PERFIL_ADMINISTRADOR:
              Navigator.pushNamedAndRemoveUntil(context, Rotas.TELA_ADMINISTRADOR, (route) => false);
              break;
          }
        } else {
          /// caso esteja tentando se cadastrar no sistema
          String id =
              await SistemaLogin.instance.verificarMatricula(_matricula);

          if (id.isNotEmpty) {
            print("### Matrícula de uusário cadastrada...");
            emailUsuario = await SistemaLogin.instance.autenticacao
                .cadastrarUsuario(_email, _senha, id);
            _isLoginForm = true;
            print("### Usuário logado com email $emailUsuario...");
          } else {
            print("### Matrícula de uusário não cadastrada...");
            setState(() {
              _isLoading = false;
              _errorMessage = "Matrícula ou SIAPE não cadastrado";
            });
          }
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          //print('Signed up user: $emailUsuario');
        }
        setState(() {
          _isLoading = false;
        });

//        if (emailUsuario.length > 0 && emailUsuario != null && _isLoginForm) {
//          widget.loginCallback();
//        }
      } catch (e) {
        print('Error: $e');

        setState(() {
          _isLoading = false;
          _errorMessage = "Email ou senha estão incorretos";
          //_formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              logo(),
              inputMatricula(),
              inputEmail(),
              inputSenha(),
              botaoEntrarCadastrar(),
              botaoAlternar(),
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
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: Icon(_isLoginForm ? Icons.person : Icons.person_add,
            size: 90, color: Cores.corBotoes),
      ),
    );
  }

  Widget inputEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo orbrigatório' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget inputMatricula() {
    return Visibility(
      visible: !_isLoginForm,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Matrícula ou SIAPE',
              icon: new Icon(
                Icons.vpn_key,
                color: Colors.grey,
              )),
          validator: (value) {
            if (!_isLoginForm) {
              return value.isEmpty ? 'Campo orbrigatório' : null;
            }
            return null;
          },
          onSaved: (value) => _matricula = value.trim(),
        ),
      ),
    );
  }

  Widget inputSenha() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
            hintText: 'Senha',
            //labelText: 'Senha',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => _senha = value.trim(),
      ),
    );
  }

  Widget botaoAlternar() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Criar conta' : 'Já tem uma conta? Entre',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget botaoEntrarCadastrar() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Cores.corBotoes,
            child: new Text(_isLoginForm ? 'Entrar' : 'Criar conta',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validarESubmeter,
          ),
        ));
  }
}
