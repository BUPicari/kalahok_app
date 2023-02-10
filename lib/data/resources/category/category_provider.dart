import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/category_survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';

class CategoryProvider {
  Future<List<Category>> getCategoryList() async {
    var path = '/survey/categories/all';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    http.Response response = await http.get(url);

    var categoriesJson = jsonDecode(response.body) as List;
    return categoriesJson.map((e) => Category.fromJson(e)).toList();
  }

  Future<CategorySurvey> getCategorySurvey({required int categoryId}) async {
    var path = '/survey/categories/$categoryId/surveys';
    var url = Uri.parse(ApiConfig.baseUrl + path);
    http.Response response = await http.get(url);

    return CategorySurvey.fromJson(jsonDecode(response.body));
  }
}
