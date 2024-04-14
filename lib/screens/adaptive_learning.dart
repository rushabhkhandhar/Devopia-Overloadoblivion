class Question {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  Question(this.question, this.correctAnswer, this.incorrectAnswers);
}

class QuestionManager {
  final Map<String, dynamic> easyQuestions;
  final Map<String, dynamic> mediumQuestions;
  final Map<String, dynamic> hardQuestions;
  QuestionDifficulty currentDifficulty = QuestionDifficulty.EASY;
  int correctStreak = 0;
  int numCorrectAnswers = 0;
  int numIncorrectAnswers = 0;
  int currentQuestionIndex = 0;

  QuestionManager(this.easyQuestions, this.mediumQuestions, this.hardQuestions);

  Question getCurrentQuestion() {
    final questions = getQuestionsForDifficulty(currentDifficulty);
    final questionMap = questions['questions'][0][currentQuestionIndex];
    return Question(
      questionMap['question'],
      questionMap['correct_answer'],
      questionMap['incorrect_answers'].cast<String>(),
    );
  }

  void getNextQuestion() {
    currentQuestionIndex++;
    if (currentQuestionIndex >= getQuestionsForDifficulty(currentDifficulty)['questions'][0].length) {
      currentQuestionIndex = 0;
      if (correctStreak >= 3) {
        increaseDifficulty();
      } else if (correctStreak < 0) {
        decreaseDifficulty();
      }
      correctStreak = 0;
    }
  }

  Map<String, dynamic> getQuestionsForDifficulty(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.EASY:
        return easyQuestions;
      case QuestionDifficulty.MEDIUM:
        return mediumQuestions;
      case QuestionDifficulty.HARD:
        return hardQuestions;
      default:
        throw Exception('Invalid difficulty level');
    }
  }

  int getTotalQuestions() {
    return easyQuestions['questions'][0].length +
        mediumQuestions['questions'][0].length +
        hardQuestions['questions'][0].length;
  }

  void increaseDifficulty() {
    if (currentDifficulty == QuestionDifficulty.EASY) {
      currentDifficulty = QuestionDifficulty.MEDIUM;
    } else if (currentDifficulty == QuestionDifficulty.MEDIUM) {
      currentDifficulty = QuestionDifficulty.HARD;
    }
  }

  void decreaseDifficulty() {
    if (currentDifficulty == QuestionDifficulty.MEDIUM) {
      currentDifficulty = QuestionDifficulty.EASY;
    }
  }

  void registerCorrectAnswer() {
    correctStreak++;
    numCorrectAnswers++;
  }

  void registerWrongAnswer() {
    correctStreak--;
    numIncorrectAnswers++;
  }
}

enum QuestionDifficulty { EASY, MEDIUM, HARD, }