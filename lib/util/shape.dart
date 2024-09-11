import 'package:flutter/material.dart';

class RectangularHoleClipper extends CustomClipper<Path> {
  final double holeWidth; // Width of the hole
  final double holeHeight; // Height of the hole
  final double borderRadius; // Border radius of the hole

  RectangularHoleClipper(
      {required this.holeWidth,
      required this.holeHeight,
      required this.borderRadius});

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect); // Add the entire rectangle

    final holeRect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: holeWidth,
        height: holeHeight);

    // Add a rounded rectangle to create the hole
    path.addRRect(RRect.fromRectAndCorners(holeRect,
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius)));

    return path;
  }

  @override
  bool shouldReclip(covariant RectangularHoleClipper oldClipper) =>
      holeWidth != oldClipper.holeWidth ||
      holeHeight != oldClipper.holeHeight ||
      borderRadius != oldClipper.borderRadius;
}
