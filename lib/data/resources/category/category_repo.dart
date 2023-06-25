import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/resources/category/category_api_provider.dart';
import 'package:kalahok_app/data/resources/category/category_db_provider.dart';
import 'package:kalahok_app/helpers/utils.dart';

class CategoryRepository {
  final _apiProvider = CategoryApiProvider();
  final _dbProvider = CategoryDbProvider();

  /// @usedFor: Getting all the categories/domains w/o surveys
  /// @return: If has internet connection get data using api else local db
  Future<List<Category>> getCategoryList() async {
    if (await Utils.hasInternetConnection) return _apiProvider.getCategoryList();
    return _dbProvider.getCategoryList();
  }

  /// @usedFor: Getting a category/domain w/ surveys
  /// @return: If has internet connection get data using api else local db
  Future<Category?> getCategoryWithSurvey({required int categoryId}) async {
    if (await Utils.hasInternetConnection) return _apiProvider.getCategoryWithSurvey(categoryId: categoryId);
    return _dbProvider.getCategoryWithSurvey(categoryId: categoryId);
  }
}
