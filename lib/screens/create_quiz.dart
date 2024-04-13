import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/global/global_var.dart';

import 'package:devopia_overload_oblivion/resources/database.dart';
import 'package:devopia_overload_oblivion/screens/add_question.dart';

import 'package:uuid/uuid.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String? quizImgUrl, quizTitle, quizDesc, id;

  bool isLoading = false;
  String? quizId;

  createQuiz(String year) {
    quizId = Uuid().v1();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizImgUrl": quizImgUrl!,
        "quizTitle": quizTitle!,
        "quizDesc": quizDesc!,
        "id": quizId!,
      };

      databaseService
          .addQuizData(
        quizData,
        quizId!,
        year,
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId!)));
      });
    }
  }

  String selectedValue = 'Kindergarten';
  @override
  Widget build(BuildContext context) {
    // Teacher _teacher =
    //     Provider.of<TeacherProvider>(context).getUser();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Enter Quiz Details',
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.primaryGradient),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16), // Add vertical spacing
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align fields to the left
            children: [
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Quiz Image Url" : null,
                decoration:
                    InputDecoration(hintText: "Quiz Image Url (Optional)"),
                onChanged: (val) {
                  quizImgUrl = val;
                },
              ),
              const SizedBox(
                height: 16, // Add vertical spacing
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Title" : null,
                decoration: const InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              const SizedBox(
                height: 16, // Add vertical spacing
              ),
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Quiz Description" : null,
                decoration: const InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              SizedBox(
                height: 16, // Add vertical spacing
              ),
              const Text('Select a year'),
              Container(
                height: 70,
                width: 80,
                child: DropdownButton<String>(
                  elevation: 6,
                  value: selectedValue,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'Kindergarten',
                      child: Text("Kindergarten"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 1",
                      child: Text("Grade 1"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 2",
                      child: Text("Grade 2"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 3",
                      child: Text("Grade 3"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 4",
                      child: Text("Grade 4"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 5",
                      child: Text("Grade 5"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 6",
                      child: Text("Grade 6"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 7",
                      child: Text("Grade 7"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 8",
                      child: Text("Grade 8"),
                    ),
                    DropdownMenuItem(
                      value: "Grade 9",
                      child: Text("Grade 9"),
                    ),
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
              SizedBox(
                height: 16, // Add vertical spacing
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz(
                    selectedValue,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
