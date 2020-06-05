

class Grupo {

  Grupo() {
    this.selecionado = false;
  }

  Grupo.nomeado(String nome) {
    this.nome = nome;
    this.selecionado = false;
  }
  String nome;
  bool selecionado;

}