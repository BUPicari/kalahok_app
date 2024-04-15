import 'package:flutter/material.dart';

import 'package:kalahok_app/services/notification_service.dart';
import 'package:kalahok_app/app.dart';

/// CHECKED
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  runApp(const MyApp());
}
