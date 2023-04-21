import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/survey_response_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
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
    List<Questions> questionnaires = result.questionnaires ?? [];

    for (var question in questionnaires) {
      Utils.updateQuestionnaireRequiredNum(survey: result, question: question);
    }

    for (var item in questionnaires) {
      item.surveyId = surveyId;
      /// From api insert to local db
      await db.insert(
        'survey_questionnaires',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }

    /// todo: get question type dropdown and api get request all the data and save to sqlite(as json para dynamic???)

    return result;
  }

  /// @usedFor: API - post request submit survey responses
  Future<void> postSubmitSurveyResponse({
    required Surveys survey,
    List<ResponseQuestionnaires>? responses,
  }) async {
    var path = '/survey/responses';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    final headers = {"Content-type": "application/json"};

    List<ResponseQuestionnaires> questionnaires = [];

    if (responses != null) {
      questionnaires = responses;
    } else {
      questionnaires = survey.questionnaires!.map((question) =>
        ResponseQuestionnaires(
          questionnaireId: question.id,
          answer: Utils.getQuestionResponse(question: question),
        ))
        .toList();
    }

    var surveyResponse = <Map<String, dynamic>>[
      SurveyResponse(
        surveyId: survey.id,
        questionnaires: questionnaires,
      ).toJson(),
    ];

    print(json.encode(surveyResponse));

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(surveyResponse),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
