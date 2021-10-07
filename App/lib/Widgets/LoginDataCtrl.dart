import 'package:shared_preferences/shared_preferences.dart';

class LoginDataCtrl {
  Future<bool> saveLoginData(String id, String pw) async {
    final prefs = await SharedPreferences.getInstance();
    return (await prefs.setString('user_id', id)) &&
        (await prefs.setString('user_pw', pw));
  }

  Future<Map<String, String>> loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'user_id': prefs.getString('user_id') ?? '',
      'user_pw': prefs.getString('user_pw') ?? ''
    };
  }

  Future<bool> removeLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    return (await prefs.remove('user_id')) && (await prefs.remove('user_pw'));
  }
}
