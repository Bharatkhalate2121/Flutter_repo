import 'package:flutter_assignment/Models/Data.dart';

class DataList {
  List<Data>? _dataList;

  DataList(this._dataList);
  List<Data> get dataList => _dataList!;
  set dataList(List<Data> dataList) {
    _dataList = dataList;
  }

  addData(Data data) {
    if (Data != null && dataList != null) {
      _dataList!.add(data);
    }
  }

  removeData(Data data) {
    dataList.remove(data);
  }

  removeDataById(int id) {
    for (var data in dataList) {
      if (data.id == id) dataList.remove(data);
    }
  }
}
