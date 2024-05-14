/// CHECKED
class DB {
  static String dbName = 'bosesko.db';

  static String categoryTable = "CREATE TABLE category ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "name TEXT NOT NULL,"
    "image TEXT NOT NULL"
  ")";

  static String surveyTable = "CREATE TABLE survey ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "category_id INTEGER NOT NULL,"
    "title TEXT NOT NULL,"
    "description TEXT NOT NULL,"
    "start_date TEXT NOT NULL,"
    "end_date TEXT NOT NULL,"
    "passcode TEXT,"
    "waiver TEXT,"
    "status BOOLEAN DEFAULT 0 NOT NULL,"
    "FOREIGN KEY (category_id) REFERENCES category (id)"
  ")";

  static String languageTable = "CREATE TABLE language ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "name TEXT NOT NULL"
  ")";

  static String surveyDetailTable = "CREATE TABLE survey_detail ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "survey_id INTEGER NOT NULL,"
    "language_id INTEGER NOT NULL,"
    "FOREIGN KEY (survey_id) REFERENCES survey (id),"
    "FOREIGN KEY (language_id) REFERENCES language (id)"
  ")";

  static String questionnairesTable = "CREATE TABLE questionnaire ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "survey_id INTEGER NOT NULL,"
    "detail_id INTEGER NOT NULL,"
    "question TEXT,"
    "type TEXT,"
    "choices TEXT,"
    "configs TEXT,"
    "labels TEXT,"
    "rates TEXT,"
    "FOREIGN KEY (survey_id) REFERENCES survey (id),"
    "FOREIGN KEY (detail_id) REFERENCES survey_detail (id)"
  ")";

  static String provinceDropdown = "CREATE TABLE province_dropdown ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "label TEXT NOT NULL,"
    "value TEXT NOT NULL,"
    "filter TEXT"
  ")";

  static String cityDropdown = "CREATE TABLE city_dropdown ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "label TEXT NOT NULL,"
    "value TEXT NOT NULL,"
    "filter TEXT"
  ")";

  static String barangayDropdown = "CREATE TABLE barangay_dropdown ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "label TEXT NOT NULL,"
    "value TEXT NOT NULL,"
    "filter TEXT"
  ")";

  static String courseDropdown = "CREATE TABLE course_dropdown ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "label TEXT NOT NULL,"
    "value TEXT NOT NULL,"
    "filter TEXT"
  ")";

  static String schoolDropdown = "CREATE TABLE school_dropdown ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "label TEXT NOT NULL,"
    "value TEXT NOT NULL,"
    "filter TEXT"
  ")";

  static String surveyResponseTable = "CREATE TABLE survey_response ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "survey_id INTEGER NOT NULL,"
    "detail_id INTEGER NOT NULL,"
    "is_sent BOOLEAN DEFAULT 0 NOT NULL,"
    "FOREIGN KEY (survey_id) REFERENCES survey (id),"
    "FOREIGN KEY (detail_id) REFERENCES survey_detail (id)"
  ")";

  static String questionnaireResponseTable = "CREATE TABLE questionnaire_response ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "survey_response_id INTEGER NOT NULL,"
    "question_id INTEGER NOT NULL,"
    "answer TEXT,"
    "file TEXT,"
    "FOREIGN KEY (survey_response_id) REFERENCES survey_response (id),"
    "FOREIGN KEY (question_id) REFERENCES survey_questionnaires (id)"
  ")";
}
