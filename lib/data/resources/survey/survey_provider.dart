import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/configs/api_config.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/models/survey_response_model.dart';

class SurveyProvider {
  Future<Survey> getSurveyList({required int categoryId}) async {
    var path = '/surveys/current-active?category=$categoryId&format-date=true';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    http.Response response = await http.get(url);

    return Survey.fromJson(jsonDecode(response.body));
  }

  Future<void> postSubmitSurveyResponse({required Survey survey}) async {
    var path = '/survey/responses';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    final headers = {"Content-type": "application/json"};

    List<Questionnaires> questionnaires = survey.questionnaires
        .map((question) => Questionnaires(
              questionnaireId: question.id,
              // answer: question.response.toString(),
              answer: question.getAnswer(),
            ))
        .toList();

    var surveyResponse = <Map<String, dynamic>>[
      SurveyResponse(
        surveyId: 1,
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
