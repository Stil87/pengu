import 'package:flutter/material.dart';
import 'package:peng_u/blocs/event_card_bloc.dart';
import 'package:peng_u/model/event.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/ux/user_bubble.dart';

class EventCard extends StatefulWidget {
  Event event;

  EventCard(this.event);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  EventCardBloc _bloc = EventCardBloc();

  @override
  Widget build(BuildContext context) {
    return MyDashboardEventCard(widget.event);
  }

  Widget MyDashboardEventCard(Event event) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(height: 2.0, color: Colors.black),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(event.eventName),
              Icon(Icons.event),
              _showInviterUserBubble()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(
                  event.dateTime.difference(DateTime.now()).inHours.toString()),
              Icon(Icons.event)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<PlaceDetails>(
              future: _bloc.getGooglePlaceObject(event.googlePlaceId),
              builder: (_, snap) {
                if (!snap.hasData) {
                  return CircularProgressIndicator();
                }
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(snap.data.name),
                        Image(image: NetworkImage(snap.data.icon))
                      ],
                    ),
                  ],
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 85.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: event.invitedUserObjectList.length,
                itemBuilder: (_, index) {
                  return UserBubble(user: event.invitedUserObjectList[index]);
                }),
          ),
        )
      ],
    );
  }

  _showInviterUserBubble() {
    User inviter = widget.event.invitedUserObjectList
        .firstWhere((e) => e.eventRequestStatus == 'inviter');
    return UserBubble(user: inviter);
  }
}
