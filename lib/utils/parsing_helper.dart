List<T> fromJsonListTypedNamed<T>({
  required T Function({dynamic json}) parser,
  dynamic json,
}) {
  return List<T>.from(json.map((dynamic i) => parser(json: i)));
}

List<T> fromJsonListTyped<T>({
  required T Function({dynamic json}) parser,
  dynamic json,
}) {
  return List<T>.from(json.map((dynamic i) => parser(json: i)));
}
