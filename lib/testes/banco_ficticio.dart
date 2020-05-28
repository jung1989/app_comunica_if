
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';


class BancoFiciticio {

  static List<Mensagem> _mensagensBanco;
  static List<Noticia> _noticiasBanco;

  static List<Mensagem>  get mensagensBanco {
    if(_mensagensBanco == null) {
      _carregarMensagens();
    }
    return _mensagensBanco;
  }

  static List<Noticia>  get noticiasBanco {
    if(_noticiasBanco == null) {
      _carregarNoticias();
    }
    return _noticiasBanco;
  }

  static List<Mensagem>  mensagensLidas() {
    List<Mensagem> lidas = List();
    lidas.addAll(mensagensBanco);
    lidas.retainWhere((mensagem) => mensagem.lida);
    return lidas;
  }

  static List<Mensagem>  mensagensNaoLidas() {
    List<Mensagem> naoLidas = List();
    naoLidas.addAll(mensagensBanco);
    naoLidas.retainWhere((mensagem) => !mensagem.lida);
    return naoLidas;
  }

  static List<Mensagem>  mensagensFavoritas() {
    List<Mensagem> favoritas = List();
    favoritas.addAll(mensagensBanco);
    favoritas.retainWhere((mensagem) => mensagem.favorita);
    return favoritas;
  }

  static void _carregarMensagens() {

    _mensagensBanco = List();

    Mensagem m1 = Mensagem();
    m1.titulo = "Título 1";
    m1.conteudo = "Conteúdo da mensagem inserida manualmente";
    m1.lida = true;
    m1.favorita = true;
    m1.dataHoraPublicacao = DateTime.now();
    _mensagensBanco.add(m1);

    Mensagem m2 = Mensagem();
    m2.titulo = "Título 2";
    m2.conteudo = "Mensagem inserida manualmente";
    m2.lida = false;
    m2.favorita = false;
    m2.dataHoraPublicacao = DateTime.now();
    _mensagensBanco.add(m2);

    Mensagem m3;
    for (int c = 3; c < 10; c++) {
      m3 = Mensagem();
      m3.titulo = "Título $c";
      m3.conteudo = "Mensagem inserida manualmente";
      m3.lida = false;
      m3.favorita = false;
      m3.dataHoraPublicacao = DateTime.now();
      _mensagensBanco.add(m3);
    }
  }

  static void _carregarNoticias() {

    _noticiasBanco = List();

    print("Carregando noticias");


    Noticia n;
    for (int c = 1; c < 11; c++) {
      n = Noticia();
      n.titulo = "Título $c iu bb ib iub ibib ib ib iub iubiubiub ";
      n.dataHoraPublicacao = DateTime.now();

      Conteudo c1 = Conteudo();
      c1.tipo = 1;
      c1.texto = "AIUHASIUHAihsi Iua iaU D ds dus das du sdbuisabd usab "
          "dubduibsid sadsd usbdu sa dus dibadusabdui dusad uis dsdiusbdiu dcd";
      n.conteudos.add(c1);

      Conteudo c2 = Conteudo();
      c2.tipo = 2;
      c2.texto = "imagens/imagemteste.png";
      n.conteudos.add(c2);

      Conteudo c3 = Conteudo();
      c3.tipo = 1;
      c3.texto = "fdsdsfsdfsd u uihuihiuh uih uih u huh iuh iuhiuh iuh iuh iuh i "
          "ojojoij j oj oij oijoij oijioj oji iijoijoijij oij iojoi joi j"
          "osdhfsdhi uhdiuhsiu hfusidhf iusdhuifh  io oih oih oih oih ioh ioh h"
          " hoh oi hoi hoi ho iho ihoihoihoi hoihoihoi hoih iohoi hoihoihoih oh "
          "iu hu hiuhiuhiuhi uhiu hiuhiuhiuhiu huihiuhuh iuhiuhiu hiu hiuh iuh "
          "uh iuhiu hiu hiuh iuhi uhiu huihuihiu uihiu hiuh uihiuhi uhiu hui"
          " iuhiuh iuh iuh iuh iuhiuhuihiuhuihu ii gyug uguy gyug yug ";
      n.conteudos.add(c3);
      n.conteudos.add(c3);
      n.conteudos.add(c3);

      Conteudo c4 = Conteudo();
      c4.tipo = 2;
      c4.texto = "imagens/imagemteste.png";
      n.conteudos.add(c4);

      Conteudo c5 = Conteudo();
      c5.tipo = 3;
      c5.texto = "http://www.ifsul.edu.br/";
      n.conteudos.add(c5);

      _noticiasBanco.add(n);
    }
  }

}



