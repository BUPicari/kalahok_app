import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/database.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class SurveyDbProvider {
  final _dbService = DatabaseService.dbService;

  /// @usedFor: DB - get survey with questionnaires
  /// @return: Survey w/ questionnaires
  Future<Surveys?> getSurveyWithQuestionnaires({required int surveyId}) async {
    final db = await _dbService.database;

    List<Map<String, dynamic>> surveys = await db.query('survey',
      columns: [
        'id',
        'category_id',
        'title',
        'description',
        'waiver',
        'completion_estimated_time',
        'status',
        'multiple_submission',
        'start_date',
        'end_date',
        'added_at',
        'updated_at'
      ],
      where: 'id = ?',
      whereArgs: [surveyId],
    );

    if (surveys.isNotEmpty) {
      Surveys result = Surveys.fromJson(surveys.first);
      List<Questions> surveyQuestionnaires;

      List<Map<String, dynamic>> questionnaires = await db.query('survey_questionnaires',
        columns: [
          'id',
          'survey_id',
          'question',
          'type',
          'choices',
          'rates',
          'labels',
          'config',
          'added_at',
          'updated_at'
        ],
        where: 'survey_id = ?',
        whereArgs: [result.id],
      );
      surveyQuestionnaires = questionnaires.map((e) => Questions.fromJson(e)).toList();
      result.questionnaires = surveyQuestionnaires;

      surveyQuestionnaires.map((question)
        => Utils.updateQuestionnaireRequiredNum(survey: result, question: question)
      );

      return result;
    }

    return null;
  }

  /// @usedFor: DB - insert to local db the survey responses
  Future<void> postSubmitSurveyResponse({required Surveys survey}) async {
    final db = await _dbService.database;

    var surveyResponse = {
      'added_at': DateTime.now().toString(),
      'survey_id': survey.id,
      'is_sent': 0,
    };

    int newSurveyResponseId = await db.insert(
      'survey_response',
      surveyResponse,
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    List<Questions> questionnaires = survey.questionnaires ?? [];

    for (var question in questionnaires) {
      var surveyQuestionnairesResponses = {
        'answer': Utils.getQuestionResponse(question: question),
        'file': null,
        'survey_response_id': newSurveyResponseId,
        'question_id': question.id,
        'added_at': DateTime.now().toString(),
      };

      await db.insert(
        'survey_questionnaires_responses',
        surveyQuestionnairesResponses,
        conflictAlgorithm: ConflictAlgorithm.replace
      );

      Utils.audioRename(from: 'PENDING', to: 'SUBMITTED');
    }

    if (await Utils.hasInternetConnection) {
      DB.submitLocalResponsesToApi();
      DB.isSentSurveyFromFalseToTrue();
    }
  }
}
