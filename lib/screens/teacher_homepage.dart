import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devopia_overload_oblivion/Helper/helper_function.dart';
import 'package:devopia_overload_oblivion/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/global/global_var.dart';
import 'package:devopia_overload_oblivion/providers/teacher_provider.dart';
import 'package:devopia_overload_oblivion/resources/database.dart';
import 'package:devopia_overload_oblivion/screens/add_question.dart';
import 'package:devopia_overload_oblivion/screens/ai_generated_quiz_input.dart';
import 'package:devopia_overload_oblivion/screens/create_ai_quiz.dart';
import 'package:devopia_overload_oblivion/screens/create_quiz.dart';
import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';
import 'package:devopia_overload_oblivion/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class TeacherHomepage extends StatefulWidget {
   TeacherHomepage({super.key});
  

  @override
  State<TeacherHomepage> createState() => _TeacherHomepageState();
}

class _TeacherHomepageState extends State<TeacherHomepage> {
  Stream? quizStream;
  bool isCreateMode = true;
  AuthMethods auth = AuthMethods();
  String email = "";
  String name = "";

  DatabaseService databaseService = new DatabaseService();

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

  @override
  void initState() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
      getUserDetails();
    });
    //addData();
    super.initState();
  }
   void getUserDetails() async{
    await HelperFunction.getUserEmail().then((value){
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserName().then((value){
      setState(() {
        name = value!;
      });
    });
    
  }

  // addData() async {
  //   TeacherProvider _teacherProvider =
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      title: Text(
        'Hello, $name!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
    
      drawer:Drawer(
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
                                    builder: (context) => const UserTypeSelectionPage()),
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
      body: quizList(),
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
                builder: (context) => CreateQuiz(),
                // builder: (context) => Scaffold(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateAIQuiz(),
                // builder: (context) => Scaffold(),
              ),
            );
          }
        },
        child: Icon(isCreateMode
            ? Icons.add
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
          context,
          MaterialPageRoute(
            builder: (context) => QuizPlay(id),
          ),
        );
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