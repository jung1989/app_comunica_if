
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

Future<List<List<dynamic>>> _loadCsvData(String path) async {
  print("### Carregando arquivo csv...");
  final file = new File(path).openRead();
  return await file
      .transform(latin1.decoder)
      .transform(new CsvToListConverter(fieldDelimiter: ';'))
      .toList();
}

Future<List> _getCSVData(String path) async {
  print("### Obtendo arquivo csv...");

  List listaMaps = List();

  List listaBruta = await _loadCsvData(path);
  print(listaBruta[0]);

  List<dynamic> cabecalhos = listaBruta[0];

  listaBruta.removeAt(0);

  for(var aluno in listaBruta) {
    Map<String, String> dados = Map();
    for(int c = 0; c < cabecalhos.length; c++) {
      dados[cabecalhos[c].toString().toLowerCase()] = aluno[c].toString();
    }
    /// prenvenção para que o relatório não seja de servidores
    if(dados['matricula'].length > 10) {
      listaMaps.add({'nome': dados['nome'], 'matricula': dados['matrícula']});
    }
   }

  for(Map m in listaMaps) {
    print(m);
  }

  return listaMaps;
}

Future<List> abrirArquivo() async{
  print("### Procurando arquivo...");
  String filePath = '';
  filePath = await FilePicker.getFilePath(
      type: FileType.custom);
  if (filePath != null && filePath != "") {
    return await _getCSVData(filePath);
  }
  return null;
}