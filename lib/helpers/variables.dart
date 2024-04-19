import 'package:flutter/material.dart';

/// CHECKED
class AppColor {
  static Color splash = Colors.blue.shade600;
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
  static Color? bgNeutral = Colors.grey[300];
  static List<MaterialColor> linearGradient = [Colors.blueGrey, Colors.indigo];
}

class ApiConfig {
  /// SERVER URL
  static String baseUrl = "https://chedlakas.mab.com.ph:8001";
  /// VISUALIZATION URL
  static String visualizationUrl = "https://chedlakas.mab.com.ph:8004/admin";
  /// LOCAL URL
  // static String baseUrl = "http://10.10.14.80:3001";
  /// API KEY
  static String apiKey = "vTZiBkM3GZniy45jf14V_Mpdvm43enyIzW61NAuzZTc";
}

class AppConfig {
  static String name = "BosesKo";
  static String logo = "assets/images/bosesko-logo.png";
  static String headerLogo = "assets/images/bosesko-header-logo.png";
  static String demoVideo = "assets/videos/demo.mp4";
}
