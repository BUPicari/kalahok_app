class Answer {
  String surveyQuestion;
  List<String> questionFieldTexts;
  List<String> answers;
  String otherAnswer;
  String? file;

  Answer({
    required this.surveyQuestion,
    required this.questionFieldTexts,
    required this.answers,
    required this.otherAnswer,
    this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'surveyQuestion': surveyQuestion,
      'questionFieldTexts': questionFieldTexts,
      'answers': answers,
      'otherAnswer': otherAnswer,
      'file': file,
    };
  }
}
