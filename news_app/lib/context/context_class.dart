import 'Package:flutter/material.dart';
import 'package:news_app/api_calls/get_latest_news.dart';
import 'package:provider/provider.dart';

class ContextClass extends ChangeNotifier {
  static final ContextClass instance = ContextClass._internal();
  ContextClass._internal();
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _courosalData = [];
  late String _current;
  late String _nextPage;
  late String _relevantNextPage;
  late String _searchNextPage;
  late String _sourceNextPage;
  bool _theme = true; //true for light and false for dark
  bool _isLogged = false;
  double _height = 10;
  bool _showDialog = true;

  set height(double height) {
    _height = height;
  }

  double get height => _height;

  set showDialog(bool showDialog) {
    _showDialog = showDialog;
    notifyListeners();
  }

  bool get showDialog => _showDialog;

  set data(List<Map<String, dynamic>> data) {
    _data = data;
    notifyListeners();
  }

  List<Map<String, dynamic>> get data => _data;

  bool get theme => _theme;

  set theme(bool theme) {
    _theme = theme;
    notifyListeners();
  }

  bool get isLoged => _isLogged;

  set isLogged(bool isLogged) {
    _isLogged = isLogged;
    notifyListeners();
  }

  set courosalData(List<Map<String, dynamic>> caurosalData) {
    _courosalData = caurosalData;
    notifyListeners();
  }

  List<Map<String, dynamic>> get courosalData => _courosalData;

  set nextPage(String nextPage) {
    _nextPage = nextPage;
    notifyListeners();
  }

  String get nextPage => _nextPage;

  set searchNextPage(String nextPage) {
    _searchNextPage = nextPage;
    notifyListeners();
  }

  String get searchNextPage => _searchNextPage;

  set relevantNextPage(String nextPage) {
    _relevantNextPage = nextPage;
    print(_relevantNextPage);
    notifyListeners();
  }

  String get relevantNextPage => _relevantNextPage;

  set sourceNextPage(String nextPage) {
    _sourceNextPage = nextPage;
    notifyListeners();
  }

  String get sourceNextPage => _sourceNextPage;

  String get current => _current;

  set current(String current) {
    _current = current;
  }

  Future<void> refreshData(BuildContext context) async {
    if (ModalRoute.of(context)?.settings.name == '/') {
      final contextClass = context.read<ContextClass>();

      // First API call to get courosalData
      final data1 = await GetLatestNews.getData();
      String? nextPage1;
      data1.removeWhere((map) {
        if (map.containsKey("nextPage")) {
          nextPage1 = map["nextPage"];
          return true;
        }
        return false;
      });
      contextClass.courosalData = data1;
      contextClass.nextPage = nextPage1 ?? "";

      // Second API call to get data for rows
      final data2 = await GetLatestNews.getDataForRow(contextClass.nextPage);
      String? nextPage2;
      data2.removeWhere((map) {
        if (map.containsKey("nextPage")) {
          nextPage2 = map["nextPage"];
          return true;
        }
        return false;
      });
      contextClass.data = data2;
      contextClass.nextPage = nextPage2 ?? "";

      // Notify listeners if needed
      contextClass.notifyListeners();
    }
  }
}
