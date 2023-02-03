import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // fix this ui later
    return Center(child: Text(error));
  }
}
