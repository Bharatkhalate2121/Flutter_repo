import 'dart:convert';

import 'package:http/http.dart' as http;

class GetLatestNews {
  static final String _url ="newsdata.io";
  static final String _token = "pub_85662b976b5905d7d2b7ab0410c340e7ca98c";
  static final String _path = "/api/1/latest";

  static Future<List<Map<String, dynamic>>> getData() async {
    var url=Uri.https(_url,_path,{"apikey":_token,"country":"in","language":"en"});
    try{
      final response=await http.get(url);
      if(response.statusCode==200){
        final decoded =jsonDecode(response.body);
        if(decoded['results']!=null){
          return List<Map<String,dynamic>>.from(decoded['results']);
        }
      }
    else {
        print(
          "API Error for ${response.statusCode} ${response.reasonPhrase}",
        );
      }
    } catch (err) {
      print("Network Error for $err");
    }
     return [
      {
        "title": "Rajasthan Forest Department Launches Pioneering Wildlife Survey in Jhalana",
        "link": "https://www.devdiscourse.com/article/headlines/3378637-rajasthan-forest-department-launches-pioneering-wildlife-survey-in-jhalana",
        "description": "In a groundbreaking move, the Rajasthan Forest Department has launched an extensive wildlife survey in the Jhalana forest area...",
        "pubDate": "2025-05-12 12:21:52",
        "image_url": "https://devdiscourse.blob.core.windows.net/devnews/12_05_2025_17_51_39_9286537.jpg",
        "source_name": "Devdiscourse",
      }
    ];
  }
}
