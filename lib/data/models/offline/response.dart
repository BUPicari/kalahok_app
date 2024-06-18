class Response {
  String surveyQuestion;
  List<String> questionFieldTexts;
  List<String> responses;
  String otherResponse;
  String? file;

  Response({
    required this.surveyQuestion,
    required this.questionFieldTexts,
    required this.responses,
    required this.otherResponse,
    this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'surveyQuestion': surveyQuestion,
      'questionFieldTexts': questionFieldTexts,
      'responses': responses,
      'otherResponse': otherResponse,
      'file': file,
    };
  }
}
