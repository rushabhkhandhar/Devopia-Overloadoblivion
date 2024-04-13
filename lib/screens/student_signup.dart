import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/global/global_var.dart';
import 'package:devopia_overload_oblivion/resources/auth_methods.dart';
import 'package:devopia_overload_oblivion/screens/student_login.dart';
import 'package:devopia_overload_oblivion/widgets/utils.dart';

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
  bool isLoading = false;
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
          builder: (context) => const StudentLogin(),
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

  String selectedValue = "Kindergarten";

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
                const SizedBox(
                  height: 16,
                ),
               
                const SizedBox(height: 45.0),
                ElevatedButton(
                  onPressed: () async {
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) => const StudentLogin()));
                    await signUpStudent();
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const StudentLogin()));
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
