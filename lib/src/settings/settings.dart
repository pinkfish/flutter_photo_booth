import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  Settings(this.themeMode, this.albumId);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  factory Settings.copy(Settings settings, {ThemeMode? theme, String? albumId}) =>
      Settings(theme ?? settings.themeMode, albumId ?? settings.albumId);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  ThemeMode themeMode;

  String? albumId;
}
