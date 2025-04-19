import "package:flutter/material.dart";
// import "package:provider/provider.dart";

class StateContext with ChangeNotifier {
  List<Map<String, dynamic>> _dataMapList = [];
  bool _theme = true;
  int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }

  bool get theme => _theme;

  set theme(bool theme) {
    _theme = theme;
    notifyListeners();
  }

  List<Map<String, dynamic>> get dataMapList => _dataMapList;

  set dataMapList(List<Map<String, dynamic>> dataMap) {
    _dataMapList = dataMap;
    notifyListeners();
  }
}
