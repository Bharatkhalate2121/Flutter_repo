import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/api_calls/get_latest_news.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness = MediaQuery.of(context).platformBrightness;
      context.read<ContextClass>().theme = brightness != Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool theme = MediaQuery.of(context).platformBrightness != Brightness.dark;
    return MaterialApp(
      theme: theme ? ThemeData.light() : ThemeData.dark(),
      initialRoute: '/',
      routes: {'/': (context) => HomeScreen()},
    );
  }
}
