
import 'package:app_comunica_if/sistema/sistema_usuario.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class GerenciadorNotificacoes {

  GerenciadorNotificacoes._();

  factory GerenciadorNotificacoes() => _instance;

  static final GerenciadorNotificacoes _instance = GerenciadorNotificacoes._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging
          .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          SistemaUsuario().carregarMensagens();
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) {
          SistemaUsuario().carregarMensagens();
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) {
          SistemaUsuario().carregarMensagens();
          print('on launch $message');
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

//  void enviarNotificacao(String titulo, String conteudo) {
//    String DATA =
//        "{\"notification\": "
//        "{\"body\": \"$conteudo\","
//        "\"title\": \"$titulo\"}, "
//        "\"priority\": \"high\", "
//        "\"data\": {\"click_action\": "
//        "\"FLUTTER_NOTIFICATION_CLICK\", "
//        "\"id\": \"1\", \"status\": \"done\"}, \"to\": \"<FCM TOKEN>\"}";
//
//    post("https://fcm.googleapis.com/fcm/send",
//        body: DATA,
//        headers: {"Content-Type": "application/json", "Authorization": "key=<FCM SERVER KEY>"});
//  }
}