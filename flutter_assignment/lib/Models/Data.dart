class Data {
  int? _id;
  String? _url;
  String? _description;

  Data(this._id, this._url, this._description);

  int get id {
    return _id!;
  }

  String get url => _url!;

  String get description => _description!;

  set id(int id) {
    this._id = id;
  }

  set url(String url) {
    this._url = url;
  }

  set description(String description) {
    this._description = description;
  }

  @override
  String toString() {
    return 'Data{_id: $_id, _url: $_url, _description: $_description}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        other._id == _id &&
        other._url == _url &&
        other._description == _description;
  }
}
