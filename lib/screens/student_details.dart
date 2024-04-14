import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devopia_overload_oblivion/resources/auth_methods.dart';
import 'package:devopia_overload_oblivion/screens/results.dart';
import 'package:devopia_overload_oblivion/screens/user_type_selec.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String selectedStudentName =" "; // Add a variable to store the selected student name
  String selectedEmail =" "; // Add a variable to store the selected student name
  String selectedGrade =" "; // Add a variable to store the selected student name
 AuthMethods auth = AuthMethods();
  
  @override
  Widget build(BuildContext context) {
  
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance.collection('students').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final studentNames = snapshot.data!.docs;
      return ListView.builder(
        itemCount: studentNames.length,
        itemBuilder: (context, index) {
          final studentName = studentNames[index];
          return Material(
            child: ListTile(
              title: Text(studentName['studentname']),
              onTap: () {
                setState(() {
                  selectedStudentName = studentName['studentname'];
                  selectedEmail = studentName['email'];
                  selectedGrade = studentName['year'];
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsPage(
                      username: selectedStudentName,
                      emailID: selectedEmail,
                      grade: selectedGrade,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const CircularProgressIndicator();
    }
  },
);
  }
}

class UserDetailsPage extends StatelessWidget {
  final String username;
  final String emailID;
  final String grade;

   UserDetailsPage({super.key,
   required this.username,
   required this.emailID,
   required this.grade
   });

    List<ChartData> chartData = [
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
   List<ChartData> chartData2 = [
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

  @override
  Widget build(BuildContext context) {
    // Use the selected username to display the user details
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 175, 217, 255),
      appBar: AppBar(
        title: Text(
          'Hello, $username!',
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
                            username,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            grade,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(emailID),
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
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      //   height: 80,
      //   padding: EdgeInsets.all(2.0),
      //   child: BottomAppBar(
      //     shape: CircularNotchedRectangle(),
      //     child: Row(
      //       children: [
      //         // Other bottom nav items if any
      //         Spacer(),
      //         Container(
      //           width: 48,
      //           height: 48,
      //           child: IconButton(
      //             onPressed: () => setState(() => isCreateMode = true),
      //             icon: Icon(Icons.create, size: 39),
      //             color: isCreateMode
      //                 ? Colors.blue
      //                 : Colors.grey, // Highlight active button
      //           ),
      //         ),
      //         SizedBox(width: 96),
      //         Container(
      //           width: 48,
      //           height: 48,
      //           child: IconButton(
      //             onPressed: () => setState(() => isCreateMode = false),
      //             icon: Icon(Icons.upload, size: 39),
      //             color: !isCreateMode ? Colors.blue : Colors.grey,
      //           ),
      //         ),
      //         Spacer(),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (isCreateMode) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => ShortAnswerScreen(),
      //           // builder: (context) => Scaffold(),
      //         ),
      //       );
      //     } else {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Assignments(),
      //           // builder: (context) => Scaffold(),
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