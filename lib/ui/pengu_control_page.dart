import 'package:flutter/material.dart';
import 'package:peng_u/ui/pengu_control_page_intro_animation.dart';
import 'dart:ui' as ui;


class PengUControlPage extends StatefulWidget {
  final PengUControlPageIntroAnimation introAnimation;
  PengUControlPage({@required AnimationController animationController})

  //2do intro animation instantiation
  :introAnimation = PengUControlPageIntroAnimation(animationController);

  @override
  _PengUControlPageState createState() => _PengUControlPageState();
}

class _PengUControlPageState extends State<PengUControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PengYou')),
      body: AnimatedBuilder(animation: null, builder: null) 
    );
  }
}

//
