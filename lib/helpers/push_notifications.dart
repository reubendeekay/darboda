import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void registerNotification() {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.requestPermission();

  FirebaseMessaging.onBackgroundMessage(
    (message) async =>
        message.notification!.title!.contains('New Message from Darboda')
            ? await AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 2,
                    channelKey: 'chat',
                    title: message.notification!.title,
                    category: NotificationCategory.Message,
                    notificationLayout: NotificationLayout.Messaging,
                    largeIcon: message.data['icon'],
                    roundedLargeIcon: true,
                    body: message.notification!.body),
              )
            : await AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: 1,
                    channelKey: 'basic_channel',
                    title: message.notification!.title,
                    body: message.notification!.body),
              ),
  );
  FirebaseMessaging.onMessage.listen(
    (message) async {
      message.notification!.title!.contains('New Message from Darboda')
          ? await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 2,
                  channelKey: 'chat',
                  title: message.notification!.title,
                  category: NotificationCategory.Message,
                  notificationLayout: NotificationLayout.Messaging,
                  largeIcon: message.data['icon'],
                  roundedLargeIcon: true,
                  body: message.notification!.body),
            )
          : await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: 'basic_channel',
                  title: message.notification!.title,
                  body: message.notification!.body),
            );
    },
  );

  firebaseMessaging.getToken().then((token) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'pushToken': token});
  }).catchError((err) {});
}
  // firebaseMessaging.(onMessage: (Map<String, dynamic> message) {
  //   print('onMessage: $message');
  //   Platform.isAndroid
  //       ? showNotification(message['notification'])
  //       : showNotification(message['aps']['alert']);
  //   return;
  // }, onResume: (Map<String, dynamic> message) {
  //   print('onResume: $message');
  //   return;
  // }, onLaunch: (Map<String, dynamic> message) {
  //   print('onLaunch: $message');
  //   return;
  // });

// void showNotification(message) async {
//   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//     Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
//     'Flutter chat demo',
//     'your channel description',
//     playSound: true,
//     enableVibration: true,
//     importance: Importance.Max,
//     priority: Priority.High,
//   );
//   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//   var platformChannelSpecifics =
//   new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
//       payload: json.encode(message));
// }