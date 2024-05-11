import 'package:kalahok_app/data/resources/offline/api_to_db_provider.dart';

/// CHECKED
class ApiToDbRepository {
  final _provider = ApiToDbProvider();

  Future<void> insertAllDataFromApiToLocalDB() async {
    await _provider.insertData();
    // await _provider.getAddressesDropdown();
    await _provider.getCoursesDropdown();
    await _provider.getSchoolsDropdown(page: 1);
  }
}
