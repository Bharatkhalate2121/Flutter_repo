import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:news_app/context/context_class.dart';
import 'package:news_app/api_calls/get_latest_news.dart';


void main() {
  runApp(ChangeNotifierProvider(create: (_) => ContextClass(), child: MyApp()));
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
    GetLatestNews.getData().then((data){
      context.read<ContextClass>().data=data;
      // debugPrint(data.toString());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness = MediaQuery.of(context).platformBrightness;
      context.read<ContextClass>().theme = brightness != Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool theme = Provider.of<ContextClass>(context, listen: true).theme;
    return MaterialApp(
      theme: theme ? ThemeData.light() : ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
