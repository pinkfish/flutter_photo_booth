import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/camera_model.dart';

import '../model/photos_library_api_model.dart';
import 'countdown_display.dart';

class PhotoCountdown extends StatefulWidget {
  const PhotoCountdown(
      {super.key,
      required this.cameraModel,
      required this.streamController,
      required this.albumId});

  final CameraModel cameraModel;
  final String albumId;

  final StreamController<XFile?> streamController;

  @override
  State<StatefulWidget> createState() => _PhotoCountdownState();
}

class _PhotoCountdownState extends State<PhotoCountdown>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<PhotosLibraryApiModel>(
        builder: (context, child, apiModel) => LayoutBuilder(
          builder: (context, layout) => AnimatedBuilder(
            builder: (BuildContext context, Widget? child) {
              Widget child;
              if (_controller.isAnimating) {
                child = Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          FutureBuilder(
                              future: widget.cameraModel.cameraInitialized,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CameraPreview(snapshot.data!);
                                }
                                return const SizedBox(height: 10);
                              }),
                          SizedBox(
                            height: layout.maxHeight,
                            child: Center(
                              child: CountdownDisplay(
                                animation: Tween<double>(
                                  begin: 6,
                                  end: 1,
                                ).animate(_controller),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                // Take the photo and then display it.
                child = FutureBuilder(
                    future: takePicture(apiModel),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          return Image.file(File(snapshot.data!.path));
                        }
                        return const Text("Oh dear");
                      }
                      return const Center(
                          child: Icon(Icons.camera_alt, size: 300));
                    });
              }
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200), child: child);
            },
            animation: StepTween(begin: 0, end: 15).animate(_controller),
          ),
        ),
      ),
    );
  }

  Future<XFile?> takePicture(PhotosLibraryApiModel apiModel) async {
    try {
      var controller = await widget.cameraModel.cameraInitialized;
      var img = await controller.takePicture();
      // Wait 5 seconds, then restart.
      Timer(const Duration(seconds: 2), () => widget.streamController.add(img));
      apiModel.uploadMediaItem(File(img.path)).then((id) async {
        var response = await apiModel.createMediaItem(
            id, widget.albumId, 'Photo booth photo');
        if (response.newMediaItemResults.isEmpty) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload photo')));
        }
      });

      return img;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
      Timer(
          const Duration(seconds: 2), () => widget.streamController.add(null));
      const snackBar = SnackBar(
        content: Text('Failed to take photo'),
      );

      if (!context.mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }
}