import 'package:flutter/material.dart';

class GlobalVariables {
  static const Gradient primaryGradient = LinearGradient(
      colors: [Color.fromRGBO(99, 151, 255, 1), Color.fromRGBO(31, 68, 255, 1)],
      stops: [0.1, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static const fontsize = 33;

  static String Url =
      'https://ccf9-2402-3a80-4194-875a-bdd8-8ed2-5f86-adbb.ngrok-free.app';
}
