import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginDataCtrl {
  Future<void> saveLoginData(String id, String pw) async {
    final prefs = FlutterSecureStorage();
    await prefs.write(key: 'user_id', value: id);
    await prefs.write(key: 'user_pw', value: pw);
  }

  Future<Map<String, String>> loadLoginData() async {
    final prefs = FlutterSecureStorage();

    return {
      'user_id': (await prefs.read(key: 'user_id')) ?? '',
      'user_pw': (await prefs.read(key: 'user_pw')) ?? ''
    };
  }

  Future<void> removeLoginData() async {
    final prefs = FlutterSecureStorage();
    await prefs.delete(key: 'user_id');
    await prefs.delete(key: 'user_pw');
  }
}
