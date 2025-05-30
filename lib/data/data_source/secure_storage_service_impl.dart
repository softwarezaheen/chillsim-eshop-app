import "dart:convert";

import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class SecureStorageServiceImpl extends SecureStorageService {
  SecureStorageServiceImpl._privateConstructor();
  late final FlutterSecureStorage _prefs;

  static SecureStorageServiceImpl? _instance;

  IOSOptions _getIOSOptions() => const IOSOptions(
        synchronizable: true,
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static SecureStorageServiceImpl get instance {
    if (_instance == null) {
      _instance = SecureStorageServiceImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {
    _prefs = const FlutterSecureStorage();
  }

  // Helper Methods
  Future<String?> _getValue(SecureStorageKeys key) {
    return _prefs.read(
      key: key.name,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> _setValue({
    required SecureStorageKeys key,
    required String value,
  }) {
    return _prefs.write(
      key: key.name,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  @override
  Future<bool> containsKey(SecureStorageKeys key) async => _prefs.containsKey(
        key: key.name,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );

  @override
  Future<void> remove(SecureStorageKeys key) {
    return _prefs.delete(
      key: key.name,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  @override
  Future<void> clear() {
    return _prefs.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  // Get From Secure Storage
  @override
  Future<bool?> getBool(SecureStorageKeys key) async {
    final String? val = await _getValue(key);
    if (val == null) {
      return null;
    }
    return val.toLowerCase() == "true" ? true : false;
  }

  @override
  Future<int?> getInt(SecureStorageKeys key) async {
    final String? val = await _getValue(key);
    if (val == null) {
      return null;
    }
    return int.tryParse(val);
  }

  @override
  Future<double?> getDouble(SecureStorageKeys key) async {
    final String? val = await _getValue(key);
    if (val == null) {
      return null;
    }
    return double.tryParse(val);
  }

  @override
  Future<String?> getString(SecureStorageKeys key) async => _getValue(key);

  @override
  Future<List<String>?> getStringList(SecureStorageKeys key) async {
    final String? val = await _getValue(key);
    if (val == null) {
      return null;
    }
    return (jsonDecode(val) as List<dynamic>).cast<String>();
  }

  // Set To Secure Storage

  @override
  Future<void> setBool(SecureStorageKeys key, {required bool value}) =>
      _setValue(key: key, value: value.toString());

  @override
  Future<void> setInt(SecureStorageKeys key, int value) =>
      _setValue(key: key, value: value.toString());

  @override
  Future<void> setDouble(SecureStorageKeys key, double value) =>
      _setValue(key: key, value: value.toString());

  @override
  Future<void> setString(SecureStorageKeys key, String value) =>
      _setValue(key: key, value: value);

  @override
  Future<void> setStringList(SecureStorageKeys key, List<String> value) {
    return _setValue(key: key, value: json.encode(value));
  }
}
