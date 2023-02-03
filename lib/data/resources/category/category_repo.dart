import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/resources/category/category_provider.dart';

class CategoryRepository {
  final _provider = CategoryProvider();

  Future<List<Category>> getCategoryList() {
    return _provider.getCategoryList();
  }
}

class NetworkError extends Error {}
