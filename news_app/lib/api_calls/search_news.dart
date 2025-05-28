import 'dart:convert';
import 'package:news_app/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/context/context_class.dart';

class SearchNews {
  static Future<List<Map<String, dynamic>>> getData({
    String? nextPage,
    required String query,
  }) async {
    var queryParameters = (nextPage != null)
        ? {...Constants.queryParameters, 'q': query, 'page': nextPage}
        : {...Constants.queryParameters, 'q': query};
    print('data serched  ${queryParameters.toString()}');
    var endPoint = Uri.https(Constants.url, Constants.path, queryParameters);
    try {
      var response = await http.get(endPoint);
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        ContextClass.instance.searchNextPage =
            decoded['nextPage'] ?? '1748357784687387257';
        return List<Map<String, dynamic>>.from(
          decoded['results'] ?? Constants.fallBackData,
        );
      } else {
        print('${response.statusCode} : ${response.reasonPhrase}');
      }
    } catch (err, stackTrace) {
      print("Network Error for $err");
      print(stackTrace);
    }
    return Constants.fallBackData;
  }
}
