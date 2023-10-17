class SurveyResponse {
  int surveyId;
  int detailsId;
  List<ResponseQuestionnaires> questionnaires;

  SurveyResponse({
    required this.surveyId,
    required this.detailsId,
    required this.questionnaires,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questions =
      questionnaires.map((e) => e.toJson()).toList();

    return {
      'survey_id': surveyId,
      'detailsId': detailsId,
      'questionnaires': questions,
    };
  }
}

class ResponseQuestionnaires {
  int questionnaireId;
  String answer;
  String? file;

  ResponseQuestionnaires({
    required this.questionnaireId,
    required this.answer,
    this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionnaire_id': questionnaireId,
      'answer': answer,
      'file': file,
    };
  }
}
