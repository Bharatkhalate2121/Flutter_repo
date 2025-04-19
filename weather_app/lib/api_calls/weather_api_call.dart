import "package:http/http.dart" as http;
import "dart:convert";

class WeatherApiCall {
  static const List<String> cities = [
    "Mumbai,ind",
    "Pune,ind",
    "Solapur,ind",
    "Tuljapur,ind",
    "Pandharpur,ind",
  ];

  static String url = "api.openweathermap.org";
  static String path = "/data/2.5/weather";
  static String apiKey = "73ed92fb1ad0199c52933298825c55e1";

  static Future<List<Map<String, dynamic>>> makeCall() async {
    final List<Future<Map<String, dynamic>>> futures = cities
        .map((city) => getCall(city))
        .toList();
    final List<Map<String, dynamic>> dataList = await Future.wait(futures);
    return dataList;
  }

  static Future<Map<String, dynamic>> getCall(String city) async {
    var endPoint = Uri.https(url, path, {"q": city, "APPID": apiKey});

    try {
      var response = await http.get(endPoint);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
          "API Error for $city: ${response.statusCode} ${response.reasonPhrase}",
        );
      }
    } catch (err) {
      print("Network Error for $city: $err");
    }

    Map<String, dynamic> solapurWeatherData = {
      "coord": {"lon": 75.9167, "lat": 17.6833},
      "weather": [
        {
          "id": 803,
          "main": "Clouds",
          "description": "broken clouds",
          "icon": "04n",
        },
      ],
      "base": "stations",
      "main": {
        "temp": 310.26,
        "feels_like": 308.33,
        "temp_min": 310.26,
        "temp_max": 310.26,
        "pressure": 1005,
        "humidity": 18,
        "sea_level": 1005,
        "grnd_level": 953,
      },
      "visibility": 10000,
      "wind": {"speed": 4.25, "deg": 155, "gust": 5.18},
      "clouds": {"all": 72},
      "dt": 1744999675,
      "sys": {"country": "IN", "sunrise": 1744936678, "sunset": 1744981981},
      "timezone": 19800,
      "id": 1256436,
      "name": "Solapur",
      "cod": 200,
    };
    return solapurWeatherData;
  }
}
