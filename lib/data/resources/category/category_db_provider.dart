import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/services/database_service.dart';

class CategoryDbProvider {
  final _dbService = DatabaseService.dbService;

  /// DB - get all categories
  Future<List<Category>> getCategoryList() async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> result;

    result = await db.query('survey_category',
        columns: ['id', 'name', 'image']
    );
    return result.map((e) => Category.fromJson(e)).toList();
  }
}
