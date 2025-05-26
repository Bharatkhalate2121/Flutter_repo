import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/constants/constants.dart';
import 'package:news_app/context/context_class.dart';

class GetRelevantNews {
  static Future<List<Map<String, dynamic>>> getData({
    required String category,
  }) async {
    try {
      var endpoint = Uri.https(Constants.url, Constants.path, {
        ...Constants.queryParameters,
        'category': category,
      });
      print("API called for category: $category");
      var response = await http.get(endpoint);
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['results'] != null) {
          final List<Map<String, dynamic>> _releventNewsData =
              List<Map<String, dynamic>>.from(decoded['results']);
          if (decoded['nextPage'] != null) {
            _releventNewsData.add({"nextPage": decoded['nextPage']});
          }
          _releventNewsData.removeWhere((map) {
            return (map.containsKey("article_id") &&
                map["article_id"] == ContextClass.instance.current);
          });
          return _releventNewsData;
        }
      } else {
        print("Failed to fetch data: ${response.body}");
      }
    } catch (err) {
      print("Error occurred: $err");
    }

    // Fallback sample data
    return Constants.fallBackData;
  }

  static Future<List<Map<String, dynamic>>> getNextData({
    required String category,
    required String nextPage,
  }) async {
    print("inside get nextData");
    print(category+" "+nextPage);
    try {
      var endpoint = Uri.https(Constants.url, Constants.path, {
        ...Constants.queryParameters,
        "category": category,
        "page": nextPage,
      });
      var response = await http.get(endpoint);
      print("Fetching next page: $nextPage");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['results'] != null) {
          final List<Map<String, dynamic>> _releventNewsData =
              List<Map<String, dynamic>>.from(decoded['results']);
          if (decoded['nextPage'] != null) {
            _releventNewsData.add({"nextPage": decoded['nextPage']});
          }
          _releventNewsData.removeWhere((map) {
            return (map.containsKey("article_id") &&
                map["article_id"] == ContextClass.instance.current);
          });
          return _releventNewsData;
        }
      } else {
        print("Failed to fetch next data: ${response.body}");
      }
    } catch (err) {
      print("Error occurred: $err");
    }

    return Constants.fallBackData;
  }
}
