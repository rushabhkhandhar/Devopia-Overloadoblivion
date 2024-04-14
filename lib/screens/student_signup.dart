import 'dart:convert';
import 'package:devopia_overload_oblivion/resources/database.dart';
import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/global/global_var.dart';
import 'package:devopia_overload_oblivion/resources/auth_methods.dart';
import 'package:devopia_overload_oblivion/screens/student_login.dart';
import 'package:devopia_overload_oblivion/widgets/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpassController = TextEditingController();
  TextEditingController _travelTime = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _studyTime = TextEditingController();
  TextEditingController _internet = TextEditingController();
  TextEditingController _freeTime = TextEditingController();
  bool isLoading = false;
  String quizId = Uuid().v1();
  DatabaseService databaseService = DatabaseService();

  uploadQuizData(String question, String option1, String option2,
      String option3, String option4) async {
    Map<String, String> questionMap = {
      "question": question,
      "option1": option1,
      "option2": option2,
      "option3": option3,
      "option4": option4
    };

    print("${quizId}");
    databaseService.addQuestionData(questionMap, quizId).then((value) {
      question = "";
      option1 = "";
      option2 = "";
      option3 = "";
      option4 = "";
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> signUpStudent() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpStudent(
      email: _emailController.text,
      password: _passwordController.text,
      studentname: _nameController.text,
      year: selectedValue,
    );
    setState(() {
      isLoading = false;
    });
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QuizPlay(quizId),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _cpassController.dispose();
    super.dispose();
  }


  String selectedValue = "Grade 10";
  String grade = "10th Grade";
  String sex = "Male";
  String Mjob="Mjob_at_home";
  String Fjob="Fjob_at_home";
  int Medu= 1;
  int Fedu= 1;
  int paid= 1;
  int activities= 1;

  getQuiz() async {
    switch (selectedValue) {
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
      Uri.parse('${GlobalVariables.Url}/get_questions'),
      body: json.encode(<String, dynamic>{
        
        'grade': grade,
      
    
      
      
      
      }),
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('questions')) {
        for (var questionData in jsonData['questions']) {
          String question = questionData['question'];
          String correctAnswer = questionData['correct_answer'];
          List<String> incorrectAnswers = questionData["incorrect_answers"]
              .cast<
                  String>(); // Assuming incorrect_answers is a list of strings

          uploadQuizData(
            question,
            correctAnswer,
            incorrectAnswers[0],
            incorrectAnswers[1],
            incorrectAnswers[2], // Assuming there are 3 incorrect answers
          );
        }
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

  // getData() async {
  //   final res = await http.post(
  //     Uri.parse('${GlobalVariables.Url}/predict_changes'),
  //      body: json.encode(<String, dynamic>{
    //     'age': [_ageController.text],
    //   'Medu':[Medu],
    //   'Fedu':[Fedu],
    //   'traveltime': [_travelTime.text],
    //   'studytime': [ _studyTime.text],
    //   'failures':[1],
    //   'higher':[1],
    //   'internet': [_internet.text],
    //   'paid':[paid],
    //   'activities':[activities],
    //   'romantic':[1],
    //   'freetime': [_freeTime.text],
    //   'goout':[1],
    //   'absences':[1],
    //   "sex_F": [0],
    // 'sex_M': [1],
    // "Mjob_at_home": [0],
    // "Mjob_health": [0],
    // "Mjob_other": [0],
    // "Mjob_services": [1],
    // "Mjob_teacher": [0],
    // "Fjob_at_home": [0],
    // "Fjob_health": [0],
    // "Fjob_other": [0],
    // "Fjob_services": [1],
    // "Fjob_teacher": [0]
  //      }),
  //     headers: <String, String>{'Content-Type': 'application/json'},
      
  //   );
  //   if (res.statusCode == 200) {
  //      print(jsonDecode(res.body));
  //   }else{
  //     print(jsonDecode(res.body));

  //   }
  // }
   sendData() async {
  final Map<String, dynamic> data = {
     "age": [_ageController.text],
  "Medu": [Medu],
  "Fedu": [Fedu],
  "traveltime": [_travelTime.text],
  "studytime": [ _studyTime.text],
  "failures": [0],
  "paid": [1],
  "activities": [1],
  "higher": [1],
  "internet": [1],
  "romantic": [0],
  "freetime": [3],
  "goout": [3],
  "absences": [4],
  "sex_F": [0],
  "sex_M": [1],
  "Mjob_at_home": [0],
  "Mjob_health": [0],
  "Mjob_other": [0],
  "Mjob_services": [1],
  "Mjob_teacher": [0],
  "Fjob_at_home": [0],
  "Fjob_health": [0],
  "Fjob_other": [0],
  "Fjob_services": [1],
  "Fjob_teacher": [0]
  };

  final response = await http.post(
    Uri.parse('${GlobalVariables.Url}/predict_changes'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully!');
    print(jsonDecode(response.body));
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student SignUp',
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.primaryGradient),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    focusColor: Color.fromRGBO(31, 68, 255, 0.776),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Student Email',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    focusColor: Color.fromRGBO(31, 68, 255, 0.776),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: 'Password',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _cpassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: 'Confirm Password',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('Select a year'),
                Container(
                  height: 70,
                  width: 100,
                  child: DropdownButton<String>(
                    elevation: 6,
                    value: selectedValue,
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: "Grade 10",
                        child: Text("Grade 10"),
                      ),
                      DropdownMenuItem(
                        value: "Grade 11",
                        child: Text("Grade 11"),
                      ),
                      DropdownMenuItem(
                        value: "Grade 12",
                        child: Text("Grade 12"),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _ageController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: 'Age',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _travelTime,
                  obscureText: false,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: 'What is your travel time to school? (in hours)',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _studyTime,
                  obscureText: false,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: 'What is your study time? (in hours)',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _internet,
                  obscureText: false,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: 'What is your intensity of internet usage?(On a scale of 5)',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _freeTime,
                  obscureText: false,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(31, 68, 255, 0.776)),
                    ),
                    labelText: ' What is your free time? (in hours)',
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(31, 68, 255, 0.776)),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Gender'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<String>(
                    elevation: 6,
                    value: sex,
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: "Male",
                        child: Text("Male"),
                      ),
                      DropdownMenuItem(
                        value: "Female",
                        child: Text("Female"),
                      ),
                     
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        sex = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('What is your Mother\'s job?'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<String>(
                    elevation: 6,
                    value: Mjob,
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: "Mjob_at_home",
                        child: Text("HouseWife"),
                      ),
                      DropdownMenuItem(
                        value: "Mjob_health",
                        child: Text("Healthcare"),
                      ),
                      DropdownMenuItem(
                        value: "Mjob_services",
                        child: Text("Service"),
                      ),
                      DropdownMenuItem(
                        value: "Mjob_other",
                        child: Text("Other"),
                      ),
                     
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        Mjob = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('What is your Father\'s job?'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<String>(
                    elevation: 6,
                    value: Fjob,
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: "Fjob_at_home",
                        child: Text("HouseHusband"),
                      ),
                      DropdownMenuItem(
                        value: "Fjob_health",
                        child: Text("Healthcare"),
                      ),
                      DropdownMenuItem(
                        value: "Fjob_services",
                        child: Text("Service"),
                      ),
                      DropdownMenuItem(
                        value: "Fjob_other",
                        child: Text("Other"),
                      ),
                     
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        Fjob = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Is your mother educated?'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<int>(
                    elevation: 6,
                    value: Medu,
                    items: const <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        value: 1,
                        child: Text("Yes"),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text("No"),
                      ),
                      
                     
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        Medu = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Is your Father educated?'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<int>(
                    elevation: 6,
                    value: Fedu,
                    items: const <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        value: 1,
                        child: Text("Yes"),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text("No"),
                      ),
                      
                     
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        Fedu = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Do you pay for extra classes?'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<int>(
                    elevation: 6,
                    value: paid,
                    items: const <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        value: 1,
                        child: Text("Yes"),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text("No"),
                      ),
                      
                     
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        paid = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Do you do any extra-curricular activities?'),
                Container(
                  height: 70,
                  width: 200,
                  child: DropdownButton<int>(
                    elevation: 6,
                    value: activities,
                    items: const <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        value: 1,
                        child: Text("Yes"),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text("No"),
                      ),
                      
                     
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        activities = newValue!;
                        // Perform actions based on the selected value
                      });
                    },
                  ),
                ),
                

                const SizedBox(height: 45.0),
                ElevatedButton(
                  onPressed: () async {
                    
                    sendData();

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(31, 68, 255, 0.776),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: const Size(350.0, 45.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 45.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already Have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StudentLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromRGBO(31, 68, 255, 0.776),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
