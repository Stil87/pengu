import 'package:flutter/material.dart';
import 'package:peng_u/old/ui/button_app_bar/fancy_tab_bar.dart';
import 'package:peng_u/ux/event.dart';

class StandardScreen extends StatefulWidget {
  @override
  _StandardScreenState createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FancyTabBar(),
      body: EventCard(),
    );
  }
}
