import 'package:flutter/widgets.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';

import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {

  final Widget page;

  CustomPageRoute({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {

      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position:
              AnimationHelper.slideTweenByContext(context).
              animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}