import 'package:three_model_viewer/utils/translate_infinity.dart';

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
    return '${translateInfinity(minPolarAngle)}, ${translateInfinity(maxPolarAngle)}, ${translateInfinity(minAzimuthAngle)}, ${translateInfinity(maxAzimuthAngle)}';
  }
}
