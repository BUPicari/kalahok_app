class DB {
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
}
