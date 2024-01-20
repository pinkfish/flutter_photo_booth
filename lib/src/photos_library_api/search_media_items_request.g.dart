// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_media_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMediaItemsRequest _$SearchMediaItemsRequestFromJson(
        Map<String, dynamic> json) =>
    SearchMediaItemsRequest(
      json['albumId'] as String,
      json['pageSize'] as int,
      json['pageToken'] as String?,
      filters: (json['filters'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, DateRequestFilter.fromJson(e as Map<String, dynamic>)),
      ),
      orderBy: json['orderBy'] as String?,
    );

Map<String, dynamic> _$SearchMediaItemsRequestToJson(
        SearchMediaItemsRequest instance) =>
    <String, dynamic>{
      'albumId': instance.albumId,
      'pageSize': instance.pageSize,
      'pageToken': instance.pageToken,
      'filters': instance.filters,
      'orderBy': instance.orderBy,
    };

DateRequestFilter _$DateRequestFilterFromJson(Map<String, dynamic> json) =>
    DateRequestFilter(
      dates: (json['dates'] as List<dynamic>?)
              ?.map((e) => DateFilterDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ranges: (json['ranges'] as List<dynamic>?)
              ?.map((e) => DateFilterRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DateRequestFilterToJson(DateRequestFilter instance) =>
    <String, dynamic>{
      'dates': instance.dates,
      'ranges': instance.ranges,
    };

DateFilterDate _$DateFilterDateFromJson(Map<String, dynamic> json) =>
    DateFilterDate(
      year: json['year'] as int,
    )
      ..month = json['month'] as int?
      ..day = json['day'] as int?;

Map<String, dynamic> _$DateFilterDateToJson(DateFilterDate instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };

DateFilterRange _$DateFilterRangeFromJson(Map<String, dynamic> json) =>
    DateFilterRange(
      endDate: DateFilterDate.fromJson(json['endDate'] as Map<String, dynamic>),
      startDate:
          DateFilterDate.fromJson(json['startDate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DateFilterRangeToJson(DateFilterRange instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
