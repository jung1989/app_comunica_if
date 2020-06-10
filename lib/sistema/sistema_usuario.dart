import 'package:app_comunica_if/helper/grupo_interesse_helper.dart';
import 'package:app_comunica_if/helper/mensagem_helper.dart';
import 'package:app_comunica_if/helper/noticia_helper.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';

class SistemaUsuario {
  Usuario _usuario = Usuario();

  MensagemHelper banco = MensagemHelper();

  DateTime dataHoraUltimaMensagemArmazenada;
  DateTime dataHoraUltimaNoticiaArmazenada;

  static final SistemaUsuario _instance = SistemaUsuario.interno();

  factory SistemaUsuario() => _instance;

  SistemaUsuario.interno() {
    //TODO CONSTRUIR COM DADOS DO FIREBASE
    _usuario.nome = "Usuário teste";
  }

  Usuario get usuario => _usuario;

  void iniciar() async {
    atualizarBancoLocal().then(
        (valor) async {
          _usuario.gruposInteresse = await GrupoInteresseHelper.lerGrupos();
        }
    );
  }

  Future carregarMensagens() async {
    //TODO CARREGAR MENSAGENS POSTERIORES A ÚLTIMA ARMAZENADA

    await MensagemHelper.lerMensagens().then((valor) {
      if (valor.length == 0) {
        List<Mensagem> mensagensNovas = BancoFiciticio.mensagensBanco;
        for (Mensagem m in mensagensNovas) {
          MensagemHelper.gravarMensagem(m);
        }
        print("### ${mensagensNovas.length} mensagens carregadas do banco ficiticio para o banco local");
      }
    });
  }

  Future carregarNoticias() async {
    //TODO CARREGAR NOTICIAS POSTERIORES A ÚLTIMA ARMAZENADA

    await NoticiaHelper.lerNoticias().then((valor) {
      if (valor.length == 0) {
        List<Noticia> noticiasNovas = BancoFiciticio.noticiasBanco;
        for (Noticia n in noticiasNovas) {
          NoticiaHelper.gravarNoticia(n);
        }
        print("### ${noticiasNovas.length} notícias carregadas do banco ficiticio para o banco local");
      }
    });
  }

  Future carregarGrupos() async {
    //TODO CARREGAR NOTICIAS POSTERIORES A ÚLTIMA ARMAZENADA

    await GrupoInteresseHelper.lerGrupos().then((valor) {
      if (valor.length == 0) {
        List<Grupo> gruposNovos = BancoFiciticio.gruposBanco;
        for (Grupo g in gruposNovos) {
          GrupoInteresseHelper.gravarGrupo(g);
        }
        print("### ${gruposNovos.length} grupos carregados do banco ficiticio para o banco local");
      }
    });
  }

  Future atualizarBancoLocal() async {
    await carregarGrupos();
    await carregarMensagens();
    await carregarNoticias();
  }
}
