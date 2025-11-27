import 'package:shared_preferences/shared_preferences.dart';

class SessionController {
  static const _lastActiveKey = "last_active";

  /// Simpan waktu saat app masuk background
  static Future<void> saveLastActive() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_lastActiveKey, now);
  }

  /// Cek apakah sudah lebih dari 60 detik
  static Future<bool> isExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_lastActiveKey);

    if (last == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = (now - last) / 1000; // detik

    return diff > 60; // timeout 1 menit
  }
}
