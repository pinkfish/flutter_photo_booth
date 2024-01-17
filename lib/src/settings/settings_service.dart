
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'dart:convert';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  Settings? _settings;

  static const String settingKey = 'setting';

  Future<void> loadPrefs() async {
    if (_settings == null) {
      final prefs = await SharedPreferences.getInstance();
      var str = prefs.getString(settingKey);
      if (str == null) {
        _settings = Settings(ThemeMode.system, null);
      } else {
        var data = jsonDecode(str);
        _settings = Settings.fromJson(data);
      }
    }
  }

  Future<void> savePrefs() async {
    if (_settings != null) {
      final prefs = await SharedPreferences.getInstance();
      var data = jsonEncode(_settings!.toJson());
      await prefs.setString(settingKey, data);
    }
  }


  /// Loads the User's preferred album from local or remote storage.
  Future<String?> albumId() async {
    await loadPrefs();
    return _settings!.albumId;
  }


  /// Persists the user's preferred albumid to local or remote storage.
  Future<void> updateAlbumId(String? albumId) async {
    if (_settings == null) {
      await loadPrefs();
    }
    _settings = Settings.copy(_settings!, albumId: albumId);
    await savePrefs();
  }


  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    await loadPrefs();
    return _settings!.themeMode;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    if (_settings == null) {
      await loadPrefs();
    }
    _settings = Settings.copy(_settings!, theme: theme);
    await savePrefs();
  }
}
