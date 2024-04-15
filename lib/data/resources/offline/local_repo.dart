import 'package:kalahok_app/data/models/offline/category.dart';
import 'package:kalahok_app/data/models/offline/dropdown.dart';
import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/data/models/offline/survey_detail.dart';
import 'package:kalahok_app/data/resources/offline/local_provider.dart';

/// CHECKED
class LocalRepository {
  final _provider = LocalProvider();

  /// Get categories
  Future<List<Category>> getCategories() async {
    return _provider.getCategories();
  }

  /// Get surveys by category
  Future<List<Survey>> getSurveysByCategory({
    required int categoryId,
  }) async {
    return _provider.getSurveysByCategory(categoryId: categoryId);
  }

  /// Get survey details by survey
  Future<List<SurveyDetail>> getDetailsBySurvey({
    required int surveyId,
  }) async {
    return _provider.getDetailsBySurvey(surveyId: surveyId);
  }

  /// Get questionnaires by survey and detail
  Future<List<Questionnaire>> getQuestionnairesBySurvey({
    required int surveyId,
    required int detailsId,
  }) async {
    return _provider.getQuestionnairesBySurvey(
      surveyId: surveyId,
      detailsId: detailsId,
    );
  }

  /// Get dropdown data [provinces, cities, barangays, courses, schools]
  Future<List<Dropdown>> getDropdownData({
    required String endpoint,
    String? filter,
    String? query,
  }) async {
    return _provider.getDropdownData(
      endpoint: endpoint,
      filter: filter,
      query: query,
    );
  }

  /// Submit response to local db
  Future<void> postSubmitLocalResponse({
    required Survey survey,
    required List<Questionnaire> questionnaires,
  }) async {
    return _provider.postSubmitLocalResponse(
      survey: survey,
      questionnaires: questionnaires,
    );
  }
}
