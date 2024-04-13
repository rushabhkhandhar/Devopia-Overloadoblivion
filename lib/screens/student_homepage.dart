import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:devopia_overload_oblivion/Helper/helper_function.dart';
import 'package:devopia_overload_oblivion/resources/auth_methods.dart';
import 'package:devopia_overload_oblivion/widgets/appbar.dart';
import 'package:devopia_overload_oblivion/widgets/pages.dart';
import 'package:flutter/material.dart';

import 'package:devopia_overload_oblivion/resources/database.dart';
// import 'package:devopia_overload_oblivion/screens/assignments.dart';

import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
// import 'package:devopia_overload_oblivion/screens/short_answer_screen.dart';
import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';
import 'package:iconly/iconly.dart';



class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
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
    });
    super.initState();
    getUserDetails();
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
int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
      backgroundColor: Color(0xFFEEEFF5),
      elevation: 0,
      title: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: Color(0xFFEEEFF5),
            size: 30,
          ),
          Text('Hello, $name!'),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpeg'),
            ),
          ),
          // Greeting the user
        ],
      ),
    ),
      drawer:  Drawer(
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
      body: Center(child: pages[_currentIndex]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _currentIndex,
          // indicatorColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.1),
          // outlineBorderColor: Colors.black.withOpacity(0.1),
          onTap: (int index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.white,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.heart,
              unselectedIcon: IconlyLight.heart,
              selectedColor: Colors.red,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.plus,
              unselectedIcon: IconlyLight.plus,
              selectedColor: Colors.white,
            ),

            /// Search
            CrystalNavigationBarItem(
                icon: IconlyBold.search,
                unselectedIcon: IconlyLight.search,
                selectedColor: Colors.white),

            /// Profile
            CrystalNavigationBarItem(
              icon: IconlyBold.user_2,
              unselectedIcon: IconlyLight.user,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (isCreateMode) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           // builder: (context) => ShortAnswerScreen(),
      //           builder: (context) => Scaffold(),
      //         ),
      //       );
      //     } else {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           // builder: (context) => Assignments(),
      //           builder: (context) => Scaffold(),
      //         ),
      //       );
      //     }
      //   },
      //   child: Icon(isCreateMode
      //       ? Icons.short_text_sharp
      //       : Icons.assignment), // Change icon based on mode
      // ),
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
