import 'package:app_comunica_if/model/administrador.dart';
import 'package:app_comunica_if/testes/banco_ficticio.dart';

class SistemaAdmin {

  static Administrador _administrador;

  static SistemaAdmin _instance;

  factory SistemaAdmin() {
    _instance ??= SistemaAdmin._internalConstructor();
    return _instance;
  }

  SistemaAdmin._internalConstructor();

  bool login(String email, String senha) {
    _administrador = Administrador();
    _administrador = BancoFiciticio.adminsBanco[1];
  }

  Administrador get administrador => _administrador;


}
