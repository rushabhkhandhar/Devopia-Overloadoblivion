import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/screens/chat_help2.dart';

class ChatLoadScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  const ChatLoadScreen({super.key,required this.questions});

  @override
  State<ChatLoadScreen> createState() => _ChatLoadScreenState();
}

class _ChatLoadScreenState extends State<ChatLoadScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds and then navigate to ChatHelp2 screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  chatHelp2(questions: questions,)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can customize your splash screen UI here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Help'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.chat,
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Chat Help',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Add circular progress indicator
          ],
        ),
      ),
    );
  }
}
