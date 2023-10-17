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
  Future<Surveys> getSurveyWithQuestionnaires({
    required int surveyId,
    required int languageId,
  }) async {
    final db = await _dbService.database;
    var path = '/surveys/fetch/$surveyId?langId=$languageId';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var responseBody = response.body;

    if (responseBody.contains("message")) {
      return Surveys(
        id: 0,
        title: "none",
        description: "none",
        startDate: "none",
        endDate: "none",
      );
    }

    Surveys result = Surveys.fromJson(jsonDecode(responseBody));
    List<Questions> questionnaires = result.questionnaires ?? [];

    for (var question in questionnaires) {
      Utils.updateQuestionnaireRequiredNum(survey: result, question: question);
    }

    // for (var item in questionnaires) {
    //   item.surveyId = surveyId;
    //   /// From api insert to local db
    //   await db.insert(
    //     'survey_questionnaires',
    //     item.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.replace
    //   );
    // }

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

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['X-Requested-With'] = "XMLHttpRequest";
      request.headers['x-api-key'] = ApiConfig.apiKey;

      List<ResponseQuestionnaires> questionnaires = [];

      if (responses != null) {
        questionnaires = responses;
      } else {
        questionnaires = survey.questionnaires!.map((question) =>
          ResponseQuestionnaires(
            questionnaireId: question.id,
            answer: Utils.getQuestionResponse(question: question),
            file: question.answer?.file ?? '',
          ))
          .toList();
      }

      SurveyResponse surveyResponse = SurveyResponse(
        surveyId: survey.id,
        detailsId: survey.detailsId ?? 0,
        questionnaires: questionnaires,
      );

      request.fields['survey_id'] = surveyResponse.surveyId.toString();
      request.fields['detailsId'] = surveyResponse.detailsId.toString();
      surveyResponse.questionnaires.asMap().forEach((index, value) async {
        request.fields['questionnaires[$index][questionnaire_id]'] =
            value.questionnaireId.toString();
        request.fields['questionnaires[$index][answer]'] = value.answer;
        if (value.file != '') {
          request.files.add(await http.MultipartFile.fromPath(
            'questionnaires[$index][files]-${value.questionnaireId}',
            value.file.toString()
          ));
        }
      });

      var result = await request.send();
      Utils.audioRename(from: 'PENDING', to: 'DONE');
    } catch (error) {
      print(error);
    }

    /// Former way of sending to api
    // final headers = {"Content-type": "application/json"};
    //
    // List<ResponseQuestionnaires> questionnaires = [];
    //
    // if (responses != null) {
    //   questionnaires = responses;
    // } else {
    //   questionnaires = survey.questionnaires!.map((question) =>
    //     ResponseQuestionnaires(
    //       questionnaireId: question.id,
    //       answer: Utils.getQuestionResponse(question: question),
    //     ))
    //     .toList();
    // }
    //
    // var surveyResponse = <Map<String, dynamic>>[
    //   SurveyResponse(
    //     surveyId: survey.id,
    //     questionnaires: questionnaires,
    //   ).toJson(),
    // ];
    //
    // print(json.encode(surveyResponse));
    //
    // http.Response response = await http.post(
    //   url,
    //   headers: headers,
    //   body: json.encode(surveyResponse),
    // );
    //
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  }
}
