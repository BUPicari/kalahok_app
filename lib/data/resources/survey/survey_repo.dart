import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/resources/survey/survey_provider.dart';

class SurveyRepository {
  final _provider = SurveyProvider();

  Future<Survey> getSurveyList({required int categoryId}) {
    return _provider.getSurveyList(categoryId: categoryId);
  }

  Future<void> postSubmitSurveyResponse({required Survey survey}) {
    return _provider.postSubmitSurveyResponse(survey: survey);
  }
}

class NetworkError extends Error {}
