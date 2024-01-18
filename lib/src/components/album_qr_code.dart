import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/photos_library_api_model.dart';
import '../photos_library_api/album.dart';

class AlbumQrCode extends StatelessWidget {
  const AlbumQrCode({super.key, required this.albumId, required this.size});

  final String albumId;
  final double size;

  Future<void> _shareAlbum(
      BuildContext context, Album album, PhotosLibraryApiModel apiModel) async {
    var snackBar = const SnackBar(
      duration: Duration(seconds: 3),
      content: Text('Sharing Album...'),
    );

    // Share the album and update the local model
    var response = await apiModel.shareAlbum(album.id);

    if (kDebugMode) {
      print(response);
      print('Album has been shared.');
    }
  }

  Widget _qrCode(
      BuildContext context, Album album, PhotosLibraryApiModel apiModel) {
    if (album.shareInfo == null) {
       if (kDebugMode) {
        print('Not shared, sharing album first.');
      }

      return FutureBuilder(
          future: _shareAlbum(context, album, apiModel),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.hasData) {
              return QrImageView(
                data: album.shareInfo!.shareableUrl,
                size: size,
                version: QrVersions.auto,
              );
            }
            return const CircularProgressIndicator();
          });
    } else {
      // Album is already shared, display dialog with URL
      return QrImageView(
        data: album.shareInfo!.shareableUrl,
        size: size,
        version: QrVersions.auto,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(builder:
        (BuildContext context, Widget? child, PhotosLibraryApiModel apiModel) {
      return FutureBuilder<Album>(
          future: apiModel.getAlbum(albumId),
          builder: (BuildContext context, AsyncSnapshot<Album> snapshot) {
            if (snapshot.hasData) {
              return _qrCode(context, snapshot.data!, apiModel);
            }
            return const Text("Loading album");
          });
    });
  }
}
