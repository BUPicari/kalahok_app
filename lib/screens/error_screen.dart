import 'package:flutter/material.dart';

import 'package:kalahok_app/helpers/functions.dart';

/// CHECKED
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({ Key? key, required this.error }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    /// todo: fix this ui later
    return Center(child: Text(error));
  }
}
