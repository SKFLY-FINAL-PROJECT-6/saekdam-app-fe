import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> initCameras() async {
  cameras = await availableCameras();
}
