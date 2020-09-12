

import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class SistemaNoticiasWeb {

  static const double VERSAO = 2.0;

  /// implementação do singleton
  static final SistemaNoticiasWeb _instance = SistemaNoticiasWeb._interno();

  factory SistemaNoticiasWeb() => _instance;

  SistemaNoticiasWeb._interno();

  static SistemaNoticiasWeb get instance => _instance;

  Future verificarNovasNoticias() async{
    final resposta = await http.Client().get(Uri.parse('http://www.camaqua.ifsul.edu.br/ultimas-noticias'));

    DateTime dataHoraUltimaNoticia;

    /// data e hora da última notícia inserida agora
    DateTime dataHoraUltimaNoticiaAgora;

    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("noticia_web")
        .document('data_hora')
        .get();
    if (documentSnapshot.data.isNotEmpty) {
      dataHoraUltimaNoticia = DateTime.fromMillisecondsSinceEpoch(documentSnapshot.data['data_hora']);
    }

    dataHoraUltimaNoticiaAgora = dataHoraUltimaNoticia;

    if(resposta.statusCode == 200) {
      var documento = parse(resposta.body);
      var noticiasHTML = documento.getElementsByClassName('tileItem');
      for(var noticiaHTML in noticiasHTML) {
        var data = noticiaHTML.getElementsByClassName('tileInfo')[0].getElementsByTagName('ul')[0].children[2].text.split('/');

        var hora = noticiaHTML.getElementsByClassName('tileInfo')[0].getElementsByTagName('ul')[0].children[3].text.split('h');

        DateTime dataHora = DateTime(2000 + int.parse(data[2]), int.parse(data[1]), int.parse(data[0]), int.parse(hora[0]), int.parse(hora[1]));

        var link = noticiaHTML.getElementsByClassName('tileHeadline')[0].getElementsByTagName('a')[0].attributes['href'];

        var titulo = noticiaHTML.getElementsByClassName('tileHeadline')[0].getElementsByTagName('a')[0].text;

        if(dataHoraUltimaNoticia.isBefore(dataHora)) {

          Noticia noticia = Noticia();
          noticia.titulo = '';

          noticia.dataHoraPublicacao = dataHora;
          noticia.administrador = Usuario.construirComNome("Sistema");

          noticia.linkWeb = 'http://www.camaqua.ifsul.edu.br/ultimas-noticias$link';

          noticia.titulo = titulo;
          print('### Noticia da web gravada com link: ${noticia.linkWeb}');
          print(noticia.titulo);

          await SistemaAdmin.instance.gravarNoticia(noticia);
        }
        else {
          break;
        }

        if(dataHoraUltimaNoticiaAgora.isBefore(dataHora)) {
          dataHoraUltimaNoticiaAgora = dataHora;
        }
      }
      print(' >>> Última data inserida agora $dataHoraUltimaNoticiaAgora');

      if(dataHoraUltimaNoticiaAgora.isAfter(dataHoraUltimaNoticia)) {
        await Firestore.instance
            .collection("noticia_web")
            .document('data_hora')
            .updateData(
            {'data_hora': dataHoraUltimaNoticiaAgora.millisecondsSinceEpoch});
      }
      else {
        print('### Não há novas notícias na web');
      }

      print(DateTime(2020, 8, 4).millisecondsSinceEpoch);

      /// 1596510000000
      /// 1595450940000
    }
  }

}