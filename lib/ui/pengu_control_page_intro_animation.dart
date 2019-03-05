import 'package:flutter/material.dart';

class PengUControlPageIntroAnimation {
  final AnimationController introAnimationController;
  final Animation<double> scrollerXTranslation;

  PengUControlPageIntroAnimation(this.introAnimationController)
      : scrollerXTranslation = Tween(begin: 60.0, end: 0.0)
            .animate(CurvedAnimation(parent: introAnimationController, curve: Interval(0.0, 1.0,curve: Curves.decelerate)));
}
