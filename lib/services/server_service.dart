import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/data/models/server_url.dart';

class ServerService {
  static Future<void> initializeServer() async {
    String defaultBaseUrl = "https://www.bu-research.online/bosesko-api";
    String defaultApiKey = "BIBgAolNJodHxR95ghUnR2soX4JvzSSbIKWMo9IKg60";
    String updaterUrl = ApiConfig.updaterUrl;

    try {
      var url = Uri.parse(updaterUrl);
      http.Response response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        var responseBody = response.body;
        ServerUrl result = ServerUrl.fromJson(jsonDecode(responseBody));

        for (var payload in result.payloads) {
          if (payload.name == "url") {
            ApiConfig.baseUrl = payload.value;
          }

          if (payload.name == "api_key") {
            ApiConfig.apiKey = payload.value;
          }
        }
      } else {
        ApiConfig.baseUrl = defaultBaseUrl;
        ApiConfig.apiKey = defaultApiKey;
      }
    } catch (error) {
      print("Error: $error");
      ApiConfig.baseUrl = defaultBaseUrl;
      ApiConfig.apiKey = defaultApiKey;
    }
  }
}
