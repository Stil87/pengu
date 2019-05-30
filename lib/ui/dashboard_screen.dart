import 'package:flutter/material.dart';
import 'package:peng_u/ui/dashboard_screen_my_events_card.dart';
import 'package:peng_u/ui/dashboard_screen_my_friends_event_card.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        DashboardScreenMyEventsCard(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        DashboardScreenMyFriendsEventsCard(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
      ],
    );
  }
}
