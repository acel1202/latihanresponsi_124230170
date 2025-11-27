import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<bool> login(String username, String password, bool remember) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil user hasil register
    final regUser = prefs.getString("reg_username");
    final regPass = prefs.getString("reg_password");

    // Login jika cocok (register ataupun default)
    if ((username == regUser && password == regPass) ||
        (username == "acel" && password == "123")) {
      final expiry = DateTime.now()
          .add(const Duration(minutes: 1)) // SESSION TIME 1 MINUTE
          .microsecondsSinceEpoch;

      await prefs.setBool('isLogin', true);
      await prefs.setInt('expiry', expiry);

      if (remember) {
        await prefs.setString('savedUsername', username);
      } else {
        await prefs.remove('savedUsername');
      }
      return true;
    }

    return false;
  }

  Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reg_username', username);
    await prefs.setString('reg_password', password);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', false);
    await prefs.remove('expiry');
  }

  Future<bool> isStillLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    final expiry = prefs.getInt('expiry') ?? 0;

    final now = DateTime.now().microsecondsSinceEpoch;
    return isLogin && now < expiry;
  }

  Future<String?> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('savedUsername');
  }
}
