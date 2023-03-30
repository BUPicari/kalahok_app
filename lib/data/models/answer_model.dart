class Answer {
  String surveyQuestion;
  List<String> questionFieldTexts;
  List<String> answers;
  String otherAnswer;

  Answer({
    required this.surveyQuestion,
    required this.questionFieldTexts,
    required this.answers,
    required this.otherAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'surveyQuestion': surveyQuestion,
      'questionFieldTexts': questionFieldTexts,
      'answers': answers,
      'otherAnswer': otherAnswer,
    };
  }
}
