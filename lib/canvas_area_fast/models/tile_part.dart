import 'dart:ui';

import 'gravitational_object.dart';

class TilePart extends GravitationalObjectFast {
  TilePart(
      {position,
      required this.width,
      required this.height,
      required this.isLeft,
      gravitySpeed = 0.0,
      additionalForce = const Offset(0, 0),
      rotation = 0.0})
      : super(
            position: position,
            gravitySpeed: gravitySpeed,
            additionalForce: additionalForce,
            rotation: rotation);

  double width;
  double height;
  bool isLeft;
}
