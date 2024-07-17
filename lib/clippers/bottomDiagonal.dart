import 'package:flutter/material.dart';

class BottomDiagonal extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    // path.moveTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(width, height - 80);
    path.lineTo(width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
