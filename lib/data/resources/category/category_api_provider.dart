import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class CategoryApiProvider {
  final _dbService = DatabaseService.dbService;

  /// @usedFor: API - get all categories
  /// @return: List of categories w/o surveys
  Future<List<Category>> getCategoryList() async {
    final db = await _dbService.database;
    var path = '/survey/categories/all';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var categoriesJson = jsonDecode(response.body) as List;
    List<Category> result = categoriesJson.map((e) =>
        Category.fromJson(e)).toList();
    for (var element in result) {
      /// From api insert to local db
      await db.insert(
        'survey_category',
        element.toJson(), /// w/o surveys
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return result;
  }

  /// @usedFor: API - get all active surveys of a category
  /// @return: The category w/ surveys
  Future<Category> getCategoryWithSurvey({required int categoryId}) async {
    final db = await _dbService.database;
    var path = '/survey/categories/$categoryId/surveys';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    Category result = Category.fromJson(jsonDecode(response.body));

    if (result.surveys != null) {
      result.surveys?.forEach((element) async {
        element.categoryId = categoryId;
        /// From api insert to local db
        await db.insert(
          'survey',
          element.toJson(), /// w/ surveys
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      });
    }

    return result;
  }
}
