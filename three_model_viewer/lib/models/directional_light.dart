import 'package:flutter/material.dart';
import 'package:three_model_viewer/models/vector_3.dart';

class DirectionalLight {
  Vector3 pos;
  Color color;
  double intensity;

  DirectionalLight(
      {this.color = Colors.white, this.intensity = 10, required this.pos});

  @override
  String toString({bool map = false}) {
    return '\'#${color.value.toRadixString(16).substring(2)}\', $intensity, ${pos.toString(map: map)}';
  }
}
