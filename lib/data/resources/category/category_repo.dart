import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/category_survey_model.dart';
import 'package:kalahok_app/data/resources/category/category_api_provider.dart';
import 'package:kalahok_app/data/resources/category/category_db_provider.dart';
import 'package:kalahok_app/helpers/utils.dart';

class CategoryRepository {
  final _apiProvider = CategoryApiProvider();
  final _dbProvider = CategoryDbProvider();

  Future<List<Category>> getCategoryList() async {
    if (await Utils.hasInternetConnection) return _apiProvider.getCategoryList();
    return _dbProvider.getCategoryList();
  }

  Future<CategorySurvey> getCategorySurvey({required int categoryId}) async {
    // if (await Utils.hasInternetConnection) return _apiProvider.getCategorySurvey(categoryId: categoryId);
    // return _dbProvider.getCategorySurvey(categoryId: categoryId);
    return _apiProvider.getCategorySurvey(categoryId: categoryId);
  }
}
