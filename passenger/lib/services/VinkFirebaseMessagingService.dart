import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:passenger/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class VinkFirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  VinkFirebaseMessagingService.init(String deviceToken) {
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      subscribeToTopic(deviceToken);
    }
  }

  VinkFirebaseMessagingService() {
    print("onDefault Constructor FCM Service");
  }

  getFirebaseMessagingObject() async {
    return _fcm;
  }

  Future<String> getUserToken() async {
    if (Platform.isIOS) checkforIosPermission();
    return await _fcm.getToken().then((token) => token);
  }

  void checkforIosPermission() async {
    await _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  subscribeToTopic(String topic) async {
    _fcm.subscribeToTopic(topic);
  }

  buildAndReturnFcmMessageBody(
      Map notificationBody, Map notificationDataBody, String reciever) async {
    print("onBuildAndReturnFcmMessageBody. Receiver of message: $reciever");

    notificationDataBody['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
    var messageBody = <String, dynamic>{
      'notification': notificationBody,
      'priority': 'high',
      'data': notificationDataBody,
      'to': '/topics/${reciever.toString()}',
    };
    return messageBody;
  }

  //send fcm message
  Future<Map<String, dynamic>> sendFcmMessage(Map body) async {
    print("onSendFcmMessage");
    var mapInJsonString = json.encode(body);
    String serverToken = Constants.FCM_SERVER_TOKEN;
    final http.Response response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: mapInJsonString,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode('Failed to send data to Server. Error');
    }
  }

  void onDisposecancelIOSSubscription() async {
    if (iosSubscription != null) iosSubscription.cancel();
  }
}
