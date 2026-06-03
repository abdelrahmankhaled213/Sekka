import 'package:flutter/widgets.dart';

/// Border radius scale for consistent corner rounding
class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double circle = 999;

  static const BorderRadius allXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius allSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius allMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius allLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius allXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius allXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius allXXXL = BorderRadius.all(Radius.circular(xxxl));

  static const BorderRadius topMD = BorderRadius.vertical(top: Radius.circular(md));
  static const BorderRadius topLG = BorderRadius.vertical(top: Radius.circular(lg));
  static const BorderRadius topXL = BorderRadius.vertical(top: Radius.circular(xl));
  static const BorderRadius topXXL = BorderRadius.vertical(top: Radius.circular(xxl));

  static const BorderRadius bottomMD = BorderRadius.vertical(bottom: Radius.circular(md));
  static const BorderRadius bottomLG = BorderRadius.vertical(bottom: Radius.circular(lg));
  static const BorderRadius bottomXL = BorderRadius.vertical(bottom: Radius.circular(xl));
  static const BorderRadius bottomXXL = BorderRadius.vertical(bottom: Radius.circular(xxl));
}
