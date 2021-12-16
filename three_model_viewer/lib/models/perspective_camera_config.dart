import 'package:three_model_viewer/utils/translate_number.dart';

class PerspectiveCameraConfig {
  double fov;
  double? aspectRatio;
  double near;
  double far;

  PerspectiveCameraConfig(
      {required this.fov,
      required this.aspectRatio,
      required this.far,
      required this.near});

  factory PerspectiveCameraConfig.def() {
    return PerspectiveCameraConfig(
        aspectRatio: null, near: .1, far: 1000, fov: 50);
  }

  @override
  String toString() {
    return '$fov, ${translateNumber(aspectRatio, [null])}';
  }
}
