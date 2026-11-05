
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _nameKey = 'account_name';
  static const String _emailKey = 'account_email';
  static const String _phoneKey = 'account_phone';
  static const String _saltKey = 'account_salt';
  static const String _passwordHashKey = 'account_password_hash';
  static const String _sessionKey = 'logged_in_email';

  static String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(
      16,
      (_) => random.nextInt(256),
    );
    return base64Url.encode(bytes);
  }

  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');
    return sha256.convert(bytes).toString();
  }

  static Future<bool> hasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) != null;
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(_emailKey) != null) {
      return false;
    }

    final salt = _generateSalt();
    final passwordHash = _hashPassword(password, salt);

    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_emailKey, email.trim().toLowerCase());
    await prefs.setString(_phoneKey, phone.trim());
    await prefs.setString(_saltKey, salt);
    await prefs.setString(_passwordHashKey, passwordHash);

    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(_emailKey);
    final savedSalt = prefs.getString(_saltKey);
    final savedHash = prefs.getString(_passwordHashKey);

    if (savedEmail == null ||
        savedSalt == null ||
        savedHash == null) {
      return false;
    }

    if (email.trim().toLowerCase() != savedEmail) {
      return false;
    }

    final enteredHash = _hashPassword(password, savedSalt);

    if (enteredHash != savedHash) {
      return false;
    }

    await prefs.setString(_sessionKey, savedEmail);
    return true;
  }

  static Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(_emailKey);

    if (savedEmail == null ||
        email.trim().toLowerCase() != savedEmail) {
      return false;
    }

    final newSalt = _generateSalt();
    final newHash = _hashPassword(newPassword, newSalt);

    await prefs.setString(_saltKey, newSalt);
    await prefs.setString(_passwordHashKey, newHash);
    await prefs.remove(_sessionKey);

    return true;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey) != null;
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
