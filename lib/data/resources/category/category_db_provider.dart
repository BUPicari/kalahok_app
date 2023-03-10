import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/services/database_service.dart';

class CategoryDbProvider {
  final _dbService = DatabaseService.dbService;

  /// @usedFor: DB - get all categories
  /// @return: List of categories w/o surveys
  Future<List<Category>> getCategoryList() async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> result;

    result = await db.query('survey_category',
        columns: ['id', 'name', 'image']
    );

    return result.map((e) => Category.fromJson(e)).toList();
  }

  /// @usedFor: DB - get all active surveys of a category
  /// @return: The category w/ surveys
  Future<Category?> getCategoryWithSurvey({required int categoryId}) async {
    final db = await _dbService.database;

    List<Map<String, dynamic>> cat = await db.query('survey_category',
      columns: ['id', 'name', 'image'],
      where: 'id = ?',
      whereArgs: [categoryId],
    );

    if (cat.isNotEmpty) {
      Category result = Category.fromJson(cat.first);
      List<Surveys> catSurveys;

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
        where: 'category_id = ?',
        whereArgs: [result.id],
      );
      catSurveys = surveys.map((e) => Surveys.fromJson(e)).toList();
      result.surveys = catSurveys;

      return result;
    }

    return null;
  }
}
