import 'package:flutter/material.dart';
import 'package:peng_u/ui/pengu_control_page_animated_menu.dart';
import 'package:peng_u/ui/pengu_control_page_intro_animation.dart';
import 'dart:ui' as ui;

import 'package:peng_u/ui/pengu_control_page_scroll_manager_activity.dart';

class PengUControlPage extends StatefulWidget {
  final PengUControlPageIntroAnimation introAnimation;

  PengUControlPage({@required AnimationController animationController})
      : introAnimation = PengUControlPageIntroAnimation(animationController);

  @override
  _PengUControlPageState createState() => _PengUControlPageState();
}

class _PengUControlPageState extends State<PengUControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('PengYou')),
        body: AnimatedBuilder(
            animation: widget.introAnimation.introAnimationController,
            builder: _animatePengUControlPage));
  }

//method
  Widget _animatePengUControlPage(BuildContext context, Widget child) {
    return Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(flex: 3,

            child: Container(
              color: Colors.lightBlueAccent,
            ),
          ),
          Expanded(
            child: PengUScrollManagerActivity(
              animationController: widget.introAnimation.introAnimationController,
            ),
          ),
          Align(alignment:Alignment.bottomCenter,child: FoldableOptions()),
        ]);
  }
}
