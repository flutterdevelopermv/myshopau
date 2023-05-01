import 'package:hive_flutter/adapters.dart';

class HiveApi {
  static const apiBox = "apiBox";

  //
  static const fcmToken = "fcmToken";

  //
  static Box box() {
    return Hive.box(HiveApi.apiBox);
  }

  //
  //
 static Future<void> openBoxes() async {
    await Hive.openBox(HiveApi.apiBox);
  }
}

//




