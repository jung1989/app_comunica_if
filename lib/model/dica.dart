
import 'dart:io';

class Dica {

  String id;
  String texto;
  String caminhoImagem;
  String nomeImagem;
  File imagem;
  bool ativo;

  Dica();

  Dica.fromMap(Map map) {
    texto = map['texto'];
    caminhoImagem = map['caminho_imagem'];
    nomeImagem = map['nome_imagem'];
    ativo = map['ativo'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'texto': texto,
      'caminho_imagem': caminhoImagem,
      'ativo' : ativo,
      'nome_imagem' : nomeImagem
    };
    return map;
  }

}