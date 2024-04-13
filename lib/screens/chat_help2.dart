import 'dart:convert';
import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:devopia_overload_oblivion/screens/student_homepage.dart';
import 'secrets.dart';

class chatHelp2 extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  const chatHelp2({super.key, required this.questions});

  @override
  State<chatHelp2> createState() => _chatHelp2State();
}

class _chatHelp2State extends State<chatHelp2> {
  ChatUser myself = ChatUser(id: '1', firstName: 'Shlok');
  ChatUser bot = ChatUser(id: '2', firstName: 'Chanakya');

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final ourUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$openAPIKey';
  final header = {"Content-Type": "application/json"};

  getdata(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);

    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now());
        allMessages.insert(0, m1);
        setState(() {});
      } else {
        print("error occured");
      }
    }).catchError((e) {});

    typing.remove(bot);
  }

  giveTemplate() async {
    await http
        .post(Uri.parse(ourUrl),
            headers: header,
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {
                      "text":
                          "Give me the resources for the questions that I was weak at in the last test the data is ${questions.toString()} analyze and determine where I need to improve provide links to resources"
                    }
                  ]
                }
              ]
            }))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now());
        allMessages.insert(0, m1);
        setState(() {});
      } else {
        print("error occured");
      }
    }).catchError((e) {});
  }

  @override
  void initState() {
    super.initState();
    giveTemplate();

    // Add template prompt as the first question
    // ChatMessage templatePrompt = ChatMessage(
    //   text: "How can I assist you today?",
    //   user: bot,
    //   createdAt: DateTime.now(),
    // );
    // allMessages.add(templatePrompt);
    // List<ChatMessage> prompts = [
    //   ChatMessage(
    //     text: "Suggest resources for the topic that I will ask",
    //     user: myself, // Prompt from user
    //     createdAt: DateTime.now(),
    //   ),
    //   // ChatMessage(
    //   //   text: "Explain the concept of photosynthesis.",
    //   //   user: myself, // Prompt from user
    //   //   createdAt: DateTime.now(),
    //   // ),
    //   // Add more prompts as needed
    // ];

    // allMessages.addAll(prompts);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chanakya ChatHelp'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StudentHomepage()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          DashChat(
            typingUsers: typing,
            currentUser: myself,
            onSend: (ChatMessage m) {
              getdata(m);
            },
            messages: allMessages,
          ),
        ],
      ),
    );
  }
}
