import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static Future<void> saveUser({
    required String fullName,
    required String email,
    required String password,
    String? imageUrl,
    String? gender,
    List<String>? favorites,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('imageUrl', imageUrl ?? '');
    await prefs.setString('gender', gender ?? '');
    await prefs.setStringList('favorites', favorites ?? []);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('isLoggedIn') ?? false)) return null;
    return {
      'fullName': prefs.getString('fullName') ?? '',
      'email': prefs.getString('email') ?? '',
      'password': prefs.getString('password') ?? '',
      'imageUrl': prefs.getString('imageUrl') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'favorites': prefs.getStringList('favorites') ?? [],
    };
  }

  static Future<bool> checkLogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString('email') == email && prefs.getString('password') == password);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
} 