import 'dart:math' as math;
import 'package:flutter/material.dart';

class ColorWheelCrash extends CustomPainter {
  ColorWheelCrash({
    this.crashMe = false,
    this.width = 16,
  });
  final bool crashMe;
  final double width;

  double radius(Size size) =>
      math.min(size.width, size.height).toDouble() / 2 - (width / 2);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = this.radius(size);

    const SweepGradient colorWheelGradient =
    SweepGradient(center: Alignment(1.5, 1.5), colors: [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 255, 255, 0),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 0, 255, 255),
      Color.fromARGB(255, 0, 0, 255),
      Color.fromARGB(255, 255, 0, 255),
      Color.fromARGB(255, 255, 0, 0),
    ]);

    // If we create a shader from the above SweepGraident, we get
    // a crash on web, but only on web.
    final Shader sweepShader = crashMe
        ? colorWheelGradient.createShader(Rect.fromLTWH(0, 0, radius, radius))
        : null;

    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..shader = sweepShader);
  }

  @override
  bool shouldRepaint(ColorWheelCrash other) => true;
}

// *****************************************************************************

class ColorWheelOK extends CustomPainter {
  const ColorWheelOK({
    this.ticks = 360,
    this.width = 16,
  });

  final int ticks;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    const double rads = (2 * math.pi) / 360;
    const double step = 1.0;
    const double aliasing = 0.5;

    for (int i = 0; i < ticks; i++) {
      final double sRad = (i - aliasing) * rads;
      final double eRad = (i + step) * rads;
      final Rect rect = Rect.fromLTWH(
          width / 2, width / 2, size.width - width, size.height - width);
      final Paint segmentPaint = Paint()
        ..color = HSVColor.fromAHSV(1.0, i.toDouble(), 1.0, 1.0).toColor()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
      canvas.drawArc(
        rect,
        sRad,
        sRad - eRad,
        false,
        segmentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ColorWheelOK oldDelegate) {
    return oldDelegate.ticks != ticks;
  }
}