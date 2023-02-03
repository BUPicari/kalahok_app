import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kalahok_app/screens/home_screen.dart';
import 'package:kalahok_app/configs/app_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.name,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(AppConfig.logo),
        splashIconSize: double.infinity,
        backgroundColor: Colors.indigo,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
