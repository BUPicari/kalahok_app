import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/data/resources/online/survey/survey_api_provider.dart';

/// CHECKED
class SurveyRepository {
  final _provider = SurveyApiProvider();

  /// Getting a survey w/ questionnaires
  Future<Surveys?> getSurveyWithQuestionnaires({
    required int surveyId,
    required int languageId,
  }) async {
    return _provider.getSurveyWithQuestionnaires(
      surveyId: surveyId,
      languageId: languageId,
    );
  }

  /// Submit survey responses
  Future<void> postSubmitSurveyResponse({ required Surveys survey }) async {
    _provider.postSubmitSurveyResponse(survey: survey);
  }
}
