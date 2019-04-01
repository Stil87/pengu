import 'package:flutter/material.dart';
import 'package:peng_u/ux/login_screen/teambuilder_stfl.dart';
import 'package:peng_u/old/ui/button_app_bar/fancy_tab_bar.dart';
import 'package:peng_u/old/ui/animated_menu/pengu_control_page_animated_menu.dart';
import 'package:peng_u/old/ui/pengu_control_page_intro_animation.dart';
import 'dart:ui' as ui;
import 'package:flutter_sidekick/flutter_sidekick.dart';

import 'package:peng_u/old/ui/pengu_control_page_scroll_manager_activity.dart';

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
        //appBar: AppBar(title: Text('PengYou')),
        bottomNavigationBar: FancyTabBar(),
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
          Expanded(flex: 3, child: Teambuilderstfl()),
          Align(alignment: Alignment.bottomCenter, child: FoldableOptions()),
        ]);
  }
}
