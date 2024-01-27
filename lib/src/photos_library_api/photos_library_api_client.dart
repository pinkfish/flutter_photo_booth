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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import '../photos_library_api/album.dart';
import 'package:http/http.dart' as http;
import '../photos_library_api/batch_create_media_items_request.dart';
import '../photos_library_api/batch_create_media_items_response.dart';
import '../photos_library_api/create_album_request.dart';
import '../photos_library_api/get_album_request.dart';
import '../photos_library_api/join_shared_album_request.dart';
import '../photos_library_api/join_shared_album_response.dart';
import '../photos_library_api/list_albums_response.dart';
import '../photos_library_api/list_shared_albums_response.dart';
import '../photos_library_api/search_media_items_request.dart';
import '../photos_library_api/search_media_items_response.dart';
import '../photos_library_api/share_album_request.dart';
import '../photos_library_api/share_album_response.dart';
import 'package:path/path.dart' as path;

class PhotosLibraryApiClient {
  PhotosLibraryApiClient(this._account);

  final GoogleSignInAccount? _account;
  Map<String, String>? _authHeaders;

  Future<Map<String, String>> getAuthHeaders() async {
    if (_account == null) {
      print("null account");
      return {};
    }
    _authHeaders = await _account.authHeaders;
    return _authHeaders ?? {};
  }

  Future<Album> createAlbum(CreateAlbumRequest request) async {
    final response = await http.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/albums'),
      body: jsonEncode(request),
      headers: await getAuthHeaders(),
    );

    printError(response);

    return Album.fromJson(jsonDecode(response.body));
  }

  Future<JoinSharedAlbumResponse> joinSharedAlbum(
      JoinSharedAlbumRequest request) async {
    final response = await http.post(
        Uri.parse('https://photoslibrary.googleapis.com/v1/sharedAlbums:join'),
        headers: await getAuthHeaders(),
        body: jsonEncode(request));

    printError(response);

    return JoinSharedAlbumResponse.fromJson(jsonDecode(response.body));
  }

  Future<ShareAlbumResponse> shareAlbum(ShareAlbumRequest request) async {
    final response = await http
        .post(
            Uri.parse(
                'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}:share'),
            headers: await getAuthHeaders())
        .timeout(const Duration(seconds: 20));

    printError(response);

    return ShareAlbumResponse.fromJson(jsonDecode(response.body));
  }

  Future<Album> getAlbum(GetAlbumRequest request) async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}'),
          headers: await getAuthHeaders());
      if (response.statusCode == 401) {
        if (_account != null) {
          await _account.clearAuthCache();
          var auth = await _account.authentication;
          return getAlbum(request);
        }
      }
      printError(response);

      return Album.fromJson(jsonDecode(response.body));
    } catch (e, stack) {
      print(e);
      print(stack);
      return Album.toCreate('igloo', id: request.albumId);
    }
  }

  Future<ListAlbumsResponse> listAlbums() async {
    final response = await http.get(
        Uri.parse('https://photoslibrary.googleapis.com/v1/albums?'
            'pageSize=50&excludeNonAppCreatedData=true'),
        headers: await getAuthHeaders());

    printError(response);

    if (kDebugMode) {
      print(response.headers);
      print(response.body);
    }

    return ListAlbumsResponse.fromJson(jsonDecode(response.body));
  }

  Future<ListSharedAlbumsResponse> listSharedAlbums() async {
    final response = await http.get(
        Uri.parse('https://photoslibrary.googleapis.com/v1/sharedAlbums?'
            'pageSize=50&excludeNonAppCreatedData=true'),
        headers: await getAuthHeaders());

    printError(response);

    if (kDebugMode) {
      print(response.body);
    }

    return ListSharedAlbumsResponse.fromJson(jsonDecode(response.body));
  }

  Future<String> uploadMediaItem(File image) async {
    // Get the filename of the image
    final filename = path.basename(image.path);

    // Set up the headers required for this request.
    final headers = <String, String>{};
    headers.addAll(await getAuthHeaders());
    headers['Content-type'] = 'application/octet-stream';
    headers['X-Goog-Upload-Protocol'] = 'raw';
    headers['X-Goog-Upload-File-Name'] = filename;

    // Make the HTTP request to upload the image. The file is sent in the body.
    final response = await http.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/uploads'),
      body: image.readAsBytesSync(),
      headers: await getAuthHeaders(),
    );

    printError(response);

    return response.body;
  }

  Future<SearchMediaItemsResponse> searchMediaItems(
      SearchMediaItemsRequest request) async {
    final response = await http.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search'),
      body: jsonEncode(request),
      headers: await getAuthHeaders(),
    );

    printError(response);

    return SearchMediaItemsResponse.fromJson(jsonDecode(response.body));
  }

  Future<BatchCreateMediaItemsResponse> batchCreateMediaItems(
      BatchCreateMediaItemsRequest request) async {
    final response = await http.post(
        Uri.parse(
            'https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate'),
        body: jsonEncode(request),
        headers: await getAuthHeaders());

    printError(response);

    return BatchCreateMediaItemsResponse.fromJson(jsonDecode(response.body));
  }

  static void printError(final Response response) {
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
      print(response.body);
    }
  }
}
