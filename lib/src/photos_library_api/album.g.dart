// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      json['id'] as String,
      json['productUrl'] as String?,
      json['shareInfo'] == null
          ? null
          : ShareInfo.fromJson(json['shareInfo'] as Map<String, dynamic>),
      mediaItemsCount: json['mediaItemsCount'] as String? ?? '0',
      isWriteable: json['isWriteable'] as bool? ?? false,
      title: json['title'] as String?,
      coverPhotoMediaItemId: json['coverPhotoMediaItemId'] as String?,
      coverPhotoBaseUrl: json['coverPhotoBaseUrl'] as String?,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'productUrl': instance.productUrl,
      'isWriteable': instance.isWriteable,
      'shareInfo': instance.shareInfo,
      'mediaItemsCount': instance.mediaItemsCount,
      'coverPhotoBaseUrl': instance.coverPhotoBaseUrl,
      'coverPhotoMediaItemId': instance.coverPhotoMediaItemId,
    };

ShareInfo _$ShareInfoFromJson(Map<String, dynamic> json) => ShareInfo(
      json['sharedAlbumOptions'] == null
          ? null
          : SharedAlbumOptions.fromJson(
              json['sharedAlbumOptions'] as Map<String, dynamic>),
      json['shareableUrl'] as String,
      json['shareToken'] as String,
      json['isJoined'] as bool,
    );

Map<String, dynamic> _$ShareInfoToJson(ShareInfo instance) => <String, dynamic>{
      'sharedAlbumOptions': instance.sharedAlbumOptions,
      'shareableUrl': instance.shareableUrl,
      'shareToken': instance.shareToken,
      'isJoined': instance.isJoined,
    };

SharedAlbumOptions _$SharedAlbumOptionsFromJson(Map<String, dynamic> json) =>
    SharedAlbumOptions(
      isCollaborative: json['isCollaborative'] as bool? ?? false,
      isCommentable: json['isCommentable'] as bool? ?? false,
    );

Map<String, dynamic> _$SharedAlbumOptionsToJson(SharedAlbumOptions instance) =>
    <String, dynamic>{
      'isCollaborative': instance.isCollaborative,
      'isCommentable': instance.isCommentable,
    };
