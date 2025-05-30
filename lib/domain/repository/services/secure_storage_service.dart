enum SecureStorageKeys {
  deviceID;
}

abstract class SecureStorageService {
  Future<int?> getInt(SecureStorageKeys key);
  Future<bool?> getBool(SecureStorageKeys key);
  Future<double?> getDouble(SecureStorageKeys key);
  Future<String?> getString(SecureStorageKeys key);
  Future<List<String>?> getStringList(SecureStorageKeys key);

  Future<bool> containsKey(SecureStorageKeys key);

  Future<void> setInt(SecureStorageKeys key, int value);
  Future<void> setBool(SecureStorageKeys key, {required bool value});
  Future<void> setDouble(SecureStorageKeys key, double value);
  Future<void> setString(SecureStorageKeys key, String value);
  Future<void> setStringList(SecureStorageKeys key, List<String> value);

  Future<void> clear();
  Future<void> remove(SecureStorageKeys key);
}
