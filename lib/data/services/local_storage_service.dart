import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _isLoggedIn = 'is_logged_in';

  Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedIn);
    await prefs.clear();
  }
}
