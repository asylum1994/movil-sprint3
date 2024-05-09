import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging provider = FirebaseMessaging.instance;

  initNotification() {
    provider.getToken().then((value) => {
          print("===========TOKEN==============="),
          print(value),
        });
  }
}
