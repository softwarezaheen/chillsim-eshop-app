import "dart:convert";

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json: json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    String? accessToken,
    String? refreshToken,
    num? expiresIn,
    String? externalUserId,
    String? userId,
    String? clientId,
    String? providerId,
    String? userClientId,
    String? userProviderId,
    String? errorDescription,
    String? error,
    bool? isError,
    // dynamic permissions,
    List<Menus>? menus,
    List<String>? roles,
    Attributes? attributes,
    List<String>? requiredActions,
    // dynamic socialMediaProvider,
    num? kyc,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiresIn = expiresIn;
    _externalUserId = externalUserId;
    _userId = userId;
    _clientId = clientId;
    _providerId = providerId;
    _userClientId = userClientId;
    _userProviderId = userProviderId;
    _errorDescription = errorDescription;
    _error = error;
    _isError = isError;
    // _permissions = permissions;
    _menus = menus;
    _roles = roles;
    _attributes = attributes;
    _requiredActions = requiredActions;
    // _socialMediaProvider = socialMediaProvider;
    _kyc = kyc;
  }

  LoginResponse.fromJson({dynamic json}) {
    _accessToken = json["accessToken"];
    _refreshToken = json["refreshToken"];
    _expiresIn = json["expiresIn"];
    _externalUserId = json["externalUserId"];
    _userId = json["userId"];
    _clientId = json["clientId"];
    _providerId = json["providerId"];
    _userClientId = json["userClientId"];
    _userProviderId = json["userProviderId"];
    _errorDescription = json["errorDescription"];
    _error = json["error"];
    _isError = json["isError"];
    // _permissions = json['permissions'];
    if (json["menus"] != null) {
      _menus = <Menus>[];
      json["menus"].forEach((dynamic v) {
        _menus?.add(Menus.fromJson(v));
      });
    }
    _roles = json["roles"] != null ? json["roles"].cast<String>() : <String>[];
    _attributes = json["attributes"] != null
        ? Attributes.fromJson(json["attributes"])
        : null;
    _requiredActions = json["requiredActions"] != null
        ? json["requiredActions"].cast<String>()
        : <String>[];
    // _socialMediaProvider = json['socialMediaProvider'];
    _kyc = json["kyc"];
  }
  String? _accessToken;
  String? _refreshToken;
  num? _expiresIn;
  String? _externalUserId;
  String? _userId;
  String? _clientId;
  String? _providerId;
  String? _userClientId;
  String? _userProviderId;
  String? _errorDescription;
  String? _error;
  bool? _isError;
  // dynamic _permissions;
  List<Menus>? _menus;
  List<String>? _roles;
  Attributes? _attributes;
  List<String>? _requiredActions;
  // dynamic _socialMediaProvider;
  num? _kyc;
  LoginResponse copyWith({
    String? accessToken,
    String? refreshToken,
    num? expiresIn,
    String? externalUserId,
    String? userId,
    String? clientId,
    String? providerId,
    String? userClientId,
    String? userProviderId,
    String? errorDescription,
    String? error,
    bool? isError,
    // dynamic permissions,
    List<Menus>? menus,
    List<String>? roles,
    Attributes? attributes,
    List<String>? requiredActions,
    // dynamic socialMediaProvider,
    num? kyc,
  }) =>
      LoginResponse(
        accessToken: accessToken ?? _accessToken,
        refreshToken: refreshToken ?? _refreshToken,
        expiresIn: expiresIn ?? _expiresIn,
        externalUserId: externalUserId ?? _externalUserId,
        userId: userId ?? _userId,
        clientId: clientId ?? _clientId,
        providerId: providerId ?? _providerId,
        userClientId: userClientId ?? _userClientId,
        userProviderId: userProviderId ?? _userProviderId,
        errorDescription: errorDescription ?? _errorDescription,
        error: error ?? _error,
        isError: isError ?? _isError,
        // permissions: permissions ?? _permissions,
        menus: menus ?? _menus,
        roles: roles ?? _roles,
        attributes: attributes ?? _attributes,
        requiredActions: requiredActions ?? _requiredActions,
        // socialMediaProvider: socialMediaProvider ?? _socialMediaProvider,
        kyc: kyc ?? _kyc,
      );
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  num? get expiresIn => _expiresIn;
  String? get externalUserId => _externalUserId;
  String? get userId => _userId;
  String? get clientId => _clientId;
  String? get providerId => _providerId;
  String? get userClientId => _userClientId;
  String? get userProviderId => _userProviderId;
  String? get errorDescription => _errorDescription;
  String? get error => _error;
  bool? get isError => _isError;
  // dynamic get permissions => _permissions;
  List<Menus>? get menus => _menus;
  List<String>? get roles => _roles;
  Attributes? get attributes => _attributes;
  List<String>? get requiredActions => _requiredActions;
  // dynamic get socialMediaProvider => _socialMediaProvider;
  num? get kyc => _kyc;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["accessToken"] = _accessToken;
    map["refreshToken"] = _refreshToken;
    map["expiresIn"] = _expiresIn;
    map["externalUserId"] = _externalUserId;
    map["userId"] = _userId;
    map["clientId"] = _clientId;
    map["providerId"] = _providerId;
    map["userClientId"] = _userClientId;
    map["userProviderId"] = _userProviderId;
    map["errorDescription"] = _errorDescription;
    map["error"] = _error;
    map["isError"] = _isError;
    // map['permissions'] = _permissions;
    if (_menus != null) {
      map["menus"] = _menus?.map((Menus v) => v.toJson()).toList();
    }
    map["roles"] = _roles;
    if (_attributes != null) {
      map["attributes"] = _attributes?.toJson();
    }
    map["requiredActions"] = _requiredActions;
    // map['socialMediaProvider'] = _socialMediaProvider;
    map["kyc"] = _kyc;
    return map;
  }
}

/// login_id : "531"

Attributes attributesFromJson(String str) =>
    Attributes.fromJson(json.decode(str));
String attributesToJson(Attributes data) => json.encode(data.toJson());

class Attributes {
  Attributes({
    String? loginId,
  }) {
    _loginId = loginId;
  }

  Attributes.fromJson(dynamic json) {
    _loginId = json["login_id"];
  }
  String? _loginId;
  Attributes copyWith({
    String? loginId,
  }) =>
      Attributes(
        loginId: loginId ?? _loginId,
      );
  String? get loginId => _loginId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["login_id"] = _loginId;
    return map;
  }
}

/// parentGuid : null
/// displayOrder : 15
/// uri : "billing"
/// iconUri : "fa-diamond"
/// recordGuid : "c14b215b-03da-4dff-8e03-080cd347b977"
/// position : 100
/// group : 1
/// menuDetail : [{"name":"Billing","description":"Billing","languageCode":"en"}]
/// menuAction : [{"recordGuid":"aa04f156-c7eb-4ef8-8c01-cc98c0140e52","menuActionDetail":[{"name":"billing","description":"billing","languageCode":"en"}],"hasAccess":false},{"recordGuid":"8adb2dbe-669e-48dd-ab58-275294c6cc85","menuActionDetail":[{"name":"Payment","description":"Payment","languageCode":"en"}],"hasAccess":true},{"recordGuid":"393f986c-46c5-4fde-8e09-c32264643483","menuActionDetail":[{"name":"Balance History","description":"Balance History","languageCode":"en"}],"hasAccess":true},{"recordGuid":"584904bc-f7fc-450e-bdd2-7718fbb8e85e","menuActionDetail":[{"name":"Account History","description":"Account History","languageCode":"en"}],"hasAccess":false},{"recordGuid":"fb5cb469-ab26-41f7-a455-739ba267e9b5","menuActionDetail":[{"name":"Request","description":"Request","languageCode":"en"}],"hasAccess":false},{"recordGuid":"00b7172b-b364-4ca7-915a-e7cca2fa3352","menuActionDetail":[{"name":"Payment History","description":"Payment History","languageCode":"en"}],"hasAccess":false}]

Menus menusFromJson(String str) => Menus.fromJson(json.decode(str));
String menusToJson(Menus data) => json.encode(data.toJson());

class Menus {
  Menus({
    String? parentGuid,
    num? displayOrder,
    String? uri,
    String? iconUri,
    String? recordGuid,
    num? position,
    num? group,
    List<MenuDetail>? menuDetail,
    List<MenuAction>? menuAction,
  }) {
    _parentGuid = parentGuid;
    _displayOrder = displayOrder;
    _uri = uri;
    _iconUri = iconUri;
    _recordGuid = recordGuid;
    _position = position;
    _group = group;
    _menuDetail = menuDetail;
    _menuAction = menuAction;
  }

  Menus.fromJson(dynamic json) {
    _parentGuid = json["parentGuid"];
    _displayOrder = json["displayOrder"];
    _uri = json["uri"];
    _iconUri = json["iconUri"];
    _recordGuid = json["recordGuid"];
    _position = json["position"];
    _group = json["group"];
    if (json["menuDetail"] != null) {
      _menuDetail = <MenuDetail>[];
      json["menuDetail"].forEach((dynamic v) {
        _menuDetail?.add(MenuDetail.fromJson(v));
      });
    }
    if (json["menuAction"] != null) {
      _menuAction = <MenuAction>[];
      json["menuAction"].forEach((dynamic v) {
        _menuAction?.add(MenuAction.fromJson(v));
      });
    }
  }
  String? _parentGuid;
  num? _displayOrder;
  String? _uri;
  String? _iconUri;
  String? _recordGuid;
  num? _position;
  num? _group;
  List<MenuDetail>? _menuDetail;
  List<MenuAction>? _menuAction;
  Menus copyWith({
    String? parentGuid,
    num? displayOrder,
    String? uri,
    String? iconUri,
    String? recordGuid,
    num? position,
    num? group,
    List<MenuDetail>? menuDetail,
    List<MenuAction>? menuAction,
  }) =>
      Menus(
        parentGuid: parentGuid ?? _parentGuid,
        displayOrder: displayOrder ?? _displayOrder,
        uri: uri ?? _uri,
        iconUri: iconUri ?? _iconUri,
        recordGuid: recordGuid ?? _recordGuid,
        position: position ?? _position,
        group: group ?? _group,
        menuDetail: menuDetail ?? _menuDetail,
        menuAction: menuAction ?? _menuAction,
      );
  String? get parentGuid => _parentGuid;
  num? get displayOrder => _displayOrder;
  String? get uri => _uri;
  String? get iconUri => _iconUri;
  String? get recordGuid => _recordGuid;
  num? get position => _position;
  num? get group => _group;
  List<MenuDetail>? get menuDetail => _menuDetail;
  List<MenuAction>? get menuAction => _menuAction;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["parentGuid"] = _parentGuid;
    map["displayOrder"] = _displayOrder;
    map["uri"] = _uri;
    map["iconUri"] = _iconUri;
    map["recordGuid"] = _recordGuid;
    map["position"] = _position;
    map["group"] = _group;
    if (_menuDetail != null) {
      map["menuDetail"] =
          _menuDetail?.map((MenuDetail v) => v.toJson()).toList();
    }
    if (_menuAction != null) {
      map["menuAction"] =
          _menuAction?.map((MenuAction v) => v.toJson()).toList();
    }
    return map;
  }
}

/// recordGuid : "aa04f156-c7eb-4ef8-8c01-cc98c0140e52"
/// menuActionDetail : [{"name":"billing","description":"billing","languageCode":"en"}]
/// hasAccess : false

MenuAction menuActionFromJson(String str) =>
    MenuAction.fromJson(json.decode(str));
String menuActionToJson(MenuAction data) => json.encode(data.toJson());

class MenuAction {
  MenuAction({
    String? recordGuid,
    List<MenuActionDetail>? menuActionDetail,
    bool? hasAccess,
  }) {
    _recordGuid = recordGuid;
    _menuActionDetail = menuActionDetail;
    _hasAccess = hasAccess;
  }

  MenuAction.fromJson(dynamic json) {
    _recordGuid = json["recordGuid"];
    if (json["menuActionDetail"] != null) {
      _menuActionDetail = <MenuActionDetail>[];
      json["menuActionDetail"].forEach((dynamic v) {
        _menuActionDetail?.add(MenuActionDetail.fromJson(v));
      });
    }
    _hasAccess = json["hasAccess"];
  }
  String? _recordGuid;
  List<MenuActionDetail>? _menuActionDetail;
  bool? _hasAccess;
  MenuAction copyWith({
    String? recordGuid,
    List<MenuActionDetail>? menuActionDetail,
    bool? hasAccess,
  }) =>
      MenuAction(
        recordGuid: recordGuid ?? _recordGuid,
        menuActionDetail: menuActionDetail ?? _menuActionDetail,
        hasAccess: hasAccess ?? _hasAccess,
      );
  String? get recordGuid => _recordGuid;
  List<MenuActionDetail>? get menuActionDetail => _menuActionDetail;
  bool? get hasAccess => _hasAccess;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["recordGuid"] = _recordGuid;
    if (_menuActionDetail != null) {
      map["menuActionDetail"] =
          _menuActionDetail?.map((MenuActionDetail v) => v.toJson()).toList();
    }
    map["hasAccess"] = _hasAccess;
    return map;
  }
}

/// name : "billing"
/// description : "billing"
/// languageCode : "en"

MenuActionDetail menuActionDetailFromJson(String str) =>
    MenuActionDetail.fromJson(json.decode(str));
String menuActionDetailToJson(MenuActionDetail data) =>
    json.encode(data.toJson());

class MenuActionDetail {
  MenuActionDetail({
    String? name,
    String? description,
    String? languageCode,
  }) {
    _name = name;
    _description = description;
    _languageCode = languageCode;
  }

  MenuActionDetail.fromJson(dynamic json) {
    _name = json["name"];
    _description = json["description"];
    _languageCode = json["languageCode"];
  }
  String? _name;
  String? _description;
  String? _languageCode;
  MenuActionDetail copyWith({
    String? name,
    String? description,
    String? languageCode,
  }) =>
      MenuActionDetail(
        name: name ?? _name,
        description: description ?? _description,
        languageCode: languageCode ?? _languageCode,
      );
  String? get name => _name;
  String? get description => _description;
  String? get languageCode => _languageCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["name"] = _name;
    map["description"] = _description;
    map["languageCode"] = _languageCode;
    return map;
  }
}

/// name : "Billing"
/// description : "Billing"
/// languageCode : "en"

MenuDetail menuDetailFromJson(String str) =>
    MenuDetail.fromJson(json.decode(str));
String menuDetailToJson(MenuDetail data) => json.encode(data.toJson());

class MenuDetail {
  MenuDetail({
    String? name,
    String? description,
    String? languageCode,
  }) {
    _name = name;
    _description = description;
    _languageCode = languageCode;
  }

  MenuDetail.fromJson(dynamic json) {
    _name = json["name"];
    _description = json["description"];
    _languageCode = json["languageCode"];
  }
  String? _name;
  String? _description;
  String? _languageCode;
  MenuDetail copyWith({
    String? name,
    String? description,
    String? languageCode,
  }) =>
      MenuDetail(
        name: name ?? _name,
        description: description ?? _description,
        languageCode: languageCode ?? _languageCode,
      );
  String? get name => _name;
  String? get description => _description;
  String? get languageCode => _languageCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["name"] = _name;
    map["description"] = _description;
    map["languageCode"] = _languageCode;
    return map;
  }
}
