import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/constants/constants.dart';

class GetLatestNews {
  static Future<List<Map<String, dynamic>>> getData() async {
    var url = Uri.https(
      Constants.url,
      Constants.path,
      Constants.queryParameters,
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['results'] != null) {
          final List<Map<String, dynamic>> resultList =
              List<Map<String, dynamic>>.from(decoded['results']);
          resultList.add({"nextPage": decoded["nextPage"]});
          return resultList;
        }
      } else {
        print("API Error for ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (err) {
      print("Network Error for $err");
    }
    return Constants.fallBackData;
  }

  static Future<List<Map<String, dynamic>>> getDataForRow(
    String nextPage,
  ) async {
    var queryParameters = Constants.queryParameters;
    queryParameters['page'] = nextPage;
    var url = Uri.https(Constants.url, Constants.path, queryParameters);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['results'] != null) {
          final List<Map<String, dynamic>> resultList =
              List<Map<String, dynamic>>.from(decoded['results']);
          resultList.add({"nextPage": decoded["nextPage"]});
          return resultList;
        }
      } else {
        print("API Error for ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (err) {
      print("Network Error for $err");
    }
    return Constants.fallBackData;
  }
}
