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
  static String baseUrl = "https://pcari.mab.com.ph:8001"; /// server
  // static String baseUrl = "http://192.168.1.19:3001"; /// local
  static String apiKey = "vTZiBkM3GZniy45jf14V_Mpdvm43enyIzW61NAuzZTc";
}

class AppConfig {
  static String name = "BosesKo";
  static String logo = "assets/images/bosesko-logo.png";
  static String logoPreview = "assets/images/bosesko-removebg-preview.png";
}
