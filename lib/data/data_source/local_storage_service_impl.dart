import "dart:async";
import "dart:convert";

import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:shared_preferences/shared_preferences.dart";

class LocalStorageServiceImpl implements LocalStorageService {
  LocalStorageServiceImpl._privateConstructor();
  late SharedPreferences _sharedPrefs;
  static LocalStorageServiceImpl? _instance;

  AuthResponseModel? _authResponse;

  @override
  AuthResponseModel? get authResponse {
    if (_authResponse == null) {
      _getLoginResponseFromDisk();
    }
    return _authResponse;
  }

  static Future<LocalStorageServiceImpl> get instance async {
    if (_instance == null) {
      _instance = LocalStorageServiceImpl._privateConstructor();
      await _instance?._initialise();
    }
    return _instance!;
  }

  Future<void> _initialise() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> setInt(LocalStorageKeys key, int value) =>
      _sharedPrefs.setInt(key.value, value);

  @override
  Future<bool> setBool(LocalStorageKeys key, {required bool value}) =>
      _sharedPrefs.setBool(key.value, value);

  @override
  Future<bool> setDouble(LocalStorageKeys key, double value) =>
      _sharedPrefs.setDouble(key.value, value);

  @override
  Future<bool> setString(LocalStorageKeys key, String value) =>
      _sharedPrefs.setString(key.value, value);

  @override
  Future<bool> setStringList(LocalStorageKeys key, List<String> value) =>
      _sharedPrefs.setStringList(key.value, value);

  @override
  int? getInt(LocalStorageKeys key) => _sharedPrefs.getInt(key.value);

  @override
  bool? getBool(LocalStorageKeys key) => _sharedPrefs.getBool(key.value);

  @override
  double? getDouble(LocalStorageKeys key) => _sharedPrefs.getDouble(key.value);

  @override
  String? getString(LocalStorageKeys key) => _sharedPrefs.getString(key.value);

  @override
  List<String>? getStringList(LocalStorageKeys key) =>
      _sharedPrefs.getStringList(key.value);

  @override
  bool containsKey(LocalStorageKeys key) => _sharedPrefs.containsKey(key.value);

  @override
  Future<void> clear() async {
    String? tempFcm = getString(LocalStorageKeys.fcmToken);
    await _sharedPrefs.clear();
    _authResponse = null;
    await setString(LocalStorageKeys.fcmToken, tempFcm ?? "");
  }

  @override
  Future<bool> remove(LocalStorageKeys key) => _sharedPrefs.remove(key.value);

  @override
  Future<void> saveLoginResponse(AuthResponseModel? authResponse) async {
    _authResponse = authResponse;
    await setString(
      LocalStorageKeys.loginResponseKey,
      authResponse != null ? json.encode(authResponse) : "",
    );
  }

  AuthResponseModel? _getLoginResponseFromDisk() {
    String? val = getString(LocalStorageKeys.loginResponseKey);
    if (val == null || val.isEmpty) {
      return null;
    }
    Map<String, dynamic> json = jsonDecode(val);
    if (json.isEmpty) {
      return null;
    }
    _authResponse = AuthResponseModel.fromAPIJson(json: json);
    return _authResponse;
  }

  @override
  String get accessToken {
    if (_authResponse == null) {
      _getLoginResponseFromDisk();
    }

    return _authResponse?.accessToken ?? "";
  }

  @override
  String get refreshToken {
    if (_authResponse == null) {
      _getLoginResponseFromDisk();
    }
    return _authResponse?.refreshToken ?? "";
  }

  @override
  bool? get biometricEnabled => getBool(LocalStorageKeys.biometricKey);

  @override
  Future<bool> setBiometricEnabled({bool? value}) {
    return setBool(
      LocalStorageKeys.biometricKey,
      value: value ?? false,
    );
  }

  @override
  String? get currencyCode => getString(LocalStorageKeys.appCurrency);

  @override
  String get languageCode =>
      getString(LocalStorageKeys.appLanguage)?.toLowerCase() ?? "en";
}
