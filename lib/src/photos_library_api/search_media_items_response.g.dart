// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_media_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMediaItemsResponse _$SearchMediaItemsResponseFromJson(
        Map<String, dynamic> json) =>
    SearchMediaItemsResponse(
      mediaItems: (json['mediaItems'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$SearchMediaItemsResponseToJson(
        SearchMediaItemsResponse instance) =>
    <String, dynamic>{
      'mediaItems': instance.mediaItems,
      'nextPageToken': instance.nextPageToken,
    };
