import "dart:convert";

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json: json.decode(str));
String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    Client? client,
    List<Contacts>? contacts,
  }) {
    _client = client;
    _contacts = contacts;
  }

  RegisterResponse.fromJson({dynamic json}) {
    _client = json["client"] != null ? Client.fromJson(json["client"]) : null;
    if (json["contacts"] != null) {
      _contacts = <Contacts>[];
      json["contacts"].forEach((dynamic v) {
        _contacts?.add(Contacts.fromJson(v));
      });
    }
  }
  Client? _client;
  List<Contacts>? _contacts;
  RegisterResponse copyWith({
    Client? client,
    List<Contacts>? contacts,
  }) =>
      RegisterResponse(
        client: client ?? _client,
        contacts: contacts ?? _contacts,
      );
  Client? get client => _client;
  List<Contacts>? get contacts => _contacts;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (_client != null) {
      map["client"] = _client?.toJson();
    }
    if (_contacts != null) {
      map["contacts"] = _contacts?.map((Contacts v) => v.toJson()).toList();
    }
    return map;
  }
}

/// telephoneNumber : "96170736943"
/// mobileNumber : "96170736943"
/// email : "hassan.yass211ine@montyholding.com"
/// isPrimary : true
/// firstName : "georges"
/// lastName : "nicolas"
/// companyEmail : "georges@example.com"
/// companyWebsite : "georges@example.com"
/// recordGuid : "e8991440-6476-46f3-a5e6-d57e29d9fd9c"

Contacts contactsFromJson(String str) => Contacts.fromJson(json.decode(str));
String contactsToJson(Contacts data) => json.encode(data.toJson());

class Contacts {
  Contacts({
    String? telephoneNumber,
    String? mobileNumber,
    String? email,
    bool? isPrimary,
    String? firstName,
    String? lastName,
    String? companyEmail,
    String? companyWebsite,
    String? recordGuid,
  }) {
    _telephoneNumber = telephoneNumber;
    _mobileNumber = mobileNumber;
    _email = email;
    _isPrimary = isPrimary;
    _firstName = firstName;
    _lastName = lastName;
    _companyEmail = companyEmail;
    _companyWebsite = companyWebsite;
    _recordGuid = recordGuid;
  }

  Contacts.fromJson(dynamic json) {
    _telephoneNumber = json["telephoneNumber"];
    _mobileNumber = json["mobileNumber"];
    _email = json["email"];
    _isPrimary = json["isPrimary"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _companyEmail = json["companyEmail"];
    _companyWebsite = json["companyWebsite"];
    _recordGuid = json["recordGuid"];
  }
  String? _telephoneNumber;
  String? _mobileNumber;
  String? _email;
  bool? _isPrimary;
  String? _firstName;
  String? _lastName;
  String? _companyEmail;
  String? _companyWebsite;
  String? _recordGuid;
  Contacts copyWith({
    String? telephoneNumber,
    String? mobileNumber,
    String? email,
    bool? isPrimary,
    String? firstName,
    String? lastName,
    String? companyEmail,
    String? companyWebsite,
    String? recordGuid,
  }) =>
      Contacts(
        telephoneNumber: telephoneNumber ?? _telephoneNumber,
        mobileNumber: mobileNumber ?? _mobileNumber,
        email: email ?? _email,
        isPrimary: isPrimary ?? _isPrimary,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        companyEmail: companyEmail ?? _companyEmail,
        companyWebsite: companyWebsite ?? _companyWebsite,
        recordGuid: recordGuid ?? _recordGuid,
      );
  String? get telephoneNumber => _telephoneNumber;
  String? get mobileNumber => _mobileNumber;
  String? get email => _email;
  bool? get isPrimary => _isPrimary;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get companyEmail => _companyEmail;
  String? get companyWebsite => _companyWebsite;
  String? get recordGuid => _recordGuid;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["telephoneNumber"] = _telephoneNumber;
    map["mobileNumber"] = _mobileNumber;
    map["email"] = _email;
    map["isPrimary"] = _isPrimary;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["companyEmail"] = _companyEmail;
    map["companyWebsite"] = _companyWebsite;
    map["recordGuid"] = _recordGuid;
    return map;
  }
}

/// titleId : 1053
/// clientTypeId : 1063
/// zoneId : null
/// isPrimary : true
/// isActive : true
/// name : null
/// firstName : "georges"
/// lastName : "nicolas"
/// email : "hassan.yass211ine@montyholding.com"
/// username : "gn_12111"
/// externalUserId : "f1b84903-24f4-499d-b5d5-054ed7e703b1"
/// createdDate : 1693898713
/// recordGuid : "a93c17c2-57e6-4fbf-9ff1-c17f225897d1"

Client clientFromJson(String str) => Client.fromJson(json.decode(str));
String clientToJson(Client data) => json.encode(data.toJson());

class Client {
  Client({
    int? titleId,
    int? clientTypeId,
    dynamic zoneId,
    bool? isPrimary,
    bool? isActive,
    dynamic name,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? externalUserId,
    int? createdDate,
    String? recordGuid,
  }) {
    _titleId = titleId;
    _clientTypeId = clientTypeId;
    _zoneId = zoneId;
    _isPrimary = isPrimary;
    _isActive = isActive;
    _name = name;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _username = username;
    _externalUserId = externalUserId;
    _createdDate = createdDate;
    _recordGuid = recordGuid;
  }

  Client.fromJson(dynamic json) {
    _titleId = json["titleId"];
    _clientTypeId = json["clientTypeId"];
    _zoneId = json["zoneId"];
    _isPrimary = json["isPrimary"];
    _isActive = json["isActive"];
    _name = json["name"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _email = json["email"];
    _username = json["username"];
    _externalUserId = json["externalUserId"];
    _createdDate = json["createdDate"];
    _recordGuid = json["recordGuid"];
  }
  int? _titleId;
  int? _clientTypeId;
  dynamic _zoneId;
  bool? _isPrimary;
  bool? _isActive;
  dynamic _name;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _username;
  String? _externalUserId;
  int? _createdDate;
  String? _recordGuid;
  Client copyWith({
    int? titleId,
    int? clientTypeId,
    dynamic zoneId,
    bool? isPrimary,
    bool? isActive,
    dynamic name,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? externalUserId,
    int? createdDate,
    String? recordGuid,
  }) =>
      Client(
        titleId: titleId ?? _titleId,
        clientTypeId: clientTypeId ?? _clientTypeId,
        zoneId: zoneId ?? _zoneId,
        isPrimary: isPrimary ?? _isPrimary,
        isActive: isActive ?? _isActive,
        name: name ?? _name,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        username: username ?? _username,
        externalUserId: externalUserId ?? _externalUserId,
        createdDate: createdDate ?? _createdDate,
        recordGuid: recordGuid ?? _recordGuid,
      );
  int? get titleId => _titleId;
  int? get clientTypeId => _clientTypeId;
  dynamic get zoneId => _zoneId;
  bool? get isPrimary => _isPrimary;
  bool? get isActive => _isActive;
  dynamic get name => _name;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get username => _username;
  String? get externalUserId => _externalUserId;
  int? get createdDate => _createdDate;
  String? get recordGuid => _recordGuid;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["titleId"] = _titleId;
    map["clientTypeId"] = _clientTypeId;
    map["zoneId"] = _zoneId;
    map["isPrimary"] = _isPrimary;
    map["isActive"] = _isActive;
    map["name"] = _name;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["email"] = _email;
    map["username"] = _username;
    map["externalUserId"] = _externalUserId;
    map["createdDate"] = _createdDate;
    map["recordGuid"] = _recordGuid;
    return map;
  }
}
