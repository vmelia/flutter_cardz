import 'package:flutter/material.dart';

import '../extensions/color_type_extension.dart';
import '../types.dart';

class ShapePainter extends CustomPainter {
  final TextureType texture;
  final ShapeType shape;
  final ColorType color;

  ShapePainter(this.texture, this.shape, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint interiorPaint = getInteriorPaint(size);
    Paint borderPaint = Paint()
      ..color = color.color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    Path shape = getPath(size);
    canvas.drawPath(shape, interiorPaint);
    canvas.drawPath(shape, borderPaint);
  }

  Path getPath(Size size) {
    switch (shape) {
      case ShapeType.diamond:
        return Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width / 2, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case ShapeType.pill:
        double r = size.height / 2;
        return Path()
          ..moveTo(r, 0)
          ..lineTo(size.width - r, 0)
          ..arcToPoint(Offset(size.width - r, size.height), radius: Radius.circular(r))
          ..lineTo(r, size.height)
          ..arcToPoint(Offset(r, 0), radius: Radius.circular(r));
      case ShapeType.squiggly:
        Offset p0 = Offset(0, size.height * .6);
        Offset p1 = Offset(size.width * .55, size.height * .15);
        Offset p2 = Offset(size.width, size.height * .4);
        Offset p3 = Offset(size.width * .45, size.height * .85);

        Offset slant = Offset.fromDirection(.6);

        Offset cp0 = p0 - Offset(0, size.height * .6);
        Offset cp1 = p1 - slant * size.height * .8;
        Offset cp2 = p1 + slant * size.height * .5;
        Offset cp3 = p2 - Offset(0, size.height * 1.1);
        Offset cp4 = p2 + Offset(0, size.height * .6);
        Offset cp5 = p3 + slant * size.height * .8;
        Offset cp6 = p3 - slant * size.height * .5;
        Offset cp7 = p0 + Offset(0, size.height * 1.1);

        return Path()
          ..moveTo(p0.dx, p0.dy)
          ..cubicTo(cp0.dx, cp0.dy, cp1.dx, cp1.dy, p1.dx, p1.dy)
          ..cubicTo(cp2.dx, cp2.dy, cp3.dx, cp3.dy, p2.dx, p2.dy)
          ..cubicTo(cp4.dx, cp4.dy, cp5.dx, cp5.dy, p3.dx, p3.dy)
          ..cubicTo(cp6.dx, cp6.dy, cp7.dx, cp7.dy, p0.dx, p0.dy);
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) {
    return oldDelegate.texture != texture || oldDelegate.shape != shape || oldDelegate.color != color;
  }

  Paint getInteriorPaint(Size size) {
    switch (texture) {
      case TextureType.filled:
        return Paint()..color = color.color;
      case TextureType.outline:
        return Paint()..color = Colors.transparent;
      case TextureType.banded:
        return Paint()
          ..color = color.color
          ..shader = LinearGradient(
                  begin: Alignment.centerLeft, end: Alignment.centerRight, colors: getColors(20), stops: getStops(20))
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }
  }

  List<Color> getColors(int numberOfBands) {
    return List.generate(numberOfBands, (index) => [Colors.transparent, Colors.transparent, color.color, color.color])
            .expand((e) => e)
            .toList() +
        [Colors.transparent, Colors.transparent];
  }

  List<double> getStops(int numberOfBands) {
    return List.generate(numberOfBands, (index) {
          double start = index / (numberOfBands + .5);
          double end = (index + 1) / (numberOfBands + .5);
          double half = start + (end - start) / 2;
          return [start, half, half, end];
        }).expand((e) => e).toList() +
        [numberOfBands / (numberOfBands + .5), 1.0];
  }
}
