import "dart:convert";

import "package:esim_open_source/utils/parsing_helper.dart";

UserNotificationModel userNotificationModelFromJson(String str) =>
    UserNotificationModel.fromJson(json: json.decode(str));
String userNotificationModelToJson(UserNotificationModel data) =>
    json.encode(data.toJson());

class UserNotificationModel {
  UserNotificationModel({
    int? notificationId,
    String? title,
    String? content,
    String? datetime,
    String? transactionStatus,
    String? transaction,
    String? transactionMessage,
    bool? status,
    String? iccid,
    String? category,
    String? translatedMessage,
  }) {
    _notificationId = notificationId;
    _title = title;
    _content = content;
    _datetime = datetime;
    _transactionStatus = transactionStatus;
    _transaction = transaction;
    _transactionMessage = transactionMessage;
    _status = status;
    _iccid = iccid;
    _category = category;
    _translatedMessage = translatedMessage;
  }

  UserNotificationModel.fromJson({dynamic json}) {
    _notificationId = json["notification_id"];
    _title = json["title"];
    _content = json["content"];
    _datetime = json["datetime"];
    _transactionStatus = json["transaction_status"];
    _transaction = json["transaction"];
    _transactionMessage = json["transaction_message"];
    _status = json["status"];
    _iccid = json["iccid"];
    _category = json["category"];
    _translatedMessage = json["translated_message"];
  }
  int? _notificationId;
  String? _title;
  String? _content;
  String? _datetime;
  String? _transactionStatus;
  String? _transaction;
  String? _transactionMessage;
  bool? _status;
  String? _iccid;
  String? _category;
  String? _translatedMessage;
  UserNotificationModel copyWith({
    int? notificationId,
    String? title,
    String? content,
    String? datetime,
    String? transactionStatus,
    String? transaction,
    String? transactionMessage,
    bool? status,
    dynamic iccid,
    dynamic category,
    dynamic translatedMessage,
  }) =>
      UserNotificationModel(
        notificationId: notificationId ?? 0,
        title: title ?? _title,
        content: content ?? _content,
        datetime: datetime ?? _datetime,
        transactionStatus: transactionStatus ?? _transactionStatus,
        transaction: transaction ?? _transaction,
        transactionMessage: transactionMessage ?? _transactionMessage,
        status: status ?? _status,
        iccid: iccid ?? _iccid,
        category: category ?? _category,
        translatedMessage: translatedMessage ?? _translatedMessage,
      );
  int? get notificationId => _notificationId;
  String? get title => _title;
  String? get content => _content;
  String? get datetime => _datetime;
  String? get transactionStatus => _transactionStatus;
  String? get transaction => _transaction;
  String? get transactionMessage => _transactionMessage;
  bool? get status => _status;
  String? get iccid => _iccid;
  String? get category => _category;
  String? get translatedMessage => _translatedMessage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["notification_id"] = _notificationId;
    map["title"] = _title;
    map["content"] = _content;
    map["datetime"] = _datetime;
    map["transaction_status"] = _transactionStatus;
    map["transaction"] = _transaction;
    map["transaction_message"] = _transactionMessage;
    map["status"] = _status;
    map["iccid"] = _iccid;
    map["category"] = _category;
    map["translated_message"] = _translatedMessage;
    return map;
  }

  static List<UserNotificationModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: UserNotificationModel.fromJson,
      json: json,
    );
  }
}
