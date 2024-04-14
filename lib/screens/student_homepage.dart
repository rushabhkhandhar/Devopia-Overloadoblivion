import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devopia_overload_oblivion/Helper/helper_function.dart';
import 'package:devopia_overload_oblivion/global/global_var.dart';
import 'package:devopia_overload_oblivion/models/student_model.dart';
import 'package:devopia_overload_oblivion/providers/student_provider.dart';
import 'package:devopia_overload_oblivion/resources/auth_methods.dart';
import 'package:devopia_overload_oblivion/screens/adaptive_learning.dart';
import 'package:devopia_overload_oblivion/screens/assignments.dart';
import 'package:devopia_overload_oblivion/screens/results.dart';
import 'package:devopia_overload_oblivion/screens/short_answer_screen.dart';
import 'package:devopia_overload_oblivion/screens/student_home2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:devopia_overload_oblivion/resources/database.dart';
import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  Stream? quizStream;
  bool isCreateMode = true;
  AuthMethods auth = AuthMethods();
  FirebaseAuth firebaseauth = FirebaseAuth.instance;
  bool isLoading = false;
  DatabaseService databaseService = new DatabaseService();
  Map<String, dynamic> easyQuestions = {};
  Map<String, dynamic> mediumQuestions = {};
  Map<String, dynamic> hardQuestions = {};
  final List<ChartData> chartData = [
    ChartData('Monday', 30),
    ChartData(
      'Tuesday',
      70,
    ),
    ChartData(
      'Wednesday',
      90,
    ),
    ChartData(
      'Thursday',
      85,
    ),
  ];
  final List<ChartData> chartData2 = [
    ChartData('Study-Time', 100),
    ChartData(
      'Break-Time',
      50,
    ),
    ChartData(
      'Absents',
      33,
    ),
    ChartData(
      'Activities',
      77,
    ),
  ];

List<ChartData> _chartData2 = [
  ChartData('Jan', 30),
  ChartData('Feb', 40),
  ChartData('Mar', 25),
  ChartData('Apr', 50),
];

  Widget quizList() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Quiz").snapshots(),
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: QuizTile(
                              noOfQuestions: snapshot.data!.docs.length,
                              imageUrl: snapshot.data!.docs[index]
                                  .data()['quizImgUrl'],
                              title: snapshot.data!.docs[index]
                                  .data()['quizTitle'],
                              description:
                                  snapshot.data!.docs[index].data()['quizDesc'],
                              id: snapshot.data!.docs[index].data()['id'],
                            ),
                          );
                        });
              },
            )
          ],
        ),
      ),
    );
  }

  StudentProvider studentProvider = StudentProvider();

  refreshUser() async {
    await studentProvider.refreshStudent();
  }

  String email = "";
  String name = "";
  @override
  void initState() {
    refreshUser().then((value) {
      setState(() {});
    });

    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    await HelperFunction.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserName().then((value) {
      setState(() {
        name = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Student student = studentProvider.getUser();
    String grade = "Grade 10";
    getAdaptiveDataEasy() async {
      switch (student.year) {
        case "Grade 10":
          grade = "10th Grade";
          break;
        case "Grade 11":
          grade = "11th Grade";
          break;
        case "Grade 12":
          grade = "12th Grade";
          break;
      }
      final response = await http.post(
        Uri.parse('${GlobalVariables.Url}/adaptive_easy'),
        body: json.encode(<String, dynamic>{'grade': grade}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('questions')) {
          easyQuestions.addAll(jsonData);
        } else {
          print("Error: 'questions' key not found in response");
        }
        //}
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AIQuizPlay()),
        // );
      } else {
        print("Error");
      }
    }

    getAdaptiveDataMedium() async {
      final response = await http.post(
        Uri.parse('${GlobalVariables.Url}/adaptive_medium'),
        body: json.encode(<String, dynamic>{'grade': student.year}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('questions')) {
          mediumQuestions.addAll(jsonData);
        } else {
          print("Error: 'questions' key not found in response");
        }
        //}
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AIQuizPlay()),
        // );
      } else {
        print("Error");
      }
    }

    getAdaptiveDataHard() async {
      final response = await http.post(
        Uri.parse('${GlobalVariables.Url}/adaptive_hard'),
        body: json.encode(<String, dynamic>{'grade': student.year}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('questions')) {
          hardQuestions.addAll(jsonData);
        } else {
          print("Error: 'questions' key not found in response");
        }
        //}
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AIQuizPlay()),
        // );
      } else {
        print("Error");
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 175, 217, 255),
      appBar: AppBar(
        title: Text(
          'Hello, $name!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://www.example.com/avatar.png', // Provide the actual image URL here
            ),
            radius: 20,
          ),
          SizedBox(width: 16), // Add spacing between the avatar and the edge
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Divider(
              height: 2,
            ),
            ListTile(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentHomepage()));
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text("Dashboard",style:TextStyle(color: Colors.black)),
            
            

          ),
            ListTile(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage2()));
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text("Homepage",style:TextStyle(color: Colors.black)),
            
            

          ),
          
          
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await auth.signout();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserTypeSelectionPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('assets/images/User.jpeg'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            student.studentname,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            student.year,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(student.email),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Student Report",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 62, 146, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: 200,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: Image.asset(
                          'assets/images/adaptive.png.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 40, 0, 15),
                          child: Text(
                            "Adaptive Learning",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                          child: Text(
                            "Personalized learning experience",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                            child: ElevatedButton(
                              onPressed: () async {
                                await getAdaptiveDataEasy().then((value) {
                                  getAdaptiveDataMedium().then((value) {
                                    getAdaptiveDataHard().then((value) {
                                      QuestionManager questionManager =
                                          QuestionManager(easyQuestions,
                                              mediumQuestions, hardQuestions);
                                      print(easyQuestions);
                                      print(mediumQuestions);
                                      print(hardQuestions);
                                      questionManager.getNextQuestion();
                                    });
                                  });
                                });
                              },
                              child: Text("Take the quiz now"),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
             Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <BarSeries<ChartData, String>>[
                    BarSeries<ChartData, String>(
                      dataSource: chartData2,
                      xValueMapper: (ChartData sales, _) => sales.x,
                      yValueMapper: (ChartData sales, _) => sales.y,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <LineSeries<ChartData, String>>[
                    LineSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData sales, _) => sales.x,
                      yValueMapper: (ChartData sales, _) => sales.y,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      //quizList(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 80,
        padding: EdgeInsets.all(2.0),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            children: [
              // Other bottom nav items if any
              Spacer(),
              Container(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () => setState(() => isCreateMode = true),
                  icon: Icon(Icons.create, size: 39),
                  color: isCreateMode
                      ? Colors.blue
                      : Colors.grey, // Highlight active button
                ),
              ),
              SizedBox(width: 96),
              Container(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () => setState(() => isCreateMode = false),
                  icon: Icon(Icons.upload, size: 39),
                  color: !isCreateMode ? Colors.blue : Colors.grey,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isCreateMode) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShortAnswerScreen(),
                // builder: (context) => Scaffold(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Assignments(),
                // builder: (context) => Scaffold(),
              ),
            );
          }
        },
        child: Icon(isCreateMode
            ? Icons.short_text_sharp
            : Icons.assignment), // Change icon based on mode
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;

  QuizTile(
      {required this.title,
      required this.imageUrl,
      required this.description,
      required this.id,
      required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(id)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
     ),
);
}
}