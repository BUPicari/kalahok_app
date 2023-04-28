import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kalahok_app/screens/category_screen.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:workmanager/workmanager.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.name,
      theme: ThemeData(
        primarySwatch: AppColor.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(AppConfig.logo),
        splashIconSize: double.infinity,
        backgroundColor: AppColor.primary,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const CategoryScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('App initState');
    Workmanager().registerPeriodicTask(
      "taskOne",
      "sqlToApi",
      frequency: const Duration(hours: 1),
      // frequency: const Duration(seconds: 9000),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
