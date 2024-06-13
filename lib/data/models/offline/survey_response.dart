class SurveyResponse {
  int id;
  int surveyId;
  int detailId;
  int isSent;

  SurveyResponse({
    required this.id,
    required this.surveyId,
    required this.detailId,
    required this.isSent,
  });

  factory SurveyResponse.fromJson(Map<String, dynamic> data) {
    return SurveyResponse(
      id: data['id'],
      surveyId: data['survey_id'],
      detailId: data['detail_id'],
      isSent: data['is_sent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'survey_id': surveyId,
      'detail_id': detailId,
      'is_sent': isSent,
    };
  }
}
