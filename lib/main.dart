import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/firebase_options.dart';
import 'package:devopia_overload_oblivion/providers/student_provider.dart';
import 'package:devopia_overload_oblivion/providers/teacher_provider.dart';
import 'package:devopia_overload_oblivion/screens/short_answer_screen.dart';

import 'package:devopia_overload_oblivion/screens/splash_screen.dart';
import 'package:devopia_overload_oblivion/screens/student_homepage.dart';
import 'package:devopia_overload_oblivion/screens/teacher_homepage.dart';
import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>TeacherProvider()),
        ChangeNotifierProvider(create: (_)=>StudentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student-Teacher Portal',
        theme: ThemeData(
          fontFamily: 'Inter',
          primarySwatch: Colors.blue,
        ),
        home:  const SplashScreen(),
      ),
    );
  }
}
