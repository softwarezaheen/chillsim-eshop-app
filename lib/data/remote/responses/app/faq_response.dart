import "dart:convert";

import "package:esim_open_source/utils/parsing_helper.dart";

/// question : "string"
/// answer : "string"

FaqResponse faqResponseFromJson(String str) =>
    FaqResponse.fromJson(json: json.decode(str));

String faqResponseToJson(FaqResponse data) => json.encode(data.toJson());

class FaqResponse {
  FaqResponse({
    String? question,
    String? answer,
  }) {
    _question = question;
    _answer = answer;
  }

  FaqResponse.fromJson({dynamic json}) {
    _question = json["question"];
    _answer = json["answer"];
  }

  String? _question;
  String? _answer;

  FaqResponse copyWith({
    String? question,
    String? answer,
  }) =>
      FaqResponse(
        question: question ?? _question,
        answer: answer ?? _answer,
      );

  String? get question => _question;

  String? get answer => _answer;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["question"] = _question;
    map["answer"] = _answer;
    return map;
  }

  static List<FaqResponse> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: FaqResponse.fromJson, json: json);
  }
}
