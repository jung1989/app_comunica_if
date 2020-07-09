
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GerenciadorNotificacoes {

  GerenciadorNotificacoes._();

  factory GerenciadorNotificacoes() => _instance;

  static final GerenciadorNotificacoes _instance = GerenciadorNotificacoes._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static GerenciadorNotificacoes get instance => _instance;

  bool _initialized = false;


  gravarToken(int perfil) async {

    String fcmToken = await _firebaseMessaging.getToken();

    if(fcmToken != null) {
      if(perfil == Usuario.PERFIL_ALUNO) {
        print("### Inscrito nas notificações como aluno...");
        _firebaseMessaging.subscribeToTopic('Alunos');
        _firebaseMessaging.unsubscribeFromTopic('Servidores');
      }
      else {
        if(perfil == Usuario.PERFIL_SERVIDOR) {
          print("### Inscrito nas notificações como servidor...");
          _firebaseMessaging.subscribeToTopic('Servidores');
          _firebaseMessaging.unsubscribeFromTopic('Alunos');
        }
      }

      await SistemaLogin.instance.gravarToken(fcmToken);
      print("### Token gravado no Firebase...");
    }
  }



  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging
          .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {

          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) {

          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) {

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