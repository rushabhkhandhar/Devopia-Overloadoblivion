class QuestionModel {
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctOption;
  bool answered;
  bool isCorrect;

  QuestionModel(
      {required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4,
      required this.correctOption,
      required this.answered,
      this.isCorrect = false});
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'correctOption': correctOption,
      'answered': answered,
      'isCorrect': isCorrect
    };
  }
}
