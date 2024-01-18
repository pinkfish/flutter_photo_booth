import 'package:camera/camera.dart';

class CameraModel {
  Future<CameraController> cameraInitialized = Future(() async {
    var camera = await availableCameras();
    var first = camera.first;
    var cameraController = CameraController(
      first,
      ResolutionPreset.high,
    );
    await cameraController!.initialize();
    return cameraController;
  });
}
