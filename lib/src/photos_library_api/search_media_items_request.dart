/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:json_annotation/json_annotation.dart';

part 'search_media_items_request.g.dart';

@JsonSerializable()
class SearchMediaItemsRequest {
  SearchMediaItemsRequest(this.albumId, this.pageSize, this.pageToken,
      {this.filters, this.orderBy});

  SearchMediaItemsRequest.albumId(this.albumId,
      {this.pageSize = 10,  this.filters, this.orderBy, this.pageToken});

  factory SearchMediaItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchMediaItemsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMediaItemsRequestToJson(this);

  String albumId;
  int pageSize;
  String? pageToken;
  Map<String, DateRequestFilter>? filters;
  String? orderBy;
}

@JsonSerializable()
class DateRequestFilter {
  static const filterName = "dateFilter";

  DateRequestFilter({this.dates = const [], this.ranges = const []});

  factory DateRequestFilter.fromJson(Map<String, dynamic> json) =>
      _$DateRequestFilterFromJson(json);

  Map<String, dynamic> toJson() => _$DateRequestFilterToJson(this);

  List<DateFilterDate> dates;
  List<DateFilterRange> ranges;
}

@JsonSerializable()
class DateFilterDate {
  DateFilterDate({required this.year});

  factory DateFilterDate.fromJson(Map<String, dynamic> json) =>
      _$DateFilterDateFromJson(json);

  Map<String, dynamic> toJson() => _$DateFilterDateToJson(this);

  int year;
  int? month;
  int? day;
}

@JsonSerializable()
class DateFilterRange {
  DateFilterRange({required this.endDate, required this.startDate});

  factory DateFilterRange.fromJson(Map<String, dynamic> json) =>
      _$DateFilterRangeFromJson(json);

  Map<String, dynamic> toJson() => _$DateFilterRangeToJson(this);

  DateFilterDate startDate;
  DateFilterDate endDate;
}
