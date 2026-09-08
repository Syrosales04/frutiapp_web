import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _rememberUserKey = 'recordarUsuario';
  static const _savedUserKey = 'usuarioRecordado';

  Future<String?> loadRememberedUser() async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(_rememberUserKey) != true) return null;
    return preferences.getString(_savedUserKey);
  }

  Future<void> saveRememberedUser(String user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_rememberUserKey, true);
    await preferences.setString(_savedUserKey, user);
  }

  Future<void> clearRememberedUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_rememberUserKey, false);
    await preferences.remove(_savedUserKey);
  }
}
