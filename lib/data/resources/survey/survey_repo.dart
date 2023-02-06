import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/resources/survey/survey_provider.dart';

class SurveyRepository {
  final _provider = SurveyProvider();

  Future<Survey> getSurveyList({required int surveyId}) {
    return _provider.getSurveyList(surveyId: surveyId);
  }

  Future<void> postSubmitSurveyResponse({required Survey survey}) {
    return _provider.postSubmitSurveyResponse(survey: survey);
  }
}

class NetworkError extends Error {}
