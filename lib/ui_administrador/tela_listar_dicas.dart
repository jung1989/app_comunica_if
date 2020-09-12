
import 'package:app_comunica_if/model/dica.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:app_comunica_if/ui_usuario/tela_inserir_dica.dart';
import 'package:flutter/material.dart';

class TelaListarDicas extends StatefulWidget {
  @override
  _TelaListarDicasState createState() => _TelaListarDicasState();
}

class _TelaListarDicasState extends State<TelaListarDicas> {

  Future<List<Dica>> _futureDicas;
  List<Dica> _dicas = List();

  @override
  void initState() {
    super.initState();
    atualizarDicas();

  }

  Future atualizarDicas() async {
    _futureDicas = carregarDicas();
    _dicas =  await _futureDicas;
  }

  Future<List<Dica>> carregarDicas() async {
    return await SistemaAdmin.instance.carregarDicas();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Cores.corAppBarBackground,
          centerTitle: true,
          title: Text("Dicas inseridas")),
      body: listaDicas(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Cores.corIconesClaro,
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TelaInseirDica()
              )
          );
          _dicas = await carregarDicas();
          setState(() {

          });
        },
      ),
    );
  }

  Widget listaDicas() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
            child: Text("Carregando mensagens..."),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: _dicas.length,
            itemBuilder: (context, index) {
              return mensagemCard(context, index, _dicas);
            });
      },
      future: _futureDicas,
    );
  }

  Widget mensagemCard(
      BuildContext context, int index, List<Dica> listaTemporaria) {
    return GestureDetector(
      onTap: () async {

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TelaInseirDica(dica: listaTemporaria[index])
            )
        );
        _dicas = await carregarDicas();
        setState(() {

        });
      },
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: Cores.corIconesClaro,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(
                          listaTemporaria[index].texto,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Cores.corTextEscuro),
                        )),
                  ],
                ),
              ],
            )),
      ),
    );
  }




}
