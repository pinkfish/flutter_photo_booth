// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
      json['albumId'] as String?,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'albumId': instance.albumId,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
