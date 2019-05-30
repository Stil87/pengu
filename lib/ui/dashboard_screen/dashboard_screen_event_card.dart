import 'package:flutter/material.dart';
import 'package:peng_u/model/event.dart';

class EventCard extends StatefulWidget {
  Event event;

  EventCard(this.event);

  @override
  _EventCardState createState() => _EventCardState(event);
}

class _EventCardState extends State<EventCard> {
  Event event;


  _EventCardState(this.event);

  @override
  Widget build(BuildContext context) {
    return MyDashboardEventCard(event);
  }

  Widget MyDashboardEventCard(Event event) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[Text(event.eventName), Icon(Icons.event)],
        ),
      ],
    );
  }


}
