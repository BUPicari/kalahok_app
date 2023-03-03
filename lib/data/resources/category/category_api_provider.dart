import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/category_survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/database_service.dart';

class CategoryApiProvider {
  final _dbService = DatabaseService.dbService;

  /// API - get all categories
  Future<List<Category>> getCategoryList() async {
    final db = await _dbService.database;
    var path = '/survey/categories/all';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(url);
    var categoriesJson = jsonDecode(response.body) as List;
    List<Category> result = categoriesJson.map((e) =>
        Category.fromJson(e)).toList();
    for (var data in result) {
      int? exists = await _dbService.isDataExists(
          tableName: 'survey_category',
          column: 'id',
          data: data.id,
      );
      if (exists == null) await db.insert('survey_category', data.toJson());
    }

    return result;
  }

  /// API - get all active surveys of a category
  Future<CategorySurvey> getCategorySurvey({required int categoryId}) async {
    var path = '/survey/categories/$categoryId/surveys';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(url);
    /// todo: add here sync from api to db

    return CategorySurvey.fromJson(jsonDecode(response.body));
  }
}
