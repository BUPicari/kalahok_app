import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/services/database_service.dart';

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

      return result;
    }

    return null;
  }
}
