import 'package:flutter/material.dart';

class PengUControlPageIntroAnimation {
  final AnimationController _controller;
  final Animation<double> scrollerXTranslation;

  PengUControlPageIntroAnimation(this._controller)
      : scrollerXTranslation = Tween(begin: 60.0, end: 0.0)
            .animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 1.0,curve: Curves.decelerate)));
}
