import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshopau/a_utils/supa.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'myapp.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//
AndroidNotificationChannel androidNotificationChannel =
    const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title

  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 await Supa.initialize();
  setPathUrlStrategy();
  // await openHiveBoxes();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

// Future<void> fcmMain() async {
//   await FCMfunctions.fcmSettings();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(androidNotificationChannel);
//   FirebaseMessaging.onBackgroundMessage(FCMfunctions.backgroundMsgHandler);

//   await fcm.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }

// Future<void> openHiveBoxes() async {
//   await Hive.initFlutter();

//   await Hive.openBox(boxNames.userBox);
//   await Hive.openBox(boxNames.services);
// }
