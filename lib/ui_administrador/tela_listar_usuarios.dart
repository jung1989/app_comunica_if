import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaListarUsuarios extends StatefulWidget {
  @override
  _TelaListarUsuariosState createState() => _TelaListarUsuariosState();
}

class _TelaListarUsuariosState extends State<TelaListarUsuarios> {
  Future<List<Usuario>> _futureUsuarios;
  List<Usuario> _usuarios = List();

  @override
  void initState() {
    super.initState();
    atualizarUsuarios();
  }

  Future atualizarUsuarios() async {
    _futureUsuarios = carregarUsuarios();
    _usuarios = await _futureUsuarios;
  }

  Future<List<Usuario>> carregarUsuarios() async {
    return await SistemaAdmin.instance.carregarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: false,
          title: tituloAppBar("Usuários cadastrados"),
        elevation: 0,
      ),
      body: listaUsuarios(),
    );
  }

  Widget listaUsuarios() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando usuários..."),
          );
        }
        return Container(
          color: Colors.white,
          child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                return usuarioCard(context, index, _usuarios);
              }),
        );
      },
      future: _futureUsuarios,
    );
  }

  Widget usuarioCard(
      BuildContext context, int index, List<Usuario> listaTemporaria) {
    return Card(
      elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _iconeDeUsuario(listaTemporaria[index]),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: Text(
                    listaTemporaria[index].nome,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Cores.corTextEscuro),
                  )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(listaTemporaria[index].ativo
                      ? 'Último acesso: ${formatarDataHora(listaTemporaria[index].ultimoAcesso)}'
                      : ''),
                  SizedBox(width: 10),
                  Text(
                    listaTemporaria[index].ativo ? 'Ativo' : 'Inativo',
                    style: TextStyle(
                        color: listaTemporaria[index].ativo
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              ),
            ])));
  }

  Widget _iconeDeUsuario(Usuario usuario) {
    switch (usuario.perfil) {
      case Usuario.PERFIL_ADMINISTRADOR:
        return Icon(Icons.vpn_key, color: Cores.corIconesClaro);
        break;
      case Usuario.PERFIL_SERVIDOR:
        return Icon(Icons.assignment_ind, color: Cores.corIconesClaro);
        break;
      case Usuario.PERFIL_ALUNO:
        return Icon(Icons.school, color: Cores.corIconesClaro);
        break;
      default:
        return Icon(Icons.person, color: Cores.corIconesClaro);
        break;
    }
  }
}
