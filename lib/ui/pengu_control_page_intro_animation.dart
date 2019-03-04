import 'package:flutter/material.dart';

class PengUControlPageIntroAnimation {
  final AnimationController introController;
  final Animation<double> scrollerXTranslation;

  PengUControlPageIntroAnimation(this.introController)
      : scrollerXTranslation = Tween(begin: 60.0, end: 0.0)
            .animate(CurvedAnimation(parent: introController, curve: Interval(0.0, 1.0,curve: Curves.decelerate)));
}
