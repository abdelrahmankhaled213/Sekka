import 'package:flutter/animation.dart';

class AnimationHelper {
  static Animation<T> buildAnimation<T>({
    required double start,
    required double end,
    required AnimationController animationController,
    required Tween<T> tween,
    Curve curve = Curves.easeOut,
  }) {
    return tween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: curve),
      ),
    );
  }
}