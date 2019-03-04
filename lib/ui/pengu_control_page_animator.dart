import 'package:flutter/material.dart';

class PengUControlPageAnimator extends StatefulWidget {
  @override
  _PengUControlPageAnimatorState createState() =>
      _PengUControlPageAnimatorState();
}

class _PengUControlPageAnimatorState extends State<PengUControlPageAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PengUControlPage();
  }
}
