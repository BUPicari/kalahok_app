import 'survey.dart';
import 'language.dart';

class SurveyDetail {
  int id;
  Survey survey;
  Language language;

  SurveyDetail({
    required this.id,
    required this.survey,
    required this.language,
  });

  factory SurveyDetail.fromJson(Map<String, dynamic> json) {
    var surveyJson = json['survey'];
    Survey survey = Survey.fromJson(surveyJson);

    var languageJson = json['language'];
    Language language = Language.fromJson(languageJson);

    return SurveyDetail(
      id: json['id'],
      survey: survey,
      language: language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'survey': survey.toJson(),
      'language': language.toJson(),
    };
  }
}
