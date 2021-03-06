
import 'package:app_comunica_if/model/usuario.dart';
import 'package:app_comunica_if/sistema/sistema_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        else {
          if(perfil == Usuario.PERFIL_ADMINISTRADOR) {
            print("### Inscrito nas notificações como servidor...");
            _firebaseMessaging.subscribeToTopic('Servidores');
            _firebaseMessaging.subscribeToTopic('Alunos');
          }
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
          return;
        },
        onResume: (Map<String, dynamic> message) {

          print('on resume $message');
          return;
        },
        onLaunch: (Map<String, dynamic> message) {
          print('on launch $message');
          return;
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  /// toas para testes
  void toast(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}