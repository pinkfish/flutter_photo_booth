import 'dart:async';

import 'package:camera/camera.dart';

///
/// Keeps track of all the fun stuff about the camera for use in the app/
///
class CameraModel {
  CameraDescription? _camera;

  Future<CameraController> newController() async {
    if (_camera == null) {
      var cameras = await availableCameras();
      for (var c in cameras) {
        if (c.lensDirection == CameraLensDirection.front) {
          _camera = c;
        }
      }
    }
    if (_camera != null) {
      var cameraController = CameraController(
        _camera!,
        ResolutionPreset.high,
      );
      await cameraController!.initialize();
      return cameraController;
    }
    throw CameraException("bad load", "bad time loading the controller");
  }
}
