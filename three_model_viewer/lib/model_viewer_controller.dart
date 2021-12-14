class ModelViewerController {
  Function(String color, double alpha) setBackgroundColor;
  Function(double x, double y, double z) setCameraPosition;
  Function(String color, int intensity) addAmbientLight;

  ModelViewerController({
    required this.setBackgroundColor,
    required this.addAmbientLight,
    required this.setCameraPosition,
  });
}
