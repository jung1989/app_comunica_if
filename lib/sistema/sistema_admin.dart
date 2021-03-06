import 'package:app_comunica_if/model/dica.dart';
import 'package:app_comunica_if/model/grupo.dart';
import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/model/noticia.dart';
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/importar_alunos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SistemaAdmin {
  /// implementação do singleton
  static final SistemaAdmin _instance = SistemaAdmin._interno();

  factory SistemaAdmin() => _instance;

  static SistemaAdmin get instance => _instance;

  SistemaAdmin._interno();

  /// declaração das variáveis da classe
  static Usuario _administrador;

  /// declaração dos métodos
  void login(Usuario administrador) {
    _administrador = administrador;
  }

  void logout() {
    _administrador = null;
  }

  Usuario get administrador => _administrador;

  /// gravação de mensagens no Firebase
  Future gravarMensagem(Mensagem mensagem) async {
    await Firestore.instance
        .collection("mensagens")
        .document()
        .setData(mensagem.toMapFireBase());
  }

  /// gravação de usuários no Firebase
  Future<bool> gravarUsuario(Usuario usuario) async {
    bool verifica = await verificarMatriculaJaExistente(usuario.matricula);
    if (verifica) {
      return false;
    } else {
      //await Firestore.instance.collection("perfis").add(usuario.toMap());
      await Firestore.instance
          .collection("perfis")
          .document(usuario.matricula)
          .setData(usuario.toMap());
      return true;
    }
  }

  /// gravação de varios usuários no Firebase
  Future<Map<String, int>> gravarUsuariosDeArquivo() async {
    List lista = await abrirArquivo();
    if(lista.length < 50) {
      return await gravarVariosUsuarios(lista);
    }
    else {
      return {'limite': 50};
    }
  }

  /// TODO LIMPAR ESSA FUNCAO
  /// gravação de varios usuários no Firebase
  Future<Map<String, int>> gravarVariosUsuarios(List<dynamic> usuarios) async {
    int contatosArmazenados = 0;
    int contatosIgnorados = 0;

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("perfis").getDocuments();

    if(usuarios != null) {
      for (Map uMap in usuarios) {
        Usuario u = Usuario();
        u.nome = uMap['nome'];
        u.matricula = uMap['matricula'];
        u.ativo = false;
        u.ultimoAcesso = DateTime.fromMillisecondsSinceEpoch(0);
        u.perfil = Usuario.PERFIL_ALUNO;
        bool verifica = await verificarMatriculaJaExistenteLocal(querySnapshot, u.matricula);
        if (verifica) {
          contatosIgnorados++;
        } else {
          contatosArmazenados++;
          await Firestore.instance
              .collection("perfis")
              .document(uMap['matricula'])
              .setData(u.toMap());
        }
      }
    }

    /// TODO ESSE TRECHO É SÓ PARA TESTES
//    if (usuarios != null) {
//      for (int c = 0; c < 11; c++) {
//        Usuario u = Usuario();
//        u.nome = usuarios[c]['nome'];
//        u.matricula = usuarios[c]['matricula'];
//        u.ativo = false;
//        u.ultimoAcesso = DateTime.fromMillisecondsSinceEpoch(0);
//        u.perfil = Usuario.PERFIL_ALUNO;
//        bool verifica = await verificarMatriculaJaExistenteLocal(
//            querySnapshot, u.matricula);
//        if (verifica) {
//          contatosIgnorados++;
//        } else {
//          contatosArmazenados++;
//          await Firestore.instance
//              .collection("perfis")
//              .document(usuarios[c]['matricula'])
//              .setData(u.toMap());
//        }
//      }
//    }

    return {'aceitos': contatosArmazenados, 'recusados': contatosIgnorados};
    //print("### $contatosArmazenados contatos armazenados | "
    //      "$contatosIgnorados contatos ignorados");
  }

  /// gravação de GRUPOS no Firebase
  Future<bool> gravarGrupo(String nome, int restricao) async {
    bool verifica = await verificarGrupoJaExistente(nome);
    if (verifica) {
      return false;
    } else {
      Map<String, dynamic> grupo = {"nome": nome, "restricao": restricao};
      await Firestore.instance.collection("grupos").add(grupo);
      return true;
    }
  }

  Future<bool> verificarGrupoJaExistente(String nome) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("grupos")
        .where("nome", isEqualTo: nome)
        .getDocuments();
    if (querySnapshot.documents.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verificarMatriculaJaExistente(String matricula) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("perfis")
        .where("matricula", isEqualTo: matricula)
        .getDocuments();
    if (querySnapshot.documents.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verificarMatriculaJaExistenteLocal(
      QuerySnapshot querySnapshot, String matricula) async {
    bool jaExiste = false;

    querySnapshot.documents.forEach((perfil) {
      if (Usuario.fromMap(perfil.data).matricula == matricula) {
        jaExiste = true;
        return;
      }
    });

    return jaExiste;
  }

  /// gravação de DICAS no Firebase
  Future<bool> gravarDica(Dica dica) async {
    if (dica.id == null) {
      /// inserir uma dica nova
      /// o nome da imagem recebe o tempo atual em milisegundos para garantir um nome único
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();

      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child("imagens_dicas")
          .child(nomeImagem)
          .putFile(dica.imagem);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;

      dica.nomeImagem = nomeImagem;

      /// o campo caminho_imagem da dica recebe o link da imagem no Firestorage
      dica.caminhoImagem = await taskSnapshot.ref.getDownloadURL();

      await Firestore.instance.collection("dicas").add(dica.toMap());

      print(" ### Dica inserida no Firebase...");
    } else {
      /// atualizar uma dica
      if (dica.imagem != null) {
        /// carregando nova imagem
        StorageUploadTask task = FirebaseStorage.instance
            .ref()
            .child("imagens_dicas")
            .child(dica.nomeImagem)
            .putFile(dica.imagem);

        StorageTaskSnapshot taskSnapshot = await task.onComplete;

        /// o campo caminho_imagem da dica recebe o link da imagem no Firestorage
        dica.caminhoImagem = await taskSnapshot.ref.getDownloadURL();
      }

      await Firestore.instance
          .collection("dicas")
          .document(dica.id)
          .updateData(dica.toMap());

      print(" ### Dica atualizada no Firebase... ${dica.toMap()}");
    }
    return true;
  }

  /// carregamento de todas as dicas armazenadas no Firebase
  Future<List<Dica>> carregarDicas() async {
    List<Dica> dicas = List();
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("dicas").getDocuments();
    querySnapshot.documents.forEach((dica) {
      Dica d = Dica.fromMap(dica.data);
      d.id = dica.documentID;
      dicas.add(d);
    });
    return dicas;
  }

  /// carregamento de todos os usuarios armazenados no Firebase
  Future<List<Usuario>> carregarUsuarios() async {
    print("### Carregando todos usuários do sistema...");
    List<Usuario> usuarios = List();
    QuerySnapshot querySnapshot =
    await Firestore.instance.collection("perfis")
        .orderBy("nome", descending: false)
        .getDocuments();
    querySnapshot.documents.forEach((usuario) {
      Usuario u = Usuario.fromMap(usuario.data);
      u.id = usuario.documentID;
      usuarios.add(u);
    });
    return usuarios;
  }

  /// gravação de notícias no Firebase
  Future gravarNoticia(Noticia noticia) async {
    /// gravação da notícia
    var docRef = await Firestore.instance
        .collection("noticias")
        .add(noticia.toMapFirebase());
    String idDocumento = docRef.documentID;

    /// gravação dos conteúdos da notícia
    for (Conteudo conteudo in noticia.conteudos) {
      /// caso o conteúdo seja uma imagem, a mesma sera armazenada no Firestorage
      /// o campo texto do conteúdo recebe o link da imagem no Firestorage
      if (conteudo.tipo == Conteudo.TIPO_IMAGEM) {
        StorageUploadTask task = FirebaseStorage.instance
            .ref()
            .child("imagens_noticias")
            .child(
                //o nome da imagem recebe o tempo atual em milisegundos para garantir um nome único
                DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(conteudo.imagem);

        StorageTaskSnapshot taskSnapshot = await task.onComplete;

        /// o campo texto do conteúdo recebe o link da imagem no Firestorage
        conteudo.texto = await taskSnapshot.ref.getDownloadURL();
      }
      await Firestore.instance
          .collection("noticias")
          .document(idDocumento)
          .collection("conteudos")
          .add(conteudo.toMapFireBase());
    }
  }

  /// carregamento de notícias do administrador logado no sistema
  Future<List<Noticia>> carregarNoticiasPorAdministrador() async {
    List<Noticia> noticias = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("noticias")
        .where("nome_administrador", isEqualTo: _administrador.nome)
        .orderBy("data_hora_publicacao", descending: true)
        .getDocuments();
    querySnapshot.documents.forEach((noticia) {
      Noticia n = Noticia.fromMapFirebase(noticia.data);
      n.id = noticia.documentID;
      noticias.add(n);
    });
    return noticias;
  }

  /// carregamento de todas as notícias armazenadas no Firebase
  Future<List<Noticia>> carregarNoticias() async {
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

  /// carregamento dos conteúdos de uma notícia específica
  Future<List<Conteudo>> carregarConteudos(Noticia noticia) async {
    List<Conteudo> conteudos = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("noticias")
        .document(noticia.id)
        .collection("conteudos")
        .orderBy("ordem", descending: false)
        .getDocuments();
    querySnapshot.documents.forEach((conteudo) async {
      Conteudo c = Conteudo.fromMapFirebase(conteudo.data);
      c.id = conteudo.documentID;
      conteudos.add(c);
    });
    return conteudos;
  }

  /// carregamento de mensagens do administrador logado no sistema
  Future<List<Mensagem>> carregarMensagensPorAdministrador() async {
    List<Mensagem> mensagens = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("mensagens")
        .where("nome_administrador", isEqualTo: _administrador.nome)
        .orderBy("data_hora_publicacao", descending: true)
        .getDocuments();
    querySnapshot.documents.forEach((mensagem) {
      Mensagem m = Mensagem.fromMap(mensagem.data);
      m.id = mensagem.documentID;
      mensagens.add(m);
    });
    return mensagens;
  }

  /// carregamento de todas as mensagens Armazenadas no Firebase
  Future<List<Mensagem>> carregarMensagens() async {
    List<Mensagem> mensagens = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("mensagens")
        .orderBy("data_hora_publicacao", descending: true)
        .getDocuments();
    querySnapshot.documents.forEach((mensagem) {
      Mensagem m = Mensagem.fromMap(mensagem.data);
      m.id = mensagem.documentID;
      mensagens.add(m);
    });
    return mensagens;
  }

  /// carregamento dos grupos armazenados no Firebase
  Future<List<Grupo>> carregarGrupos() async {
    List<Grupo> grupos = List();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("grupos")
        .orderBy("restricao", descending: false)
        .orderBy("nome", descending: false)
        .getDocuments();
    querySnapshot.documents.forEach((grupo) {
      Grupo g = Grupo.fromMap(grupo.data);
      g.id = grupo.documentID;
      g.restricao = grupo.data['restricao'];
      grupos.add(g);
    });
    return grupos;
  }
}
