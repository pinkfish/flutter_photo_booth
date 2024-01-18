import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:froggybooth/src/components/album_qr_code.dart';
import 'package:froggybooth/src/pages/photo_booth_page.dart';

class PhotoSummaryPage extends StatelessWidget {
  const PhotoSummaryPage(
      {super.key, required this.images, required this.albumId});

  final List<XFile> images;
  final String albumId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, layout) => Column(
        children: [
          SizedBox(
            height: layout.maxHeight / 3 * 2,
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: images.map((e) => Image.file(File(e.path))).toList(),
            ),
          ),
          AlbumQrCode(albumId: albumId, size: layout.maxHeight / 3 - 50),
          OutlinedButton(
              onPressed: () => _navigateBack(context),
              child: const Text('DONE')),
        ],
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PhotoBoothPage(
          albumId: albumId,
        ),
      ),
    );
  }
}
