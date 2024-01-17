import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../components/photo_countdown.dart';
import '../components/photo_summary.dart';
import '../model/camera_model.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage(
      {super.key, required this.cameraModel, required this.albumId});

  final CameraModel cameraModel;
  final String albumId;

  @override
  State<StatefulWidget> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage>
    with TickerProviderStateMixin {
  static const maxImages = 4;
  final List<XFile> _images = [];

  final StreamController<XFile?> _streamController = StreamController<XFile?>();

  late int _photoNumber;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _photoNumber = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            _photoNumber++;
            if (_images.length >= maxImages) {
              return PhotoSummaryPage(
                images: _images,
                albumId: widget.albumId,
              );
            } else if (data != null &&
                !_images.any((element) => element.path == data.path)) {
              _images.add(data);
            }
          }
          return PhotoCountdown(
              key: Key('Photo$_photoNumber'),
              cameraModel: widget.cameraModel,
              albumId: widget.albumId,
              streamController: _streamController);
        },
      ),
    );
  }
}
