// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_shared_albums_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSharedAlbumsResponse _$ListSharedAlbumsResponseFromJson(
        Map<String, dynamic> json) =>
    ListSharedAlbumsResponse(
      json['nextPageToken'] as String,
      sharedAlbums: (json['sharedAlbums'] as List<dynamic>?)
              ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ListSharedAlbumsResponseToJson(
        ListSharedAlbumsResponse instance) =>
    <String, dynamic>{
      'sharedAlbums': instance.sharedAlbums,
      'nextPageToken': instance.nextPageToken,
    };
