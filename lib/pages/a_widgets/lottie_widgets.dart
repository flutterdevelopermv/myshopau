import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Lotties {
  static const prefix = "assets/lotties/";
  static Widget login() {
    return Lottie.asset("${prefix}94113-login.json", repeat: true);
  }
}
