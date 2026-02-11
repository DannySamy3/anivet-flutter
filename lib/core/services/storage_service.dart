import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Save JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Get JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Delete JWT token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Save user data as JSON
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final userJson = jsonEncode(userData);
    await _storage.write(key: 'user_data', value: userJson);
  }

  // Get user data
  Future<Map<String, dynamic>?> getUser() async {
    final userJson = await _storage.read(key: 'user_data');
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  // Delete user data
  Future<void> deleteUser() async {
    await _storage.delete(key: 'user_data');
  }

  // Save theme mode
  Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: 'theme_mode', value: mode);
  }

  // Get theme mode
  Future<String?> getThemeMode() async {
    return await _storage.read(key: 'theme_mode');
  }

  // Save locale
  Future<void> saveLocale(String locale) async {
    await _storage.write(key: 'locale', value: locale);
  }

  // Get locale
  Future<String?> getLocale() async {
    return await _storage.read(key: 'locale');
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Generic save
  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Generic read
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Generic delete
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
