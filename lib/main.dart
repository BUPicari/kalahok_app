import 'package:flutter/material.dart';
import 'package:kalahok_app/app.dart';
import 'package:kalahok_app/helpers/database.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print("Task executing :$taskName");
    if (taskName == 'sqlToApi') {
      DB.submitLocalResponsesToApi();
      DB.isSentSurveyFromFalseToTrue();
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}
