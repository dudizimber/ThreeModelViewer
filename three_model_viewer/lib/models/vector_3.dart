import 'package:flutter/material.dart';

class Vector3 {
  double x;
  double y;
  double z;
  Vector3({required this.x, required this.y, required this.z});

  @override
  String toString({bool map = false}) {
    return '${map ? '{x: $x' : '$x'}, ${map ? 'y: $y' : '$y'}, ${map ? 'z: $z}' : '$z'}';
  }
}
