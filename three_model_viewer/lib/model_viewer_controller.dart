class ModelViewerController {
  Function(String color, double alpha) setBackgroundColor;
  Function(double x, double y, double z) setCameraPosition;
  Function(double x, double y, double z) setCameraRotation;
  Function(String color, int intensity) addAmbientLight;
  Function(String color, int intensity, Map<String, num>) addDirectionalLight;

  ModelViewerController({
    required this.setBackgroundColor,
    required this.addAmbientLight,
    required this.setCameraPosition,
    required this.setCameraRotation,
    required this.addDirectionalLight,
  });
}
