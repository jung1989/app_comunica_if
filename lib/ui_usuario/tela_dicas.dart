import 'package:app_comunica_if/model/dica.dart';
import 'package:app_comunica_if/sistema/sistema_dicas.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaDicas extends StatefulWidget {
  @override
  _TelaDicasState createState() => _TelaDicasState();
}

class _TelaDicasState extends State<TelaDicas> {

  Dica _dica;

  @override
  void initState() {
    super.initState();
    _dica = SistemaDicas.instance.buscarDicaAleatoria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraSuperior(),
      body: painelDica(),
    );
  }

  Widget barraSuperior() {
    return AppBar(
      title: tituloAppBar("Uma dica para você!"),
      backgroundColor: Cores.corAppBarBackground,
      centerTitle: false,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _dica = SistemaDicas.instance.buscarDicaAleatoria();
            });
          },
        )
      ],
    );
  }


  Widget painelDica() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            imagemDica(),
            //textoDica()
          ],
        ),
      ),
    );
  }

  Widget textoDica() {
    return Container(
      //color: Cores.corFundo,
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Text(_dica.texto ?? "Sem texto...",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontFamily: 'Roboto')),
        ));
  }

  Widget imagemDica() {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20,left: 10, right: 10),
        padding: EdgeInsets.only(),
        child:  Image.network(_dica.caminhoImagem),
        decoration: BoxDecoration(
            color: Colors.white,

            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]));
  }
}
