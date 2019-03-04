import 'package:flutter/material.dart';
import 'package:peng_u/ui/pengu_control_page_animated_menu.dart';
import 'package:peng_u/ui/pengu_control_page_intro_animation.dart';
import 'dart:ui' as ui;

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
            animation: widget.introAnimation.introController,
            builder: _animatePengUControlPage));
  }

//method
  Widget _animatePengUControlPage(BuildContext context, Widget child) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Align(
          alignment: Alignment.bottomCenter,
          child: _createPengUControlPageContent())
    ]);
  }

  Widget _createPengUControlPageContent() {
    return SingleChildScrollView(
      //idee
      child: Stack(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //_createPengUCollecter(),

          //_createPengUScrollManager(),
          _createAnimatedMenu()
        ],
      ),
    );
  }

//method that creates the menu
  Widget _createAnimatedMenu() {
    return  FoldableOptions();

  }
}
