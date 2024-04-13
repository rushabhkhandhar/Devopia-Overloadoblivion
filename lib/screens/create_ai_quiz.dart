import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/global/global_var.dart';
import 'package:devopia_overload_oblivion/models/teacher_model.dart';
import 'package:devopia_overload_oblivion/providers/teacher_provider.dart';
import 'package:devopia_overload_oblivion/resources/database.dart';
import 'package:devopia_overload_oblivion/screens/add_question.dart';
import 'package:devopia_overload_oblivion/screens/ai_generated_quiz_input.dart';
import 'package:devopia_overload_oblivion/widgets/blue_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateAIQuiz extends StatefulWidget {
  @override
  _CreateAIQuizState createState() => _CreateAIQuizState();
}

class _CreateAIQuizState extends State<CreateAIQuiz> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String? quizImgUrl, quizTitle, quizDesc, id;

  bool isLoading = false;
  String? quizId;
  String selectedValue = 'Kindergarten';
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
          .addQuizData(quizData, quizId!, year, )
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AIQuizInputPage(
                      quizId: quizId!,
                    )));
      });
    }
  }

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: 16), // Add vertical spacing
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align fields to the left
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Image Url" : null,
                      decoration: InputDecoration(
                          hintText: "Quiz Image Url (Optional)"),
                      onChanged: (val) {
                        quizImgUrl = val;
                      },
                    ),
                    SizedBox(
                      height: 16, // Add vertical spacing
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Title" : null,
                      decoration: InputDecoration(hintText: "Quiz Title"),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                    ),
                    SizedBox(
                      height: 16, // Add vertical spacing
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Description" : null,
                      decoration: InputDecoration(hintText: "Quiz Description"),
                      onChanged: (val) {
                        quizDesc = val;
                      },
                    ),
                    SizedBox(
                      height: 16, // Add vertical spacing
                    ),
                  ],
                ),
              ),
            ),
            const Text('Select a year'),
            Container(
              height: 70,
              width: 80,
              child: DropdownButton<String>(
                key: UniqueKey(),
                elevation: 6,
                value: selectedValue,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: 'FE',
                    child: Text("FE"),
                  ),
                  DropdownMenuItem(
                    value: "SE",
                    child: Text("SE"),
                  ),
                  DropdownMenuItem(
                    value: "TE",
                    child: Text("TE"),
                  ),
                  DropdownMenuItem(
                    value: "BE",
                    child: Text("BE"),
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
            BlueButton(
              onTap: () {
                createQuiz( selectedValue);
              },
              text: "Generate Quiz",
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
