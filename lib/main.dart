import 'package:flutter/material.dart';

import 'package:kalahok_app/services/notification_service.dart';
import 'package:kalahok_app/services/server_service.dart';
import 'package:kalahok_app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  await ServerService.initializeServer();

  runApp(const MyApp());
}
