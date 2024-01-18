// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_albums_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAlbumsResponse _$ListAlbumsResponseFromJson(Map<String, dynamic> json) =>
    ListAlbumsResponse(
      json['nextPageToken'] as String,
      albums: (json['albums'] as List<dynamic>?)
              ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ListAlbumsResponseToJson(ListAlbumsResponse instance) =>
    <String, dynamic>{
      'albums': instance.albums,
      'nextPageToken': instance.nextPageToken,
    };
