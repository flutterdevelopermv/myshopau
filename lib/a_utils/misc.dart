import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';

void afterDebounce({
  int seconds = 1,
  required Future<void> Function() after,
}) async {
  EasyDebounce.debounce('d', Duration(seconds: seconds), after);
}

//

String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
