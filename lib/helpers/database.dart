import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:kalahok_app/data/models/survey_response_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/data/resources/survey/survey_api_provider.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/services/database_service.dart';

class DB {
  static final _dbService = DatabaseService.dbService;
  static final _apiProvider = SurveyApiProvider();

  static String dbName = 'Kalahok.db';

  static String surveyCategoryTable = "CREATE TABLE survey_category ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "name TEXT NOT NULL,"
    "image TEXT NOT NULL"
  ")";

  static String surveyTable = "CREATE TABLE survey ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "category_id INTEGER NOT NULL,"
    "title TEXT NOT NULL,"
    "description TEXT NOT NULL,"
    "waiver TEXT NOT NULL,"
    "completion_estimated_time TEXT DEFAULT '0' NOT NULL,"
    "status BOOLEAN DEFAULT 0 NOT NULL,"
    "multiple_submission BOOLEAN DEFAULT 0 NOT NULL,"
    "start_date TEXT NOT NULL,"
    "end_date TEXT NOT NULL,"
    "added_at TEXT NOT NULL,"
    "updated_at TEXT NOT NULL,"
    "FOREIGN KEY (category_id) REFERENCES survey_category (id)"
  ")";

  static String surveyQuestionnairesTable = "CREATE TABLE survey_questionnaires ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "survey_id INTEGER NOT NULL,"
    "question TEXT,"
    "type TEXT,"
    "choices TEXT,"
    "rates TEXT,"
    "labels TEXT,"
    "config TEXT,"
    "added_at TEXT NOT NULL,"
    "updated_at TEXT NOT NULL,"
    "FOREIGN KEY (survey_id) REFERENCES survey (id)"
  ")";

  static String surveyResponseTable = "CREATE TABLE survey_response ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "added_at TEXT NOT NULL,"
    "survey_id INTEGER NOT NULL,"
    "is_sent BOOLEAN DEFAULT 0 NOT NULL,"
    "FOREIGN KEY (survey_id) REFERENCES survey (id)"
  ")";

  static String surveyQuestionnairesResponsesTable = "CREATE TABLE survey_questionnaires_responses ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "answer TEXT,"
    "file TEXT,"
    "survey_response_id INTEGER NOT NULL,"
    "question_id INTEGER NOT NULL,"
    "added_at TEXT NOT NULL,"
    "FOREIGN KEY (survey_response_id) REFERENCES survey_response (id),"
    "FOREIGN KEY (question_id) REFERENCES survey_questionnaires (id)"
  ")";

  /// Get all the !is_sent from "survey_response" and then do a post api request
  static void submitLocalResponsesToApi() async {
    print("*** submitLocalResponsesToApi ***");
    final db = await _dbService.database;

    List<Map<String, dynamic>> surveysResponses = await db.query('survey_response',
      columns: [
        'id',
        'added_at',
        'survey_id',
        'is_sent',
      ],
      where: 'is_sent = ?',
      whereArgs: [false],
    );

    if (surveysResponses.isNotEmpty) {
      List<ResponseQuestionnaires> responses = [];
      for (var item in surveysResponses) {
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
          whereArgs: [item['survey_id']],
        );
        Surveys survey = Surveys.fromJson(surveys.first);

        List<Map<String, dynamic>> surveyQuestionnairesResponses = await db.query('survey_questionnaires_responses',
          columns: [
            'id',
            'answer',
            'file',
            'survey_response_id',
            'question_id',
            'added_at',
          ],
          where: 'survey_response_id = ?',
          whereArgs: [item['id']],
        );

        if (surveyQuestionnairesResponses.isNotEmpty) {
          responses = surveyQuestionnairesResponses.map((e) =>
            ResponseQuestionnaires(
              questionnaireId: e['question_id'],
              answer: e['answer'],
              file: e['file'],
          )).toList();

          _apiProvider.postSubmitSurveyResponse(
            survey: survey,
            responses: responses
          );

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: 'bosesko_channel',
              title: 'BosesKo Notification',
              body: 'Done Syncing Local Responses to Server',
            ),
          );

          Utils.audioRename(from: 'SUBMITTED', to: 'DONE');
        }
      }
    }
  }

  /// Get all the !is_sent from "survey_response" and then make it is_sent
  static void isSentSurveyFromFalseToTrue() async {
    print("*** isSentSurveyFromFalseToTrue ***");
    final db = await _dbService.database;

    await db.update('survey_response',
      {'is_sent': 1},
      where: 'is_sent = ?',
      whereArgs: [false],
    );
  }
}
