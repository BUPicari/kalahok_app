import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'package:kalahok_app/data/models/offline/api/category_with_surveys_and_details.dart';
import 'package:kalahok_app/data/models/offline/api/survey_with_questionnaires_model.dart';
import 'package:kalahok_app/data/models/offline/category.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/database_service.dart';

/// CHECKED
class ApiToDbProvider {
  final _dbService = DatabaseService.dbService;

  Future<void> insertData() async {
    await _insertCategories();
  }

  Future<void> _insertCategories() async {
    final db = await _dbService.database;
    var path = '/survey/categories/all/with-active-survey-only';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var jsonResponse = jsonDecode(response.body) as List;

    List<Category> categories = jsonResponse.map((e) =>
      Category.fromJson(e)).toList();

    for (var category in categories) {
      /// Add the category
      await db.insert(
        'category',
        category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      /// Call the next API
      await _insertSurveys(categoryId: category.id);
    }
  }

  Future<void> _insertSurveys({ required int categoryId }) async {
    final db = await _dbService.database;
    var path = '/survey/categories/$categoryId/surveys';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var responseBody = response.body;

    CategoryWithSurveysAndDetails category =
      CategoryWithSurveysAndDetails.fromJson(jsonDecode(responseBody));

    for (var survey in category.surveys) {
      /// Add the survey
      var json = {
        "id": survey.id,
        "category_id": category.id,
        "title": survey.title,
        "description": survey.description,
        "start_date": survey.startDate,
        "end_date": survey.endDate,
        "passcode": survey.passcode,
      };
      await db.insert(
        'survey',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var detail in survey.details) {
        /// Add the language
        await _insertLanguage(language: detail.language);

        /// Add the survey detail
        await _insertSurveyDetail(detail: detail, survey: survey);

        /// Call the next API
        await _insertQuestionnaires(
          surveyId: survey.id,
          detailsId: detail.id,
        );
      }
    }
  }

  Future<void> _insertLanguage({
    required LanguageInCategoryWithSurveysAndDetails language,
  }) async {
    final db = await _dbService.database;

    /// Add the language
    await db.insert(
      'language',
      language.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertSurveyDetail({
    required DetailsInCategoryWithSurveysAndDetails detail,
    required SurveysInCategoryWithSurveysAndDetails survey,
  }) async {
    final db = await _dbService.database;

    /// Add the survey detail
    var surveyDetail = {
      "id": detail.id,
      "survey_id": survey.id,
      "language_id": detail.language.id,
    };

    await db.insert(
      'survey_detail',
      surveyDetail,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _updateSurvey({
    required SurveyWithQuestionnaires survey,
  }) async {
    final db = await _dbService.database;

    /// Update the survey
    var json = {
      "waiver": survey.waiver,
      "status": survey.status,
    };
    await db.update(
      'survey',
      json,
      where: 'id = ?',
      whereArgs: [survey.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertQuestionnaires({
    required int surveyId,
    required int detailsId,
  }) async {
    final db = await _dbService.database;
    var path = '/surveys/fetch/$surveyId?langId=$detailsId';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var responseBody = response.body;

    SurveyWithQuestionnaires survey =
      SurveyWithQuestionnaires.fromJson(jsonDecode(responseBody));

    /// Update the survey
    await _updateSurvey(survey: survey);

    for (var questionnaire in survey.questionnaires) {
      /// Add the questionnaire
      var tempQuestionnaire = {
        "id": questionnaire.id,
        "survey_id": survey.id,
        "detail_id": survey.detailsId,
        "question": questionnaire.question,
        "type": questionnaire.type,
        "choices": jsonEncode(questionnaire.choices),
        "configs": jsonEncode(questionnaire.configs),
        "labels": jsonEncode(questionnaire.labels),
        "rates": jsonEncode(questionnaire.rates),
      };
      await db.insert(
        'questionnaire',
        tempQuestionnaire,
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
  }

  Future<void> getAddressesDropdown() async {
    final db = await _dbService.database;

    /// Province Dropdown
    var provincePath = '/address/paginate/province';
    var provinceUrl = Uri.parse(ApiConfig.baseUrl + provincePath);
    var pResIndex = 1;
    var cResIndex = 1;
    var bResIndex = 1;

    http.Response provinceResponse = await http.get(
      provinceUrl,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var provinceResponseBody = provinceResponse.body;

    DropdownInSurveyWithQuestionnaires provinceResult =
      DropdownInSurveyWithQuestionnaires.fromJson(jsonDecode(provinceResponseBody));

    for (var pRes in provinceResult.result) {
      /// Add the province dropdown
      var provinceDropdown = {
        "id": pResIndex,
        "label": pRes.label,
        "value": pRes.value,
      };
      await db.insert(
        'province_dropdown',
        provinceDropdown,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      /// City Dropdown
      var cityPath = '/address/paginate/city?filter=${pRes.value}';
      var cityUrl = Uri.parse(ApiConfig.baseUrl + cityPath);
      http.Response cityResponse = await http.get(
        cityUrl,
        headers: {'x-api-key': ApiConfig.apiKey},
      );
      var cityResponseBody = cityResponse.body;

      DropdownInSurveyWithQuestionnaires cityResult =
        DropdownInSurveyWithQuestionnaires.fromJson(jsonDecode(cityResponseBody));

      for (var cRes in cityResult.result) {
        /// Add the city dropdown
        var cityDropdown = {
          "id": cResIndex,
          "label": cRes.label,
          "value": cRes.value,
          "filter": pRes.value,
        };
        await db.insert(
          'city_dropdown',
          cityDropdown,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        /// Barangay Dropdown
        var barangayPath = '/address/barangay?filter=${cRes.value}';
        var barangayUrl = Uri.parse(ApiConfig.baseUrl + barangayPath);
        http.Response barangayResponse = await http.get(
          barangayUrl,
          headers: {'x-api-key': ApiConfig.apiKey},
        );
        var barangayResponseBody = barangayResponse.body;

        DropdownInSurveyWithQuestionnaires barangayResult =
          DropdownInSurveyWithQuestionnaires.fromJson(jsonDecode(barangayResponseBody));

        for (var bRes in barangayResult.result) {
          /// Add the barangay dropdown
          var barangayDropdown = {
            "id": bResIndex,
            "label": bRes.label,
            "value": bRes.value,
            "filter": cRes.value,
          };
          await db.insert(
            'barangay_dropdown',
            barangayDropdown,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          bResIndex++;
        }
        cResIndex++;
      }
      pResIndex++;
    }
  }

  Future<void> getCoursesDropdown() async {
    final db = await _dbService.database;

    /// Course Dropdown
    var coursePath = '/address/courses';
    var courseUrl = Uri.parse(ApiConfig.baseUrl + coursePath);
    var crResIndex = 1;

    http.Response courseResponse = await http.get(
      courseUrl,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var courseResponseBody = courseResponse.body;

    DropdownInSurveyWithQuestionnaires courseResult =
      DropdownInSurveyWithQuestionnaires.fromJson(jsonDecode(courseResponseBody));

    for (var crRes in courseResult.result) {
      /// Add the course dropdown
      var courseDropdown = {
        "id": crResIndex,
        "label": crRes.label,
        "value": crRes.value,
      };
      await db.insert(
        'course_dropdown',
        courseDropdown,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      crResIndex++;
    }
  }

  Future<void> getSchoolsDropdown({ required int page, int index = 1 }) async {
    final db = await _dbService.database;

    /// School Dropdown
    var schoolPath = "/address/schools?page=$page";
    var schoolUrl = Uri.parse(ApiConfig.baseUrl + schoolPath);
    var scResIndex = index;

    http.Response schoolResponse = await http.get(
      schoolUrl,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var schoolResponseBody = schoolResponse.body;

    DropdownInSurveyWithQuestionnaires schoolResult =
      DropdownInSurveyWithQuestionnaires.fromJson(jsonDecode(schoolResponseBody));

    for (var scRes in schoolResult.result) {
      /// Add the school dropdown
      var schoolDropdown = {
        "id": scResIndex,
        "label": scRes.label,
        "value": scRes.value,
      };
      await db.insert(
        'school_dropdown',
        schoolDropdown,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      scResIndex++;
    }

    if (schoolResult.hasMore == 1) {
      getSchoolsDropdown(page: page + 1, index: scResIndex);
    }
  }
}
