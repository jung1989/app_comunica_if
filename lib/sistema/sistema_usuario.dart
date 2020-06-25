import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';
import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/helper/noticia_helper.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SistemaUsuario {
  /// implementação do singleton
  static final SistemaUsuario _instance = SistemaUsuario._interno();

  factory SistemaUsuario() => _instance;

  static SistemaUsuario get instance => _instance;

  SistemaUsuario._interno();

  Usuario _usuario;

  DateTime dataHoraUltimaMensagemArmazenada;
  DateTime dataHoraUltimaNoticiaArmazenada;

  Usuario get usuario => _usuario;

  bool login(Usuario usuario) {
    _usuario = usuario;
  }

  void iniciar() async {
    await atualizarBancoLocal();
    _usuario.gruposInteresse = await GrupoInteresseHelper.lerGrupos();
  }

  /// carregamento dos grupos de interesse do usuário
  Future carregarGrupos() async {
    List<Grupo> gruposRemoto = await _carregarGruposRemoto();
    List<Grupo> gruposLocal = await GrupoInteresseHelper.lerGrupos();

    print("   >>> ${gruposRemoto.length} grupos remotos");

    /// comparação entre os grupos remotos e locais
    for (Grupo grupo in gruposLocal) {
      gruposRemoto.removeWhere((g) => grupo.nome == g.nome);
    }

    /// gravação dos grupos remotos no banco local
    for (Grupo grupo in gruposRemoto) {
      GrupoInteresseHelper.gravarGrupo(grupo);
    }
    print("   >>> ${gruposRemoto.length} novos grupos armazenados localmente");
  }

  /// carregamento dos grupos de interesse inseridos no banco remoto
  Future<List<Grupo>> _carregarGruposRemoto() async {
    List<Grupo> grupos = List();

    /// carrega os grupos de acordo com o perfil do usuário
    /// alunos não acessam grupos de servidores e vice-versa
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("grupos")
        .where("restricao", isEqualTo: usuario.perfil)
        .getDocuments();

    querySnapshot.documents.forEach((grupo) {
      Grupo g = Grupo.fromMap(grupo.data);
      g.id = grupo.documentID;
      g.selecionado = false;
      grupos.add(g);
    });
    return grupos;
  }

  //TODO VERIFICAR TUDO DAQUI PARA BAIXO

  /// grava no SQFLite as mensagem buscadas no Firebase
  Future carregarMensagens() async {
    DateTime dataHora = await MensagemHelper.dataHoraUltimaMensagemArmazenada();
    List<Mensagem> mensagensNovas = await _carregarMensagensRemoto(
        dataHora == null ? 0 : dataHora.millisecondsSinceEpoch);
    print("### Gravando mensagens do Firebase no banco local...");
    for (Mensagem mensagem in mensagensNovas) {
      MensagemHelper.gravarMensagem(mensagem);
    }
    print(
        "   >>> ${mensagensNovas.length} novas mensagens armazenadas localmente");
  }

  /// busca no Firebase todas mensagens com data e hora superior a última mensagem
  /// armazenada no SQFLite
  Future<List<Mensagem>> _carregarMensagensRemoto(int dataHora) async {
    print("### Carregando mensagens do Firebase...");
    List<Mensagem> mensagens = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("mensagens")
        .where("data_hora_publicacao", isGreaterThan: dataHora)
        .getDocuments();
    querySnapshot.documents.forEach((mensagem) {
      Mensagem m = Mensagem.fromMap(mensagem.data);
      m.id = mensagem.documentID;
      mensagens.add(m);
    });
    return mensagens;
  }

  /// carrega todas notícias armazenadas no Firebase
  Future<List<Noticia>> carregarTodasNoticias() async {
    print("### Carregando notícias do Firebase...");
    List<Noticia> noticias = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("noticias")
        .orderBy("data_hora_publicacao", descending: true)
        .getDocuments();
    querySnapshot.documents.forEach((noticia) {
      Noticia n = Noticia.fromMapFirebase(noticia.data);
      n.id = noticia.documentID;
      noticias.add(n);
    });
    return noticias;
  }

  Future atualizarBancoLocal() async {
    await carregarGrupos();
    await carregarMensagens();
  }
}
