class SurveyResponse {
  int surveyId;
  List<ResponseQuestionnaires> questionnaires;

  SurveyResponse({
    required this.surveyId,
    required this.questionnaires,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questions =
      questionnaires.map((e) => e.toJson()).toList();

    return {
      'survey_id': surveyId,
      'questionnaires': questions,
    };
  }
}

class ResponseQuestionnaires {
  int questionnaireId;
  String answer;

  ResponseQuestionnaires({
    required this.questionnaireId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionnaire_id': questionnaireId,
      'answer': answer,
    };
  }
}
