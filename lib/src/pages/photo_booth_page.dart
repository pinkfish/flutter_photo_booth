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

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../components/app_bar.dart';
import '../model/camera_model.dart';
import 'take_photos_page.dart';
import '../settings/settings_controller.dart';
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
  final CameraModel cameraModel = CameraModel();

  @override
  void initState() {
    super.initState();

    // Disable wakelock once we have the photo booth page up.
    WakelockPlus.enable();
  }

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
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      print(snapshot.stackTrace);
                      return Text("Failed to load album");
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Press the photo button to take a series of four photos '
                              'use the QR code to join the album',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              snapshot.data?.title ?? 'Unknown title',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 30),
                            ),
                          ),
                          FilledButton(
                            onPressed: _doPhoto,
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.green),
                            ),
                            child: SizedBox(
                              width: layout.maxHeight / 4,
                              height: layout.maxHeight / 4,
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: layout.maxHeight / 6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Expanded(
                            child: AlbumQrCode(
                              albumId: widget.albumId,
                            ),
                          ),
                          const SizedBox(height: 10),
                          LastPhotos(
                            albumId: widget.albumId,
                            size: layout.maxHeight / 4,
                          ),
                          const SizedBox(height: 10),
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
