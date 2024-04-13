import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devopia_overload_oblivion/Helper/helper_function.dart';
import 'package:devopia_overload_oblivion/screens/student_homepage.dart';
import 'package:devopia_overload_oblivion/screens/teacher_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  
   SplashScreen({super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;
  String userType="";
  void initState() {
    super.initState();
    // getUserLoggedInStatus();
    getUserDetails();
  }
  void getUserLoggedInStatus() async {
    
    HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
          userType= HelperFunction.userType;
          print(userType);
          print(isSignedIn);
        });
      }
    });
  }

  getUserDetails()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if(auth.currentUser != null){
      User currentUser  = auth.currentUser!;
      print(currentUser.uid);
      await firestore.collection('students').doc(currentUser.uid).get().then((value){
        if(value.exists){
          setState(() {
            userType = "Student";
            isSignedIn = true;
          });
        }
        else{
          setState(() {
            userType = "teacher";
            isSignedIn = true;
          });
        }
      });
    }
    else{
      setState(() {
        userType = "";
        isSignedIn = false;
      });
    }
    
  }

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
        nextScreen: isSignedIn ? (userType == "Student" ? StudentHomepage() : TeacherHomepage()) : const UserTypeSelectionPage(),
        splashIconSize: 300,
        backgroundColor: Color.fromRGBO(99, 151, 255, 1),
      ),
    );
  }
}
