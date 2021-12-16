import 'package:three_model_viewer/utils/translate_number.dart';

class OrbitControls {
  double minPolarAngle;
  double maxPolarAngle;

  double minAzimuthAngle;
  double maxAzimuthAngle;

  OrbitControls({
    this.minPolarAngle = -double.infinity,
    this.maxPolarAngle = double.infinity,
    this.minAzimuthAngle = -double.infinity,
    this.maxAzimuthAngle = double.infinity,
  });

  @override
  String toString() {
    return '${translateNumber(minPolarAngle, [
          double.infinity,
          -double.infinity
        ])}, ${translateNumber(maxPolarAngle, [
          double.infinity,
          -double.infinity
        ])}, ${translateNumber(minAzimuthAngle, [
          double.infinity,
          -double.infinity
        ])}, ${translateNumber(maxAzimuthAngle, [
          double.infinity,
          -double.infinity
        ])}';
  }
}
