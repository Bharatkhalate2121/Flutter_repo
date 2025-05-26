import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/constants/constants.dart';
import 'package:news_app/context/context_class.dart';

class GetSourceNews {
  static Future<List<Map<String, dynamic>>> getData({
    required String domain,
    String? nextPage,
  }) async {
    try {
      var queryParameters = Constants.queryParameters;
      if (nextPage != null) queryParameters['page'] = nextPage;
      var endPoint = Uri.https(Constants.url, Constants.path, {
        ...queryParameters,
        'domain': domain,
      });
      var response = await http.get(endPoint);
      var decoded = jsonDecode(response.body);
      ContextClass.instance.sourceNextPage = decoded['nextPage'] ?? "";

      return List<Map<String, dynamic>>.from(
        decoded['results'] ?? Constants.fallBackData,
      ).where((map) {
        return !(map.containsKey("article_id") &&
            map["article_id"] == ContextClass.instance.current);
      }).toList();
    } catch (err) {
      
      print("error while fetching data $err");
    }
    return Constants.fallBackData;
  }
}
