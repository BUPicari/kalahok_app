import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/category_survey_model.dart';
import 'package:kalahok_app/data/resources/category/category_provider.dart';

class CategoryRepository {
  final _provider = CategoryProvider();

  Future<List<Category>> getCategoryList() {
    return _provider.getCategoryList();
  }

  Future<CategorySurvey> getCategorySurvey({required int categoryId}) {
    return _provider.getCategorySurvey(categoryId: categoryId);
  }
}

class NetworkError extends Error {}
