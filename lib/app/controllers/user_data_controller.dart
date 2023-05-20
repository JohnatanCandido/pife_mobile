import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserDataController {

  static void save(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is Map<String, dynamic>) {
      prefs.setString(key, jsonEncode(value));
    } else if (value is List) {
      List<String> list = [];
      for (Object item in value) {
        list.add(jsonEncode(item));
      }
      prefs.setStringList(key, list);
    }
  }

  static Future<Object?> load(String key, String type) async {
    final prefs = await SharedPreferences.getInstance();
    switch (type.toLowerCase()) {
      case 'string':
        return prefs.getString(key);
      case 'int':
        return prefs.getInt(key);
      case 'list':
        return prefs.getStringList(key);
    }
    return null;
  }

  static void remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}