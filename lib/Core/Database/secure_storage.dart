import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  final _storage = const FlutterSecureStorage();

  static const _fcmKey = "ffcm_tokenn2";

  Future<void> saveFcmToken(String token) async {
    await _storage.write(key: _fcmKey, value: token);
  }


  Future<String?> getFcmToken() async {
    return await _storage.read(key: _fcmKey);
  }

  Future<void> deleteFcmToken() async {
    await _storage.delete(key: _fcmKey);
  }
}