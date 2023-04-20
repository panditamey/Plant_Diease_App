import 'package:flutter/material.dart';
import 'package:mpl/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'demo',
      theme: ThemeData(brightness: Brightness.light),
      home: AnimatedSplashScreen(
        splash: Lottie.asset('assets/plant.json'),
        backgroundColor: HexColor("#bbff99"),
        nextScreen: const Home(),
        splashIconSize: 250,
        duration: 2000,
        centered: true,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.leftToRightWithFade,
        animationDuration: const Duration(seconds: 1),
      ),
    );
  }
}
