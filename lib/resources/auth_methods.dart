import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devopia_overload_oblivion/Helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devopia_overload_oblivion/models/student_model.dart';
import 'package:devopia_overload_oblivion/models/teacher_model.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> signUpStudent({
    required String email,
    required String password,
    required String studentname,
    required String year,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          studentname.isNotEmpty &&
          year.isNotEmpty) {

            HelperFunction.setUserLoggedInStatus(true);
          HelperFunction.setUserNameSF( studentname);
          HelperFunction.setUserEmailSF( email);

        UserCredential studentCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(studentCredential.user!.uid);

        Student student = Student(
          uid: studentCredential.user!.uid,
          email: email,
          studentname: studentname,
          year: year,
          quizID: [],
        );
        await _firestore
            .collection('students')
            .doc(studentCredential.user!.uid)
            .set(student.toJson());
        res = "Success";
      } else {
        res = 'Please enter all the fields';
      }
      return res;
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> loginStudent({
    required String email,
    required String password,
  }) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

           HelperFunction.setUserLoggedInStatus(true);
          // HelperFunction.setUserNameSF( snapshot.docs[0]['fullName']);
          HelperFunction.setUserEmailSF( email);
        res = "Success";
      } else {
        res = 'Please enter all the fields';
      }
      return res;
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> signUpTeacher(
      {required String email,
      required String password,
      required String teachername,
      required String course,
      required String designation}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          teachername.isNotEmpty &&
          course.isNotEmpty &&
          designation.isNotEmpty) {

            HelperFunction.setUserLoggedInStatus(true);
          HelperFunction.setUserNameSF( teachername);
          HelperFunction.setUserEmailSF( email);

        UserCredential teacherCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(teacherCredential.user!.uid);

        Teacher teacher = Teacher(
          uid: teacherCredential.user!.uid,
          email: email,
          teachername: teachername,
          course: course,
          designation: designation,
          quizId: [],
        );
        await _firestore
            .collection('teachers')
            .doc(teacherCredential.user!.uid)
            .set(teacher.toJson());
        res = "Success";
      } else {
        res = 'Please enter all the fields';
      }
      return res;
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> loginTeacher({
    required String email,
    required String password,
  }) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String res = "Some error occured";
    try {

      if (email.isNotEmpty && password.isNotEmpty) {

        HelperFunction.setUserLoggedInStatus(true);
          // HelperFunction.setUserNameSF( fullName);
          HelperFunction.setUserEmailSF( email); 

        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = 'Please enter all the fields';
      }
      return res;
    } catch (err) {
      return err.toString();
    }
  }

  Future<Teacher> getTeacherDetails() async {
    User currentUser = _auth.currentUser!;
    print(currentUser.email);
    DocumentSnapshot snap =
        await _firestore.collection('teachers').doc(currentUser.uid).get();

    // print((snap.data() as Map<String, dynamic>)['username'] as String);

    return Teacher.fromSnap(snap);
  }

  Future<Student> getStudentDetails() async {
    User currentUser = _auth.currentUser!;
    print(currentUser.email);
    DocumentSnapshot snap =
        await _firestore.collection('students').doc(currentUser.uid).get();

    // print((snap.data() as Map<String, dynamic>)['username'] as String);

    return Student.fromSnap(snap);
  }
  Future signout() async{
try{
await HelperFunction.setUserLoggedInStatus(false);
await HelperFunction.setUserEmailSF("");
await HelperFunction.setUserNameSF("");
await _auth.signOut();

} catch(e){
  return null;
}
}
}
