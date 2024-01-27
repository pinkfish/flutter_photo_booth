import 'dart:async';

import 'package:camera/camera.dart';

///
/// Keeps track of all the fun stuff about the camera for use in the app/
///
class CameraModel {
  CameraDescription? _camera;
  CameraController? _controller;

  Future<CameraController> newController() async {
    if (_camera == null) {
      var cameras = await availableCameras();
      for (var c in cameras) {
        print('camera $c');
        if (c.lensDirection == CameraLensDirection.front) {
          _camera = c;
        }
      }
    }
    if (_camera != null) {
      if (_controller != null) {
        return _controller!;
      }
       _controller = CameraController(
        _camera!,
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();
      return _controller!;
    }
    throw CameraException("bad load", "bad time loading the controller");
  }
}
