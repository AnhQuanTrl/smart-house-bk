import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage _instance;
  FlutterSecureStorage storage;
  SecureStorage._internal() {
    storage = new FlutterSecureStorage();
  }

  static SecureStorage get instance {
    if (_instance != null) {
      return _instance;
    } else {
      return SecureStorage._internal();
    }
  }
}
