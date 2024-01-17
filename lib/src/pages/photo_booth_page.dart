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

import 'package:flutter/material.dart';
import 'package:froggybooth/src/components/app_bar.dart';
import 'package:froggybooth/src/model/camera_model.dart';
import 'package:froggybooth/src/pages/take_photos_page.dart';
import 'package:froggybooth/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../components/last_photos.dart';
import '../components/album_qr_code.dart';
import '../model/photos_library_api_model.dart';
import '../photos_library_api/album.dart';

class PhotoBoothPage extends StatefulWidget {
  const PhotoBoothPage({super.key, required this.albumId});

  final String albumId;

  static const routeName = '/booth';

  @override
  State<StatefulWidget> createState() => _PhotoBoothPageState();
}

class _PhotoBoothPageState extends State<PhotoBoothPage> {
  _PhotoBoothPageState();

  final CameraModel cameraModel = CameraModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: FroggyAppBar(
          controller: context.read<SettingsController>(),
        ),
        body: Builder(builder: (BuildContext context) {
          return ScopedModelDescendant<PhotosLibraryApiModel>(builder:
              (BuildContext context, Widget? child,
                  PhotosLibraryApiModel apiModel) {
            return LayoutBuilder(
              builder: (context, layout) => FutureBuilder<Album>(
                  future: apiModel.getAlbum(widget.albumId),
                  builder:
                      (BuildContext context, AsyncSnapshot<Album> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          const SizedBox(height: 30),
                          FilledButton(
                            onPressed: _doPhoto,
                            child: SizedBox(
                              width: layout.maxHeight / 4,
                              height: layout.maxHeight / 4,
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: layout.maxHeight / 16 * 3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          AlbumQrCode(
                              albumId: widget.albumId,
                              size: layout.maxHeight / 3),
                          LastPhotos(
                            albumId: widget.albumId,
                            size: layout.maxHeight/4,
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            );
          });
        }));
  }

  void _doPhoto() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TakePhotoPage(
          cameraModel: cameraModel,
          albumId: widget.albumId,
        ),
      ),
    );
  }
}
