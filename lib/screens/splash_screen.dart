import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:devopia_overload_oblivion/screens/student_homepage.dart';
import 'package:flutter/material.dart';

import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  bool isSignedIn;
  SplashScreen({
    super.key,
    required this.isSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSplashScreen(
        splash: Column(
          children: [
            Center(
              child: LottieBuilder.asset("assets/Lottie/Animation - 2.json"),
            )
          ],
        ),
        nextScreen: isSignedIn ?const  StudentHomepage() : const UserTypeSelectionPage(),
        splashIconSize: 300,
        backgroundColor: Color.fromRGBO(99, 151, 255, 1),
      ),
    );
  }
}
