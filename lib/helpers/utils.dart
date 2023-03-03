import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Utils {
  static List<Widget> heightBetween(
    List<Widget> children, {
    required double height,
  }) {
    if (children.isEmpty) return <Widget>[];
    if (children.length == 1) return children;

    final list = [children.first, SizedBox(height: height)];
    for (int i = 1; i < children.length - 1; i++) {
      final child = children[i];
      list.add(child);
      list.add(SizedBox(height: height));
    }
    list.add(children.last);

    return list;
  }

  /// Checking internet connection availability
  static Future<bool> get hasInternetConnection async {
    return await InternetConnectionChecker().hasConnection;
  }
}
