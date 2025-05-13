import 'Package:flutter/material.dart';

class ContextClass extends ChangeNotifier{
  List<Map<String,dynamic>> _data=[];
  bool _theme=true;  //true for light and false for dark

  set data (List<Map<String,dynamic>> data){
    _data=data;
    notifyListeners();
  }

  List<Map<String,dynamic>> get data=>_data;

  bool get theme=>_theme;

  set theme(bool theme) {
    _theme=theme;
    notifyListeners();
  }

}