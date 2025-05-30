import "dart:convert";

RegisterWithoutMobileNumberRequest registerWithoutMobileNumberFromJson(
  String str,
) =>
    RegisterWithoutMobileNumberRequest.fromJson(json.decode(str));
String registerWithoutMobileNumberToJson(
  RegisterWithoutMobileNumberRequest data,
) =>
    json.encode(data.toJson());

class RegisterWithoutMobileNumberRequest {
  RegisterWithoutMobileNumberRequest({
    String? username,
    String? password,
    String? typeTag,
    String? clientName,
    dynamic lastName,
    String? email,
    dynamic mobilePhone,
    String? code,
    dynamic phone,
    String? policyId,
    String? parentId,
    List<Contacts>? contacts,
  }) {
    _username = username;
    _password = password;
    _typeTag = typeTag;
    _clientName = clientName;
    _lastName = lastName;
    _email = email;
    _mobilePhone = mobilePhone;
    _code = code;
    _phone = phone;
    _policyId = policyId;
    _parentId = parentId;
    _contacts = contacts;
  }

  RegisterWithoutMobileNumberRequest.fromJson(dynamic json) {
    _username = json["Username"];
    _password = json["Password"];
    _typeTag = json["TypeTag"];
    _clientName = json["ClientName"];
    _lastName = json["LastName"];
    _email = json["Email"];
    _mobilePhone = json["MobilePhone"];
    _code = json["code"];
    _phone = json["phone"];
    _policyId = json["PolicyId"];
    _parentId = json["ParentId"];
    if (json["Contacts"] != null) {
      _contacts = <Contacts>[];
      json["Contacts"].forEach((dynamic v) {
        _contacts?.add(Contacts.fromJson(v));
      });
    }
  }
  String? _username;
  String? _password;
  String? _typeTag;
  String? _clientName;
  dynamic _lastName;
  String? _email;
  dynamic _mobilePhone;
  String? _code;
  dynamic _phone;
  String? _policyId;
  String? _parentId;
  List<Contacts>? _contacts;
  RegisterWithoutMobileNumberRequest copyWith({
    String? username,
    String? password,
    String? typeTag,
    String? clientName,
    dynamic lastName,
    String? email,
    dynamic mobilePhone,
    String? code,
    dynamic phone,
    String? policyId,
    String? parentId,
    List<Contacts>? contacts,
  }) =>
      RegisterWithoutMobileNumberRequest(
        username: username ?? _username,
        password: password ?? _password,
        typeTag: typeTag ?? _typeTag,
        clientName: clientName ?? _clientName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        mobilePhone: mobilePhone ?? _mobilePhone,
        code: code ?? _code,
        phone: phone ?? _phone,
        policyId: policyId ?? _policyId,
        parentId: parentId ?? _parentId,
        contacts: contacts ?? _contacts,
      );
  String? get username => _username;
  String? get password => _password;
  String? get typeTag => _typeTag;
  String? get clientName => _clientName;
  dynamic get lastName => _lastName;
  String? get email => _email;
  dynamic get mobilePhone => _mobilePhone;
  String? get code => _code;
  dynamic get phone => _phone;
  String? get policyId => _policyId;
  String? get parentId => _parentId;
  List<Contacts>? get contacts => _contacts;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["Username"] = _username;
    map["Password"] = _password;
    map["TypeTag"] = _typeTag;
    map["ClientName"] = _clientName;
    map["LastName"] = _lastName;
    map["Email"] = _email;
    map["MobilePhone"] = _mobilePhone;
    map["code"] = _code;
    map["phone"] = _phone;
    map["PolicyId"] = _policyId;
    map["ParentId"] = _parentId;
    if (_contacts != null) {
      map["Contacts"] = _contacts?.map((Contacts v) => v.toJson()).toList();
    }
    return map;
  }
}

/// FirstName : "naims"
/// Email : "nixaxel513@huleos.com"
/// ContactType : "HOME"

Contacts contactsFromJson(String str) => Contacts.fromJson(json.decode(str));
String contactsToJson(Contacts data) => json.encode(data.toJson());

class Contacts {
  Contacts({
    String? firstName,
    String? email,
    String? contactType,
  }) {
    _firstName = firstName;
    _email = email;
    _contactType = contactType;
  }

  Contacts.fromJson(dynamic json) {
    _firstName = json["FirstName"];
    _email = json["Email"];
    _contactType = json["ContactType"];
  }
  String? _firstName;
  String? _email;
  String? _contactType;
  Contacts copyWith({
    String? firstName,
    String? email,
    String? contactType,
  }) =>
      Contacts(
        firstName: firstName ?? _firstName,
        email: email ?? _email,
        contactType: contactType ?? _contactType,
      );
  String? get firstName => _firstName;
  String? get email => _email;
  String? get contactType => _contactType;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["FirstName"] = _firstName;
    map["Email"] = _email;
    map["ContactType"] = _contactType;
    return map;
  }
}
