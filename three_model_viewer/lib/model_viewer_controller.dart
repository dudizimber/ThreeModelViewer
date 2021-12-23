import 'package:three_model_viewer/models/vector_3.dart';
import 'package:three_model_viewer/three_model_viewer.dart';

class ModelViewerController {
  Function(String color, double alpha) setBackgroundColor;
  Function(Vector3 pos) setCameraPosition;
  Function(Vector3 pos) setCameraRotation;
  Function(String color, int intensity) addAmbientLight;
  Function(DirectionalLight light) addDirectionalLight;
  Function(bool enable) enableZoom;
  Function(Vector3 pos) setControlsTarget;
  Function(OrbitControls orbitControls) setOrbitControls;
  Function(bool enable) setStats;

  ModelViewerController({
    required this.setBackgroundColor,
    required this.addAmbientLight,
    required this.setCameraPosition,
    required this.setCameraRotation,
    required this.addDirectionalLight,
    required this.enableZoom,
    required this.setControlsTarget,
    required this.setOrbitControls,
    required this.setStats,
  });
}
