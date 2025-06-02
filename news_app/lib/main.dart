import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/news_details.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/screens/user_screen.dart';
import 'package:provider/provider.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/api_calls/get_latest_news.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ContextClass>.value(
      value: ContextClass.instance,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? expired;
  Timer? expirationTimer;

  @override
  void initState() {
    super.initState();
    GetLatestNews.getData().then((data) {
      late String nextPage;
      data.removeWhere((map) {
        if (map.containsKey("nextPage")) {
          nextPage = map["nextPage"];
          return true; // remove this map
        }
        return false;
      });
      context.read<ContextClass>().courosalData = data;
      context.read<ContextClass>().nextPage = nextPage;
      GetLatestNews.getDataForRow(nextPage).then((data) {
        late String nextPage;
        data.removeWhere((map) {
          if (map.containsKey("nextPage")) {
            nextPage = map["nextPage"];
            return true; // remove this map
          }
          return false;
        });
        context.read<ContextClass>().data = data;
        context.read<ContextClass>().nextPage = nextPage;
      });
    });
    setTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness = MediaQuery.of(context).platformBrightness;
      context.read<ContextClass>().theme = brightness != Brightness.dark;
    });
  }

  Future<void> setTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedTime = prefs.getInt('timer');
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    if (prefs.getString('authorization') != null) {
      Provider.of<ContextClass>(context, listen: false).isLogged = true;
    }

    const int fiveMinutesMillis = 1 * 60 * 1000; // 300000 milliseconds

    if (savedTime != null) {
      final int elapsed = currentTime - savedTime;
      if (elapsed >= fiveMinutesMillis) {
        // Time already expired
        setState(() {
          expired = true;
        });
        print("Expired immediately.");
      } else {
        // Not expired yet, start a timer for remaining time
        int remaining = fiveMinutesMillis - elapsed;

        expirationTimer?.cancel();
        expirationTimer = Timer(Duration(milliseconds: remaining), () {
          setState(() {
            expired = true;
          });
          print("Expired from background timer.");
          Provider.of<ContextClass>(context, listen: false).showDialog = true;
        });

        print("Timer started for ${remaining / 1000} seconds.");
      }
    } else {
      // No timer saved, set current time and start new 5-minute timer
      await prefs.setInt('timer', currentTime);

      expirationTimer?.cancel();
      expirationTimer = Timer(Duration(milliseconds: fiveMinutesMillis), () {
        setState(() {
          expired = true;
        });
        print("Expired from new timer.");
        Provider.of<ContextClass>(context, listen: false).showDialog = true;
      });

      print("Timer set for 5 minutes from now.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    context.read<ContextClass>().theme = brightness != Brightness.dark;
    bool theme = MediaQuery.of(context).platformBrightness != Brightness.dark;
    return MaterialApp(
      theme: theme ? ThemeData.light() : ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/details': (context) => NewsDetails(newsData: {}),
        '/users': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return UserScreen(loginPage: args?['loginPage']);
        },
      },
    );
  }
}
