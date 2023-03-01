class DB {
  static String name = 'kalahok.db';
  static String table = '''
    create table survey (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      url TEXT
    )
  ''';
}
