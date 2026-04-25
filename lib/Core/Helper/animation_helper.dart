import 'package:flutter/widgets.dart';

abstract class AnimationHelper {

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

  static Tween<Offset> _slideTweenByLanguageCode(
    String? languageCode, {
    double distance = 1,
  }) {
    final isArabic = (languageCode ?? '').toLowerCase().startsWith('ar');

    return Tween<Offset>(
      begin: Offset(isArabic ? distance : -distance, 0),
      end: Offset.zero,
    );
  }

  static Tween<Offset> slideTweenByContext(
    BuildContext context, {
    double distance = 1,
  }) {

    final languageCode =
        Localizations.maybeLocaleOf(context)?.languageCode ??
            WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return _slideTweenByLanguageCode(languageCode, distance: distance);
  }


  static Animation<Offset> buildLocalizedSlideAnimation({
    required double start,
    required double end,
    required AnimationController animationController,
    required String? languageCode,
    Curve curve = Curves.easeOut,
    double distance = 1,
  }) {
    return buildAnimation<Offset>(
      start: start,
      end: end,
      animationController: animationController,
      tween: _slideTweenByLanguageCode(
        languageCode,
        distance: distance,
      ),
      curve: curve,
    );
  }

  /// Prefer [buildLocalizedSlideAnimation] with an explicit [languageCode] from
  /// [didChangeDependencies], or pass [languageCode] from `Localizations.localeOf(context)` there.
  /// Do **not** call from [State.initState] — [context] must not depend on [Localizations] yet.
  static Animation<Offset> buildContextLocalizedSlideAnimation({
    required double start,
    required double end,
    required AnimationController animationController,
    required BuildContext context,
    Curve curve = Curves.easeOut,
    double distance = 1,
  }) {
    return buildAnimation<Offset>(
      start: start,
      end: end,
      animationController: animationController,
      tween: slideTweenByContext(context, distance: distance),
      curve: curve,
    );
  }
}