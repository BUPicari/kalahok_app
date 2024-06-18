class QuestionnaireResponse {
  int id;
  int surveyResponseId;
  int questionId;
  String answer;
  String? file;

  QuestionnaireResponse({
    required this.id,
    required this.surveyResponseId,
    required this.questionId,
    required this.answer,
    this.file,
  });

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> data) {
    return QuestionnaireResponse(
      id: data['id'],
      surveyResponseId: data['survey_response_id'],
      questionId: data['question_id'],
      answer: data['answer'],
      file: data['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'survey_response_id': surveyResponseId,
      'question_id': questionId,
      'answer': answer,
      'file': file,
    };
  }
}
