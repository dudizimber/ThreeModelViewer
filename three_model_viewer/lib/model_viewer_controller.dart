import 'package:three_model_viewer/models/vector_3.dart';
import 'package:three_model_viewer/three_model_viewer.dart';

class ModelViewerController {
  Function(String color, double alpha) setBackgroundColor;
  Function(Vector3 pos) setCameraPosition;
  Function(Vector3 pos) setCameraRotation;
  Function(String color, int intensity) addAmbientLight;
  Function(DirectionalLight light) addDirectionalLight;
  Function() lockTarget;
  Function(bool enable) enableZoom;

  ModelViewerController({
    required this.setBackgroundColor,
    required this.addAmbientLight,
    required this.setCameraPosition,
    required this.setCameraRotation,
    required this.addDirectionalLight,
    required this.lockTarget,
    required this.enableZoom,
  });
}
