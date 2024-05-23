import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kalahok_app/data/models/online/category_model.dart';
import 'package:kalahok_app/helpers/variables.dart';

/// CHECKED
class CategoryApiProvider {
  /// Get all categories
  Future<List<Category>> getCategoryList() async {
    var path = '/domains/all/with-active-survey-only';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var categoriesJson = jsonDecode(response.body) as List;

    List<Category> result = categoriesJson.map((e) =>
      Category.fromJson(e)).toList();

    return result;
  }

  /// Get all active surveys of a category
  Future<Category> getCategoryWithSurvey({ required int categoryId }) async {
    var path = '/domains/$categoryId/surveys';
    var url = Uri.parse(ApiConfig.baseUrl + path);

    http.Response response = await http.get(
      url,
      headers: {'x-api-key': ApiConfig.apiKey},
    );
    var responseBody = response.body;

    if (responseBody.contains("message")) {
      return Category(id: 0, name: "none", image: "none");
    }

    Category result = Category.fromJson(jsonDecode(responseBody));

    return result;
  }
}
