class SurveyResponse {
  int surveyId = 0;
  List<Questionnaires> questionnaires = [];

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

class Questionnaires {
  int questionnaireId = 0;
  String answer = "";

  Questionnaires({
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

class Answer {
  List<String> selected = [];
  String others = "";

  Answer({
    required this.selected,
    required this.others,
  });

  Map<String, dynamic> toJson() {
    return {
      'selected': selected,
      'others': others,
    };
  }
}
