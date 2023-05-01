import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'hive.dart';

// FCM Instance
FirebaseMessaging fcm = FirebaseMessaging.instance;

const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
  'vip_vendor', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound("vip_vendor_notification"),
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  // print("Handling a background message: ${message.messageId}");
}

Future<void> fcmMainInit() async {
  //
  NotificationSettings settings = await fcm.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // flutterLocalNotificationsPlugin.initialize(
    //   const InitializationSettings(
    //     android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    //   ),
    //   // onSelectNotification: (payloadURI) async {
    //     // if (payloadURI != null && payloadURI.length > 10) {
    //     // var crm = await crs.chatRoomModelFromChatPersonUID(payloadURI);
    //     // Get.to(() => const ChatScreen());
    //     // }
    //   // },
    // );
  }

  //
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await fcm.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

//

class FCMfunctions {
  //
  static Future<void> fcmSettings() async {
    NotificationSettings settings = await fcm.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // flutterLocalNotificationsPlugin.initialize(
      //   const InitializationSettings(
      //     android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      //   ),
      //   // onSelectNotification: (payloadURI) async {
      //     // if (payloadURI != null && payloadURI.length > 10) {
      //     // var crm = await crs.chatRoomModelFromChatPersonUID(payloadURI);
      //     // Get.to(() => const ChatScreen());
      //     // }
      //   // },
      // );
    }
  }

  //
  static Future<String?> checkFCMtoken() async {
    var tokenB = HiveApi.box().get(HiveApi.fcmToken);

    if (tokenB == null || tokenB.runtimeType != String) {
      var fcmToken = await fcm.getToken();

      if (fcmToken != null) {
        await HiveApi.box().put(HiveApi.fcmToken, fcmToken);
        return fcmToken;
      }
    }
    return null;
  }

  //
  //
  static Future<void> playSound() async {
    // final audioPlayer = AudioPlayer();
    // await audioPlayer.play(AssetSource("vip_vendor_notification.wav"),
    //     mode: PlayerMode.lowLatency);
  }
  //

  //

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      var msgData = msg.data;
    });
  }

  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    void handleMessage(RemoteMessage message) async {
      var msgData = message.data;
    }

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
