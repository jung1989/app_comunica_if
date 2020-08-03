import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/navegacao.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

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
  String _confirmarSenha;

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
    if (_isLoading) return;
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
              Navigator.pushNamedAndRemoveUntil(
                  context, Rotas.TELA_MENSAGENS_USUARIO, (route) => false);
              break;
            case Usuario.PERFIL_ADMINISTRADOR:
              Navigator.pushNamedAndRemoveUntil(
                  context, Rotas.TELA_ADMINISTRADOR, (route) => false);
              break;
          }
        } else {
          /// caso esteja tentando se cadastrar no sistema
          if(_senha != _confirmarSenha) {
            _isLoading = false;
            _errorMessage = "Senha e confirmação não são iguais";
          }
          else {
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
          }
        }
        setState(() {
          _isLoading = false;
        });

      } catch (e) {
        print('Error: $e');

        setState(() {
          _isLoading = false;
          _errorMessage = "Email ou senha estão incorretos";
          //_formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "";
        _isLoading = false;
      });
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
    if (_isLoading) return;
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
        //_showCircularProgress(),
      ],
    ));
  }

  Widget _showCircularProgress() {
    return Visibility(
        visible: _isLoading,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ));
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
              inputConfirmaSenha(),
              mensagemErro(),
              botaoEntrarCadastrar(),
              botaoAlternar(),
              botaoRedefinirSenha(),
            ],
          ),
        ));
  }

  Widget mensagemErro() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
            child: Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        )),
      );
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
        enabled: !_isLoading,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
            labelText: 'Email',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            //hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value){
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if(value.isEmpty) {
            return 'Campo orbrigatório';
          }
          else {
            if(!regex.hasMatch(value)) {
              return 'Email inválido';
            }
          }
          return null;
        },
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
          enabled: !_isLoading,
          decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Cores.corTextMedio),
              ),
              //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
              labelText: 'Matrícula ou SIAPE',
              labelStyle: TextStyle(color: Cores.corTextMedio),
              //hintText: 'Matrícula ou SIAPE',
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

  Widget inputConfirmaSenha() {
    return Visibility(
      visible: !_isLoginForm,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          keyboardType: TextInputType.text,
          autofocus: false,
          enabled: !_isLoading,
          decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Cores.corTextMedio),
              ),
              //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
              labelText: 'Confirmar senha',
              labelStyle: TextStyle(color: Cores.corTextMedio),
              //hintText: 'Matrícula ou SIAPE',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) {
            if (!_isLoginForm) {
              return value.isEmpty ? 'Campo orbrigatório' : null;
            }
            return null;
          },
          onSaved: (value) => _confirmarSenha = value.trim(),
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
        enabled: !_isLoading,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
            labelText: 'Senha',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            //hintText: 'Senha',
            //labelText: 'Senha',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) {
          if(value.isEmpty) {
            return 'Campo obrigatório';
          }
          else {
            if(value.length < 6){
              return 'A senha deve conter ao menos 6 caracteres';
            }
          }
          return null;
        },
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

  Widget botaoRedefinirSenha() {
    return Visibility(
        visible: _isLoginForm,
        child: FlatButton(
            child: new Text('Esqueci minha senha',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
            onPressed: () {
              Navigator.pushNamed(context, Rotas.TELA_REDEFINIR_SENHA);
            }));
  }

  Widget botaoEntrarCadastrar() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Cores.corBotoes,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Text(_isLoginForm ? 'Entrar' : 'Criar conta',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                SizedBox(
                  width: 10,
                ),
                SizedBox(child: _showCircularProgress(), height: 20, width: 20),
              ],
            ),

//            new Text(_isLoginForm ? 'Entrar' : 'Criar conta',
//                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validarESubmeter,
          ),
        ));
  }
}
