import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class GruposInteresse extends StatefulWidget {

  @override
  _GruposInteresseState createState() => _GruposInteresseState();
}

class _GruposInteresseState extends State<GruposInteresse> {
  List<Grupo> _grupos = SistemaUsuario().usuario.gruposInteresse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupos de interesse"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
      ),
      body:  listaGrupos(),

    );
  }

  Widget listaGrupos() {
    return ListView.builder(
        padding: EdgeInsets.all(15.0),
        itemCount: _grupos.length,
        itemBuilder: (context, index) {
          return checkGrupo(index);
        });
  }

  Widget checkGrupo(int index) {
    return CheckboxListTile(
      activeColor: Cores.corIconesClaro,
      onChanged: (bool selecionado) {
        setState(() {
          _grupos[index].selecionado = selecionado;
          GrupoInteresseHelper.atualizarGrupo(_grupos[index]);
        });
      },
      value: _grupos[index].selecionado,
      title: Text(
          _grupos[index].nome
      ),
    );
  }
}
