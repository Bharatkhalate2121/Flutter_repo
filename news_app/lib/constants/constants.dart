import 'package:flutter/material.dart';

class Constants {
  static const String apiKey =
      /*"pub_87207da19bc27d30276c52b59420b9bf29ee8"; */ "pub_85662b976b5905d7d2b7ab0410c340e7ca98c";
  static const String url = "newsdata.io";
  static const String path = "/api/1/latest";
  static final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  static final List<Map<String, dynamic>> fallBackData = [
    {
      "article_id": "830ad2a886e966825b8e514314da59f4",
      "title":
          "US military strategist slams Trump admin for not blocking IMF aid to Pakistan - Times of India",
      "link":
          "https://news.google.com/rss/articles/CBMi1wFBVV95cUxNR2JHZ1BLSC1MbGpGREdpajlrbUpYNHJpdExyVVdmNTdqQUJzeHpjdnpYWTFCRkg2RjQzcURuUThmRi1wcGZ1enowRjV5cFlrMXUtRmNHMHFSVzJzQW16aUpXeHZIR093bklIdGFtM3F2RmhRY0VGa3h2U09uYkJTUzNoOXlVMmt1V1drSzYzY3VVWm5jcHJNUnB4VktDM1hCYnRvbHIyMVlvQ1E2dVlPSXpVS3pNcGs5ajdVei1rd1c3cDk5ajBGX243X3kxNFMza0MwUmRtbw?oc=5",
      "keywords": null,
      "creator": null,
      "description":
          "US military strategist slams Trump admin for not blocking IMF aid to Pakistan Times of India\"Pakistan Ran Like A Scared Dog With Tail Between Its Legs\": Ex-US Official NDTVFormer US NSA John Bolton on why Pakistan sought ceasefire: 'Couldn't afford to climb escalation ladder' MoneycontrolTrump likes to claim credit for everything: Ex-Pentagon official Michael Rubin | Video India TV News'Like a scared dog with tail between its legs...': Ex-Pentagon Official slams Pak over Pahalgam Attack The Economic Times",
      "content": "ONLY AVAILABLE IN PAID PLANS",
      "pubDate": "2025-05-15 20:24:00",
      "pubDateTZ": "UTC",
      "image_url": null,
      "video_url": null,
      "source_id": "google",
      "source_name": "Google News",
      "source_priority": 14,
      "source_url": "https://news.google.com",
      "source_icon": "https://i.bytvi.com/domain_icons/google.png",
      "language": "english",
      "country": ["india"],
      "category": ["top"],
      "sentiment": "ONLY AVAILABLE IN PROFESSIONAL AND CORPORATE PLANS",
      "sentiment_stats": "ONLY AVAILABLE IN PROFESSIONAL AND CORPORATE PLANS",
      "ai_tag": "ONLY AVAILABLE IN PROFESSIONAL AND CORPORATE PLANS",
      "ai_region": "ONLY AVAILABLE IN CORPORATE PLANS",
      "ai_org": "ONLY AVAILABLE IN CORPORATE PLANS",
      "duplicate": false,
    },
  ];

  static final Map<String, String> queryParameters = {
    "apikey": Constants.apiKey,
    "country": "in",
    "language": "en",
  };

  static const shimmerGradientLight = LinearGradient(
    colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static const shimmerGradientDark = LinearGradient(
    colors: [Color(0xFF2C2C2C), Color(0xFF3A3A3A), Color(0xFF2C2C2C)],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
