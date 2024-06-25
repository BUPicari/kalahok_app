import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kalahok_app/data/models/server_url.dart';
import 'package:kalahok_app/helpers/variables.dart';

class ServerService {
  static Future<void> initializeServer() async {
    String defaultBaseUrl = "https://chedlakas.mab.com.ph:8001";
    String defaultApiKey = "vTZiBkM3GZniy45jf14V_Mpdvm43enyIzW61NAuzZTc";
    String updaterUrl = ApiConfig.updaterUrl;

    if (updaterUrl != "") {
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
    } else {
      ApiConfig.baseUrl = defaultBaseUrl;
      ApiConfig.apiKey = defaultApiKey;
    }
  }
}
