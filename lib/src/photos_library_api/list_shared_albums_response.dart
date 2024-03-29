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
import '../photos_library_api/album.dart';

part 'list_shared_albums_response.g.dart';

@JsonSerializable()
class ListSharedAlbumsResponse {
  ListSharedAlbumsResponse(this.nextPageToken, {this.sharedAlbums = const []});

  factory ListSharedAlbumsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListSharedAlbumsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListSharedAlbumsResponseToJson(this);

  List<Album> sharedAlbums;
  String nextPageToken;
}
