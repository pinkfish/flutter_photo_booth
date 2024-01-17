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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import '../components/app_bar.dart';
import '../model/photos_library_api_model.dart';
import '../pages/create_booth_page.dart';
import '../pages/photo_booth_page.dart';
import '../photos_library_api/album.dart';
import '../settings/settings_controller.dart';

class FroggyBoothListPage extends StatelessWidget {
  const FroggyBoothListPage({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FroggyAppBar(controller: controller,),
      body: _buildBoothList(),
    );
  }

  Widget _buildBoothList() {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget? child,
          PhotosLibraryApiModel photosLibraryApi) {
        if (!photosLibraryApi.hasAlbums) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (photosLibraryApi.albums.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/flutter_logo.svg',
                color: Colors.grey[300],
                height: 148,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You're not currently a member of any photo booth albums. "
                  'Create a new booth booth album or join an existing one below.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildButtons(context),
            ],
          );
        }

        return ListView.builder(
          itemCount: photosLibraryApi.albums.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildButtons(context);
            }

            return _buildPhotoBoothCard(
                context, photosLibraryApi.albums[index - 1], photosLibraryApi);
          },
        );
      },
    );
  }

  Widget _buildPhotoBoothCard(BuildContext context, Album sharedAlbum,
      PhotosLibraryApiModel photosLibraryApi) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 33,
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PhotoBoothPage(
              key: UniqueKey(),
              albumId: sharedAlbum.id,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: _buildPhotoBoothThumbnail(sharedAlbum),
            ),
            Container(
              height: 52,
              padding: const EdgeInsets.only(left: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                _buildSharedIcon(sharedAlbum),
                Align(
                  alignment: const FractionalOffset(0, 0.5),
                  child: Text(
                    sharedAlbum.title ?? '[no title]',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBoothThumbnail(Album sharedAlbum) {
    if (sharedAlbum.coverPhotoBaseUrl == null) {
      return Container(
        height: 160,
        width: 346,
        color: Colors.grey[200],
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset(
          'assets/images/flutter_logo.svg',
          color: Colors.grey[350],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: '${sharedAlbum.coverPhotoBaseUrl}=w346-h160-c',
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (BuildContext context, String url, Object error) {
        print(error);
        return const Icon(Icons.error);
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                       CreatePhotoBoothPage(controller: controller),
                ),
              );
            },
            child: const Text('CREATE A BOOTH ALBUM'),
          ),
        ],
      ),
    );
  }

  Widget _buildSharedIcon(Album album) {
    if (album.shareInfo != null) {
      return const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.folder_shared,
            color: Colors.black38,
          ));
    } else {
      return Container();
    }
  }
}
