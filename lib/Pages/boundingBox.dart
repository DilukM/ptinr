import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List recognitions;
  final double imageWidth;
  final double imageHeight;

  BoundingBoxPainter(this.recognitions, this.imageWidth, this.imageHeight);

  @override
  void paint(Canvas canvas, Size size) {
    for (var recognition in recognitions) {
      var _x = recognition["rect"]["x"] * imageWidth;
      var _w = recognition["rect"]["w"] * imageWidth;
      var _y = recognition["rect"]["y"] * imageHeight;
      var _h = recognition["rect"]["h"] * imageHeight;

      var rect = Rect.fromLTWH(_x, _y, _w, _h);
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
