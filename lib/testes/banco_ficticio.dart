import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/sistema/sistema_usuario.dart';


class BancoFiciticio {

  static List<Mensagem> _mensagensBanco;
  static List<Noticia> _noticiasBanco;
  static List<Grupo> _gruposBanco;
  //static List<Administrador> _adminsBanco;

  static List<Mensagem>  get mensagensBanco {
    if(_mensagensBanco == null) {
     // _carregarMensagens();
    }
    return _mensagensBanco;
  }

//  static List<Administrador>  get adminsBanco {
//    if(_adminsBanco == null) {
//      _carregarAdmins();
//    }
//    return _adminsBanco;
//  }

//  static List<Grupo> get gruposBanco {
//    if(_gruposBanco == null) {
//      _carregarGrupos();
//    }
//    return _gruposBanco;
//  }

  static List<Noticia> get noticiasBanco {
    if(_noticiasBanco == null) {
      _carregarNoticias();
    }
    return _noticiasBanco;
  }

  static List<Mensagem> mensagensLidas() {
    List<Mensagem> lidas = List();
    lidas.addAll(mensagensBanco);
    lidas.retainWhere((mensagem) => mensagem.lida);
    return lidas;
  }

  static List<Mensagem> mensagensNaoLidas() {
    List<Mensagem> naoLidas = List();
    naoLidas.addAll(mensagensBanco);
    naoLidas.retainWhere((mensagem) => !mensagem.lida);
    return naoLidas;
  }

  static List<Mensagem> mensagensFavoritas() {
    List<Mensagem> favoritas = List();
    favoritas.addAll(mensagensBanco);
    favoritas.retainWhere((mensagem) => mensagem.favorita);
    return favoritas;
  }

//  static List<Mensagem> mensagensPorAdmin(Administrador admin) {
//    List<Mensagem> mensagens = List();
//    mensagens.addAll(mensagensBanco);
//    mensagens.retainWhere((mensagem) => mensagem.administrador.id == admin.id);
//    return mensagens;
//  }

  static List<Mensagem> mensagensPorGrupo() {
    List<Mensagem> mensagens = List();

    for(Mensagem m in mensagensBanco) {
      for(Grupo gm in m.gruposInteresse) {
        for (Grupo gu in SistemaUsuario().usuario.gruposInteresse) {
          if (gu.selecionado && gm.nome == gu.nome) {
            print(" >>> ${gm.nome}");
            mensagens.add(m);
            break;
          }
        }
      }
    }

    return mensagens;
  }

//  static List<Noticia> noticiasPorAdmin(Administrador admin) {
//    List<Noticia> noticias = List();
//    noticias.addAll(noticiasBanco);
//    noticias.retainWhere((noticia) => noticia.administrador.id == admin.id);
//    return noticias;
//  }

//  static void _carregarMensagens() {
//
//    _mensagensBanco = List();
//
//    Mensagem m1 = Mensagem();
//    m1.id = 1;
//    m1.administrador = adminsBanco[1];
//    m1.titulo = "Título 1";
//    m1.conteudo = "Conteúdo da mensagem inserida manualmente";
//    m1.lida = true;
//    m1.favorita = true;
//    m1.dataHoraPublicacao = DateTime.now();
//    m1.gruposInteresse.add(gruposBanco[2]);
//    _mensagensBanco.add(m1);
//
//    Mensagem m2 = Mensagem();
//    m2.id = 2;
//    m2.administrador = adminsBanco[1];
//    m2.titulo = "Título 2";
//    m2.conteudo = "Mensagem inserida manualmente";
//    m2.lida = false;
//    m2.favorita = false;
//    m2.dataHoraPublicacao = DateTime.now();
//    m2.gruposInteresse.add(gruposBanco[2]);
//    _mensagensBanco.add(m2);
//
//
//    Mensagem m3;
//    for (int c = 3; c < 5; c++) {
//      m3 = Mensagem();
//      m3.id = c;
//      m3.administrador = adminsBanco[c];
//      m3.titulo = "Título $c";
//      m3.conteudo = "Mensagem inserida manualmente";
//      m3.lida = false;
//      m3.favorita = false;
//      m3.dataHoraPublicacao = DateTime.now();
//      _mensagensBanco.add(m3);
//    }
//  }

  static void _carregarNoticias() {

    _noticiasBanco = List();

    print("Carregando noticias");


//    Noticia n;
//    for (int c = 1; c < 5; c++) {
//      n = Noticia();
//      n.id = c;
//      //n.administrador = adminsBanco[c];
//      n.titulo = "Título $c iu bb ib iub ibib ib ib iub iubiubiub ";
//      n.dataHoraPublicacao = DateTime.now();
//
//      Conteudo c1 = Conteudo();
//      c1.tipo = 1;
//      c1.texto = "AIUHASIUHAihsi Iua iaU D ds dus das du sdbuisabd usab "
//          "dubduibsid sadsd usbdu sa dus dibadusabdui dusad uis dsdiusbdiu dcd";
//      c1.idNoticia = n.id;
//      n.conteudos.add(c1);
//
//      Conteudo c2 = Conteudo();
//      c2.tipo = 2;
//      c2.texto = "imagens/imagemteste.png";
//      c2.idNoticia = n.id;
//      n.conteudos.add(c2);
//
//      Conteudo c3 = Conteudo();
//      c3.tipo = 1;
//      c3.texto = "fdsdsfsdfsd u uihuihiuh uih uih u huh iuh iuhiuh iuh iuh iuh i "
//          "ojojoij j oj oij oijoij oijioj oji iijoijoijij oij iojoi joi j"
//          "osdhfsdhi uhdiuhsiu hfusidhf iusdhuifh  io oih oih oih oih ioh ioh h"
//          " hoh oi hoi hoi ho iho ihoihoihoi hoihoihoi hoih iohoi hoihoihoih oh "
//          "iu hu hiuhiuhiuhi uhiu hiuhiuhiuhiu huihiuhuh iuhiuhiu hiu hiuh iuh "
//          "uh iuhiu hiu hiuh iuhi uhiu huihuihiu uihiu hiuh uihiuhi uhiu hui"
//          " iuhiuh iuh iuh iuh iuhiuhuihiuhuihu ii gyug uguy gyug yug ";
//      c3.idNoticia = n.id;
//      n.conteudos.add(c3);
//      n.conteudos.add(c3);
//      n.conteudos.add(c3);
//
//      Conteudo c4 = Conteudo();
//      c4.tipo = 2;
//      c4.texto = "imagens/imagemteste.png";
//      c4.idNoticia = n.id;
//      n.conteudos.add(c4);
//
//      Conteudo c5 = Conteudo();
//      c5.tipo = 3;
//      c5.texto = "http://www.ifsul.edu.br/";
//      c5.idNoticia = n.id;
//      n.conteudos.add(c5);
//
//      _noticiasBanco.add(n);
//    }
//  }

//  static bool inserirMensagem(Mensagem m) {
//    mensagensBanco.add(m);
//    return true;
//  }
//
//  static bool inserirNoticia(Noticia n) {
//    noticiasBanco.add(n);
//    return true;
//  }
//
//  static void _carregarGrupos() {
//    _gruposBanco = List();

//    _gruposBanco.add(Grupo.nomeado(1,"Docentes"));
//    _gruposBanco.add(Grupo.nomeado(2,"Docentes"));
//
//    _gruposBanco.add(Grupo.nomeado(3,"TADS 1"));
//    _gruposBanco.add(Grupo.nomeado(4,"TADS 2"));
//    _gruposBanco.add(Grupo.nomeado(5,"TADS 3"));
//    _gruposBanco.add(Grupo.nomeado(6,"TADS 4"));
//    _gruposBanco.add(Grupo.nomeado(7,"TADS 5"));
//    _gruposBanco.add(Grupo.nomeado(8,"TADS 6"));
//
//    _gruposBanco.add(Grupo.nomeado(9,"TEC 1"));
//    _gruposBanco.add(Grupo.nomeado(10,"TEC 2"));
//    _gruposBanco.add(Grupo.nomeado(11,"TEC 3"));
//    _gruposBanco.add(Grupo.nomeado(12,"TEC 4"));
//
//    _gruposBanco.add(Grupo.nomeado(13,"TINF 1"));
//    _gruposBanco.add(Grupo.nomeado(14,"TINF 2"));
//    _gruposBanco.add(Grupo.nomeado(15,"TINF 3"));
//    _gruposBanco.add(Grupo.nomeado(16,"TINF 4"));
//
//    _gruposBanco.add(Grupo.nomeado(17,"TAI 1"));
//    _gruposBanco.add(Grupo.nomeado(18,"TAI 2"));
//    _gruposBanco.add(Grupo.nomeado(19,"TAI 3"));
//    _gruposBanco.add(Grupo.nomeado(20,"TAI 4"));
//
//    _gruposBanco.add(Grupo.nomeado(21,"TCA 1v"));
//    _gruposBanco.add(Grupo.nomeado(22,"TCA 2v"));
//    _gruposBanco.add(Grupo.nomeado(23,"TCA 3v"));
//    _gruposBanco.add(Grupo.nomeado(24,"TCA 4v"));
//
//    _gruposBanco.add(Grupo.nomeado(25,"TCA 1m"));
//    _gruposBanco.add(Grupo.nomeado(26,"TCA 2m"));
//    _gruposBanco.add(Grupo.nomeado(27,"TCA 3m"));
//    _gruposBanco.add(Grupo.nomeado(28,"TCA 4m"));


  }

//  static void _carregarAdmins() {
//    _adminsBanco = List();
//    Administrador a;
//    for(int c = 0; c < 10; c++) {
//      a = Administrador();
//      a.id = c;
//      a.nome = "Administrador $c";
//
//      adminsBanco.add(a);
//    }
//  }
}



