import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String uid;
  final String email;
  final String studentname;
  final String year;
  final List quizID;

  Student({
    required this.uid,
    required this.email,
    required this.studentname,
    required this.year,

    required this.quizID ,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'studentname': studentname,
      'email': email,
      'year': year,

      'quizData':quizID
    };
  }

  static Student fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot.toString());
    return Student(
      uid: snapshot['uid'],
      email: snapshot['email'],
      studentname: snapshot['studentname'],
      year: snapshot['year'],

      quizID: snapshot['quizData']
    );
  }
}
