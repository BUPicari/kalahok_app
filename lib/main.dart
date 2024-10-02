import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kalahok_app/services/notification_service.dart';
import 'package:kalahok_app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
