import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/survey_response_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class SurveyApiProvider {
  /// Get survey with questionnaires
  Future<Surveys> getSurveyWithQuestionnaires({
    required int surveyId,
    required int languageId,
  }) async {
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
      _updateQuestionnaireRequiredNum(survey: result, question: question);
    }

    return result;
  }

  /// Post request submit survey responses
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
            answer: _getQuestionResponse(question: question),
            file: question.answer?.file ?? '',
          )).toList();
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
            value.file.toString(),
          ));
        }
      });

      var result = await request.send();
      Functions.audioRename(from: 'PENDING', to: 'DONE');
    } catch (error) {
      print(error);
    }
  }

  void _updateQuestionnaireRequiredNum({
    required Surveys survey,
    required Questions question,
  }) {
    int numOfRequired = survey.numOfRequired ?? 0;
    question.config.isRequired
      ? survey.numOfRequired = numOfRequired + 1
      : null;
  }

  /// Get question response
  /// for type [OpenEnded, Dropdown, Ratings, DatePicker]
  /// @return answer: List<String>
  /// for type [MultipleChoice, TrueOrFalse]
  /// @return answer: {selected: List<String>, others: String}
  static String _getQuestionResponse({ required Questions question }) {
    String otherAnswer = question.answer?.otherAnswer ?? '';
    List<String> answer = question.answer?.answers ?? [];

    if ((!question.config.multipleAnswer && !question.config.canAddOthers &&
      question.type != "openEnded" && question.type != "dropdown") ||
      (question.type == "openEnded" && answer.length == 1) ||
      (question.type == "dropdown" && answer.length == 1) ||
      (question.config.multipleAnswer && !question.config.canAddOthers &&
      answer.length == 1
    )) {
      return answer[0];
    }

    if (question.config.canAddOthers) {
      if (otherAnswer == '' && answer.length == 1) {
        return answer[0];
      }
      if (otherAnswer != '' && answer.length == 1) {
        return jsonEncode({
          'selected': answer[0],
          'others': otherAnswer,
        });
      }
      if (otherAnswer == '' && answer.length > 1) {
        return json.encode(answer);
      }

      return jsonEncode({
        'selected': answer,
        'others': otherAnswer,
      });
    }

    return json.encode(answer);
  }
}
