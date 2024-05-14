import 'dart:convert';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:sqflite/sqflite.dart';

import 'package:kalahok_app/data/models/offline/category.dart';
import 'package:kalahok_app/data/models/offline/dropdown.dart';
import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/data/models/offline/survey_detail.dart';
import 'package:kalahok_app/services/database_service.dart';

/// CHECKED
class LocalProvider {
  final _dbService = DatabaseService.dbService;

  /// Get categories
  Future<List<Category>> getCategories() async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> dbCategory;

    /// Query db categories
    dbCategory = await db.query('category',
      columns: ['id', 'name', 'image'],
    );

    return dbCategory.map((e) => Category.fromJson(e)).toList();
  }

  /// Get surveys by category
  Future<List<Survey>> getSurveysByCategory({
    required int categoryId,
  }) async {
    final db = await _dbService.database;
    List<Survey> result = [];

    /// Query db surveys where category id
    List<Map<String, dynamic>> dbSurvey = await db.query(
      'survey',
      columns: [
        'id',
        'category_id',
        'title',
        'description',
        'start_date',
        'end_date',
        'passcode',
        'waiver',
        'status',
      ],
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );

    /// Query db category where id
    List<Map<String, dynamic>> dbCategory = await db.query(
      'category',
      columns: ['id', 'name', 'image'],
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (dbSurvey.isNotEmpty && dbCategory.isNotEmpty) {
      List<Survey> surveys = dbSurvey.map((e) {
        final newSurvey = Map.of(e);
        newSurvey['category'] = dbCategory.first;
        return Survey.fromJson(newSurvey);
      }).toList();

      result = surveys;
    }

    return result.toList();
  }

  /// Get survey details by survey
  Future<List<SurveyDetail>> getDetailsBySurvey({
    required int surveyId,
  }) async {
    final db = await _dbService.database;
    List<SurveyDetail> result = [];

    /// Query db details where survey id
    List<Map<String, dynamic>> dbDetail = await db.query(
      'survey_detail',
      columns: ['id', 'survey_id', 'language_id'],
      where: 'survey_id = ?',
      whereArgs: [surveyId],
    );

    if (dbDetail.isNotEmpty) {
      for (var detail in dbDetail) {
        final surveyDetail = Map.of(detail);

        /// Query db language where id
        List<Map<String, dynamic>> dbLanguage = await db.query(
          'language',
          columns: ['id', 'name'],
          where: 'id = ?',
          whereArgs: [surveyDetail['language_id']],
        );

        /// Query db survey where id
        List<Map<String, dynamic>> dbSurvey = await db.query(
          'survey',
          columns: [
            'id',
            'category_id',
            'title',
            'description',
            'start_date',
            'end_date',
            'passcode',
            'waiver',
            'status',
          ],
          where: 'id = ?',
          whereArgs: [surveyId],
        );

        if (dbLanguage.isNotEmpty && dbSurvey.isNotEmpty) {
          var survey = dbSurvey.first;
          var language = dbLanguage.first;

          /// Query db category where id
          List<Map<String, dynamic>> dbCategory = await db.query(
            'category',
            columns: ['id', 'name', 'image'],
            where: 'id = ?',
            whereArgs: [survey['category_id']],
          );

          if (dbCategory.isNotEmpty) {
            var category = dbCategory.first;
            final newSurvey = Map.of(survey);

            newSurvey['category'] = category;
            surveyDetail['language'] = language;
            surveyDetail['survey'] = newSurvey;

            result.add(SurveyDetail.fromJson(surveyDetail));
          }
        }
      }
    }

    return result.toList();
  }

  /// Get questionnaires by survey and detail
  Future<List<Questionnaire>> getQuestionnairesBySurvey({
    required int surveyId,
    required int detailsId,
  }) async {
    final db = await _dbService.database;
    List<Questionnaire> result = [];

    /// Query db questionnaires where survey id and detail id
    List<Map<String, dynamic>> dbQuestionnaire = await db.query(
      'questionnaire',
      columns: [
        'id',
        'survey_id',
        'detail_id',
        'question',
        'type',
        'choices',
        'configs',
        'labels',
        'rates',
      ],
      where: 'survey_id = ? and detail_id = ?',
      whereArgs: [surveyId, detailsId],
    );

    /// Query db survey where id
    List<Map<String, dynamic>> dbSurvey = await db.query(
      'survey',
      columns: [
        'id',
        'category_id',
        'title',
        'description',
        'start_date',
        'end_date',
        'passcode',
        'waiver',
        'status',
      ],
      where: 'id = ?',
      whereArgs: [surveyId],
    );

    /// Query db survey detail where id
    List<Map<String, dynamic>> dbSurveyDetail = await db.query(
      'survey_detail',
      columns: ['id', 'survey_id', 'language_id'],
      where: 'id = ?',
      whereArgs: [detailsId],
    );

    if (dbQuestionnaire.isNotEmpty && dbSurvey.isNotEmpty && dbSurveyDetail.isNotEmpty) {
      var survey = dbSurvey.first;
      var surveyDetail = dbSurveyDetail.first;

      /// Query db category where id
      List<Map<String, dynamic>> dbCategory = await db.query(
        'category',
        columns: ['id', 'name', 'image'],
        where: 'id = ?',
        whereArgs: [survey['category_id']],
      );

      /// Query db language where id
      List<Map<String, dynamic>> dbLanguage = await db.query(
        'language',
        columns: ['id', 'name'],
        where: 'id = ?',
        whereArgs: [surveyDetail['language_id']],
      );

      if (dbCategory.isNotEmpty && dbLanguage.isNotEmpty) {
        final newSurvey = Map.of(survey);
        newSurvey['category'] = dbCategory.first;

        final newSurveyDetail = Map.of(surveyDetail);
        newSurveyDetail['survey'] = newSurvey;
        newSurveyDetail['language'] = dbLanguage.first;

        List<Questionnaire> questionnaires = dbQuestionnaire.map((e) {
          final newQuestionnaire = Map.of(e);
          newQuestionnaire['survey'] = newSurvey;
          newQuestionnaire['survey_detail'] = newSurveyDetail;

          return Questionnaire.fromJson(newQuestionnaire);
        }).toList();

        result = questionnaires;
      }
    }

    return result.toList();
  }

  /// Get dropdown data [provinces, cities, barangays, courses, schools]
  Future<List<Dropdown>> getDropdownData({
    required String endpoint,
    String? filter,
    String? query,
  }) async {
    final db = await _dbService.database;
    String tableName = "";
    List<Map<String, dynamic>> dbDropdown;

    switch (endpoint) {
      case "address/paginate/province":
        tableName = "province_dropdown";
        break;
      case "address/paginate/city":
        tableName = "city_dropdown";
        break;
      case "address/barangay":
        tableName = "barangay_dropdown";
        break;
      case "address/courses":
        tableName = "course_dropdown";
        break;
      case "address/schools":
        tableName = "school_dropdown";
        break;
      default:
        tableName = "";
    }

    if (filter != null && query == null) {
      /// Query db dropdown w/ filter only
      dbDropdown = await db.query(tableName,
        columns: ['id', 'label', 'value', 'filter'],
        where: 'filter = ?',
        whereArgs: [filter],
      );
    } else if (query != null && filter == null) {
      /// Query db dropdown w/ query only
      dbDropdown = await db.query(tableName,
        columns: ['id', 'label', 'value', 'filter'],
        where: 'label LIKE ?',
        whereArgs: ['%$query%'],
      );
    } else if (query != null && filter != null) {
      /// Query db dropdown w/ filter and query
      dbDropdown = await db.query(tableName,
        columns: ['id', 'label', 'value', 'filter'],
        where: 'filter = ? AND label LIKE ?',
        whereArgs: [filter, '%$query%'],
      );
    } else {
      /// Query db dropdown
      dbDropdown = await db.query(tableName,
        columns: ['id', 'label', 'value', 'filter'],
      );
    }

    return dbDropdown.map((e) => Dropdown.fromJson(e)).toList();
  }

  /// Submit response to local db
  Future<void> postSubmitLocalResponse({
    required Survey survey,
    required List<Questionnaire> questionnaires,
  }) async {
    final db = await _dbService.database;

    var surveyResponse = {
      'survey_id': survey.id,
      'detail_id': questionnaires[0].surveyDetail.id,
      'is_sent': 0,
    };

    int newSurveyResponseId = await db.insert(
      'survey_response',
      surveyResponse,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var question in questionnaires) {
      String file = question.response?.file ?? '';

      var newQuestionnaireResponse = {
        'survey_response_id': newSurveyResponseId,
        'question_id': question.id,
        'answer': _getQuestionResponse(question: question),
        'file': file,
      };

      await db.insert(
        'questionnaire_response',
        newQuestionnaireResponse,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      Functions.audioRename(from: 'PENDING', to: 'LOCAL');
    }
  }

  /// Get question response
  /// for type [OpenEnded, Dropdown, Ratings, DatePicker]
  /// @return answer: List<String>
  /// for type [MultipleChoice, TrueOrFalse]
  /// @return answer: {selected: List<String>, others: String}
  static String _getQuestionResponse({ required Questionnaire question }) {
    String otherResponse = question.response?.otherResponse ?? '';
    List<String> response = question.response?.responses ?? [];

    if ((!question.configs.multipleAnswer && !question.configs.canAddOthers &&
      question.type != "openEnded" && question.type != "dropdown") ||
      (question.type == "openEnded" && response.length == 1) ||
      (question.type == "dropdown" && response.length == 1) ||
      (question.configs.multipleAnswer && !question.configs.canAddOthers &&
      response.length == 1
    )) {
      return response[0];
    }

    if (question.configs.canAddOthers) {
      if (otherResponse == '' && response.length == 1) {
        return response[0];
      }
      if (otherResponse != '' && response.length == 1) {
        return jsonEncode({
          'selected': response[0],
          'others': otherResponse,
        });
      }
      if (otherResponse == '' && response.length > 1) {
        return json.encode(response);
      }

      return jsonEncode({
        'selected': response,
        'others': otherResponse,
      });
    }

    return json.encode(response);
  }
}
