import 'package:kalahok_app/data/models/online/category_model.dart';
import 'package:kalahok_app/data/resources/online/category/category_api_provider.dart';

class CategoryRepository {
  final _provider = CategoryApiProvider();

  /// Getting all the categories/domains w/o surveys
  Future<List<Category>> getCategoryList() async {
    return _provider.getCategoryList();
  }

  /// Getting a category/domain w/ surveys
  Future<Category> getCategoryWithSurvey({ required int categoryId }) async {
    return _provider.getCategoryWithSurvey(categoryId: categoryId);
  }
}
