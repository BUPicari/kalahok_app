import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:kalahok_app/app.dart';
import 'package:kalahok_app/helpers/database.dart';
import 'package:workmanager/workmanager.dart';

const syncResponses = "syncResponses";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case syncResponses:
        print("*** Workmanager: syncResponses ***");
        DB.submitLocalResponsesToApi();
        DB.isSentSurveyFromFalseToTrue();
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    // isInDebugMode: true,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    syncResponses,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'bosesko_channel',
          channelName: 'BosesKo Notifications',
          channelDescription: 'Notification channel for BosesKo'
      ),
    ],
    debug: true,
  );
  runApp(const MyApp());
}
