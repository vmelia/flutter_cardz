import 'package:flutter/material.dart';
import '../types.dart';
import '../widgets.dart';

class ShapeView extends StatelessWidget {
  final TextureType texture;
  final ShapeType shape;
  final ColorType color;

  const ShapeView({required this.texture, required this.shape, required this.color});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 2.5, child: CustomPaint(painter: ShapePainter(texture, shape, color)));
  }
}
