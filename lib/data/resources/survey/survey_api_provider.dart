import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/models/survey_response_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class SurveyApiProvider {
  final _dbService = DatabaseService.dbService;

  /// @usedFor: API - get survey with questionnaires
  /// @return: Survey w/ questionnaires
  Future<Surveys> getSurveyWithQuestionnaires({required int surveyId}) async {
    final db = await _dbService.database;
    var path = '/surveys/fetch/$surveyId';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    http.Response response = await http.get(url);

    Surveys result = Surveys.fromJson(jsonDecode(response.body));

    /// todo: put this back if questions w/ db is already ok
    // for (var question in result.questionnaires) {
    //   if (question.config.isRequired) {
    //     var num = result.numOfRequired?.toInt() ?? 0;
    //     result.numOfRequired = num + 1;
    //   }
    // }

    if (result.questionnaires != null) {
      result.questionnaires?.forEach((element) async {
        element.surveyId = surveyId;
        await db.insert(
          'survey_questionnaires',
          element.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      });
    }

    return result;
  }

  Future<void> postSubmitSurveyResponse({required Survey survey}) async {
    var path = '/survey/responses';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    final headers = {"Content-type": "application/json"};

    List<Questionnaires> questionnaires = survey.questionnaires
        .map((question) => Questionnaires(
              questionnaireId: question.id,
              answer: question.getAnswer(),
            ))
        .toList();

    var surveyResponse = <Map<String, dynamic>>[
      SurveyResponse(
        surveyId: survey.id,
        questionnaires: questionnaires,
      ).toJson(),
    ];

    print(surveyResponse);

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(surveyResponse),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
