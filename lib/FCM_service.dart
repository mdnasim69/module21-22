import 'package:firebase_messaging/firebase_messaging.dart';
class FCM_service {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initalize()async{
    await firebaseMessaging.requestPermission(
      sound: true,
      alert: true,
    );
    FirebaseMessaging.onMessage.listen(cloudMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(cloudMessage);
    FirebaseMessaging.onBackgroundMessage(BackgroundCloudMessage);
  }
  void cloudMessage(RemoteMessage message){
    print(message.data);
    print(message.sentTime);
    print(message.notification?.title);
    print(message.notification?.body);
    //TODO : do something
  }
}
Future<void> BackgroundCloudMessage(RemoteMessage message) async{
  //TODO : do something
}