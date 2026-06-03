import 'package:flutter/widgets.dart';

/// Spacing scale for consistent padding and margins
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  // Edge insets helpers
  static const EdgeInsets allXS = EdgeInsets.all(xs);
  static const EdgeInsets allSM = EdgeInsets.all(sm);
  static const EdgeInsets allMD = EdgeInsets.all(md);
  static const EdgeInsets allLG = EdgeInsets.all(lg);
  static const EdgeInsets allXL = EdgeInsets.all(xl);
  static const EdgeInsets allXXL = EdgeInsets.all(xxl);
  static const EdgeInsets allXXXL = EdgeInsets.all(xxxl);

  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets horizontalXXXL = EdgeInsets.symmetric(horizontal: xxxl);

  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(vertical: xxl);

  static const EdgeInsets onlyTopSM = EdgeInsets.only(top: sm);
  static const EdgeInsets onlyTopMD = EdgeInsets.only(top: md);
  static const EdgeInsets onlyTopLG = EdgeInsets.only(top: lg);

  static const EdgeInsets onlyBottomSM = EdgeInsets.only(bottom: sm);
  static const EdgeInsets onlyBottomMD = EdgeInsets.only(bottom: md);
  static const EdgeInsets onlyBottomLG = EdgeInsets.only(bottom: lg);
  static const EdgeInsets onlyBottomXL = EdgeInsets.only(bottom: xl);

  static const EdgeInsets onlyLeftSM = EdgeInsets.only(left: sm);
  static const EdgeInsets onlyLeftMD = EdgeInsets.only(left: md);
  static const EdgeInsets onlyLeftLG = EdgeInsets.only(left: lg);

  static const EdgeInsets onlyRightSM = EdgeInsets.only(right: sm);
  static const EdgeInsets onlyRightMD = EdgeInsets.only(right: md);
  static const EdgeInsets onlyRightLG = EdgeInsets.only(right: lg);
}
