import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';

class TelaImportarAlunos extends StatefulWidget {
  @override
  _TelaImportarAlunosState createState() => _TelaImportarAlunosState();
}

class _TelaImportarAlunosState extends State<TelaImportarAlunos> {

  bool _alunosImportados = false;
  int _quantidadeDeAlunosImportados = 0;
  int _quantidadeDeAlunosIgnorados = 0;

  bool _isLoading = false;

  bool _limiteUltrapassado = true;

  Color _corBotao = Cores.corBotoes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _barraSuperior(),
      body: _corpo(),
    );
  }

  Widget _corpo() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              _infoGerarXLS(),
              _infoDownloadXLS(),
              _infoConverterArquivo(),
              _infoCarregarArquivo(),
              _inforResultado(),
              _botaoImportarAlunos()
            ],
          ),
        )
    );
  }

  Widget _infoGerarXLS() {
    return Row(
      children: <Widget>[
        Icon(Icons.web, color: Colors.grey, size: 30),
        _textoInfo("Acesse o SUAP e gere um relatório de alunos, ecolhendo o "
            "campus Camaquã, combinado com os filtros para seleção de "
            "cursos e turmas")
      ],
    );
  }

  Widget _infoDownloadXLS() {
    return Row(
      children: <Widget>[
        Icon(Icons.file_download, color: Colors.grey, size: 30),
        _textoInfo("Fazer o download do relatório de alunos, em fomato XLS, no SUAP")
      ],
    );
  }

  Widget _inforResultado() {
    return Visibility(
      visible: _alunosImportados,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Visibility(
                  visible: _limiteUltrapassado,
                  child:  Row(
                    children: <Widget>[
                      Icon(Icons.done, color: Colors.red),
                      Text("Arquivo contém mais de 50 usuários")
                    ],
                  ),
                ),
        Visibility(
        visible: !_limiteUltrapassado,
        child: Row(
                  children: <Widget>[
                    Icon(Icons.done, color: Colors.green),
                    Text("$_quantidadeDeAlunosImportados alunos importados")
                  ],
                )),
        Visibility(
          visible: !_limiteUltrapassado,
          child: Row(
                  children: <Widget>[
                    Icon(Icons.close, color: Colors.red),
                    Text("$_quantidadeDeAlunosIgnorados já importados anteriormente")
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoConverterArquivo() {
    return Row(
      children: <Widget>[
        Icon(Icons.report_problem, color: Colors.grey, size: 30),
        _textoInfo("Abrir o arquivo XLS com um aplicativo de planilhas e converter para o formato CSV")
      ],
    );
  }

  Widget _infoCarregarArquivo() {
    return Row(
      children: <Widget>[
        Icon(Icons.file_upload, color: Colors.grey, size: 30,),
        _textoInfo("Clique no botão abaixo e procure o arquivo convertido para o formato CSV")
      ],
    );
  }

  Widget _textoInfo(String texto) {
    return Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            child: Text(texto, style: TextStyle(fontSize: 16),),
        )
    );
  }

  Widget _barraSuperior() {
    return AppBar(
      backgroundColor: Cores.corAppBarBackground,
      centerTitle: true,
      title: Text("Importar alunos"),
    );
  }

  Widget _botaoImportarAlunos() {
    return Padding(
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: SizedBox(
              height: 40.0,
              child: new FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: _corBotao,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.file_upload, color: Colors.white),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Importar alunos',
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    SizedBox(width: 20),
                    SizedBox(child: _showCircularProgress(), height: 20, width: 20),
                  ],
                ),
                onPressed: () async {
                  if(!_isLoading) {
                    setState(() {
                      _corBotao = Colors.grey;
                      _isLoading = true;
                    });

                    Map retorno = await SistemaAdmin.instance
                        .gravarUsuariosDeArquivo();
                    setState(() {
                      if(retorno.containsKey('limite')) {
                        _limiteUltrapassado = true;
                        _quantidadeDeAlunosImportados = 0;
                        _quantidadeDeAlunosIgnorados = 0;
                      }
                      else {
                        print(retorno);
                        _limiteUltrapassado = false;
                        _quantidadeDeAlunosImportados = retorno['aceitos'];
                        _quantidadeDeAlunosIgnorados = retorno['recusados'];
                      }
                      _alunosImportados = true;
                      _isLoading = false;
                      _corBotao = Cores.corBotoes;
                    });
                  }
                  else {
                    print('### Botão desabilitado...');
                  }
                },
              ),
            )
    );
  }

  Widget _showCircularProgress() {
    return Visibility(
        visible: _isLoading,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ));
  }
}
