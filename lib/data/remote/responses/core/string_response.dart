class StringResponse {
  StringResponse.fromJson({dynamic json}) {
    _stringValue = json;
  }

  bool? _stringValue;
  bool? get stringValue => _stringValue;
}
