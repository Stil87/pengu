import 'package:flutter/material.dart';
import 'package:peng_u/old/ui/animated_menu/pengu_control_page_animated_menu.dart';
import 'package:peng_u/ux/login_screen/teambuilder_stfl.dart';
import 'package:peng_u/ux/teambuilder_grouping.dart';

class EventCard extends StatefulWidget {
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard>
    with SingleTickerProviderStateMixin {
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
    return Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(flex: 3, child: TeambuilderstflGroup()),//Teambuilderstfl()),
          Align(alignment: Alignment.bottomCenter, child: FoldableOptions()),
        ]);
  }
}
