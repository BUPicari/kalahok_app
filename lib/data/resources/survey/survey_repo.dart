import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/data/resources/survey/survey_api_provider.dart';
import 'package:kalahok_app/data/resources/survey/survey_db_provider.dart';
import 'package:kalahok_app/helpers/utils.dart';

class SurveyRepository {
  final _apiProvider = SurveyApiProvider();
  final _dbProvider = SurveyDbProvider();

  /// @usedFor: Getting a survey w/ questionnaires
  /// @return: If has internet connection get data using api else local db
  Future<Surveys?> getSurveyWithQuestionnaires({required int surveyId}) async {
    if (await Utils.hasInternetConnection) return _apiProvider.getSurveyWithQuestionnaires(surveyId: surveyId);
    return _dbProvider.getSurveyWithQuestionnaires(surveyId: surveyId);
  }

  Future<void> postSubmitSurveyResponse({required Survey survey}) async {
    // if (await Utils.hasInternetConnection) return _apiProvider.postSubmitSurveyResponse(survey: survey);
    return _apiProvider.postSubmitSurveyResponse(survey: survey);
  }
}
