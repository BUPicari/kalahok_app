import 'package:flutter/material.dart';

class AppColor {
  static MaterialColor primary = Colors.indigo;
  static MaterialColor secondary = Colors.blueGrey;
  static Color subPrimary = Colors.white;
  static Color subSecondary = Colors.black;
  static Color subTertiary = Colors.black12;
  static Color success = const Color(0xffd4edda);
  static Color darkSuccess = Colors.green;
  static MaterialColor warning = Colors.orange;
  static Color error = const Color(0xfff8d7da);
  static Color darkError = Colors.red;
  static MaterialColor neutral = Colors.grey;
  static List<MaterialColor> linearGradient = [Colors.blueGrey, Colors.indigo];
}

class ApiConfig {
  // static String baseUrl = 'https://pcari.mab.com.ph:8001';
  static String baseUrl = 'http://10.11.79.224:3001';
}

class AppConfig {
  static String name = 'Kalahok';
  static String logo = 'assets/images/kalahok-logo.png';
}
