import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaRedefinirSenha extends StatefulWidget {
  @override
  _TelaRedefinirSenhaState createState() => _TelaRedefinirSenhaState();
}

class _TelaRedefinirSenhaState extends State<TelaRedefinirSenha> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _controllerEmail = TextEditingController();

  String _email;
  bool _isLoading;
  String _errorMessage;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;

    if (SistemaLogin.instance.autenticacao.firebaseUser != null) {
      _email = SistemaLogin.instance.autenticacao.firebaseUser.email;
      _controllerEmail.text = _email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: true,
          title: Text("Redefinir senha"),
        ),
        body: Stack(
          children: <Widget>[
             _showForm(),
            //_showCircularProgress(),
          ],
        ));
  }

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
      try {
        await SistemaLogin.instance.autenticacao.redefinirSenha(_email);
        await Future.delayed(Duration(seconds: 30));
        print("### Enviando email de redefinição de senha para $_email...");
      } catch (e) {
        print('Error: $e');

        setState(() {
          _isLoading = false;
          _errorMessage = "Email incorreto";
          //_formKey.currentState.reset();
        });
      }
    }
    setState(() {
      _isLoading = false;
      _errorMessage = "";
      //_formKey.currentState.reset();
      _controllerEmail.text = "";
      _isLoading = false;
    });

  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              //_showCircularProgress(),
              textoInstrucao(),
              inputEmail(),
              botaoRedefinir(),
              mensagemErro(),
            ],
          ),
        ));
  }

  Widget _showCircularProgress() {
    //if (_isLoading) {
      return Visibility(
        visible: _isLoading,
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),

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

  Widget botaoRedefinir() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                SizedBox(width: 30,),
                Text('Redefinir senha',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                SizedBox(width: 10,),
                SizedBox(
                  child: _showCircularProgress(),
                  height: 20, width: 20
                ),
              ],
            ),
            onPressed: validarESubmeter,
          ),
        ));
  }

  Widget textoInstrucao() {
    return Text(
      "Um email será enviado com instruções de como redefirnir sua senha",
      style: TextStyle(fontSize: 20),
    );
  }

  Widget inputEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
      child: new TextFormField(
        controller: _controllerEmail,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        enabled: !_isLoading,
        decoration: new InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Cores.corTextMedio),
            ),
            //labelStyle: TextStyle(fontSize: 20, color: Cores.corTextMedio),
            labelText: 'Email cadastrado',
            labelStyle: TextStyle(color: Cores.corTextMedio),
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Campo orbrigatório' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }
}
