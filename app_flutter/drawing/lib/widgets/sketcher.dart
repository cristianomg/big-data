import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/drawn_line.dart';

class Sketcher extends CustomPainter {
  final List<DrawnLine> lines;

  Sketcher({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < lines.length; ++i) {
      // ignore: unnecessary_null_comparison
      if (lines[i] == null) continue;
      canvas.drawPoints(PointMode.points, lines[i].path, paint);

      // for (int j = 0; j < lines[i].path.length - 1; ++j) {
      //   paint.color = lines[i].color;
      //   paint.strokeWidth = lines[i].width;
      // }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
