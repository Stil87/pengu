import 'package:flutter/material.dart';
import 'package:peng_u/blocs/dashboard_bloc.dart';
import 'package:peng_u/model/event.dart';

class DashboardScreenMyEventsCard extends StatefulWidget {
  @override
  _DashboardScreenMyEventsCardState createState() =>
      _DashboardScreenMyEventsCardState();
}

class _DashboardScreenMyEventsCardState
    extends State<DashboardScreenMyEventsCard> {
  final _bloc = DashboardBloc();
  String currentUserId;

  @override
  void initState() {
    super.initState();
    _statefulWidgetDemoState();
  }

  _statefulWidgetDemoState() {
    _bloc.getCurrentUserId().then((val) => setState(() {
          currentUserId = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: columnMaker(),
    );
  }

  Widget columnMaker() {
    if (currentUserId == null) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    } else {
      return StreamBuilder(
          stream: _bloc.streamUserPersonalEventsObjectList(
              currentUserID: currentUserId),
          builder: (BuildContext context, AsyncSnapshot<List<Event>> list) {
            if (list.hasData) {
              var events = list.requireData;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MyEventCard(events[index]);
                  });
            }
            return Container(
              alignment: Alignment.center,
              child: Text('No Events'),
            );
          });
    }
  }

  Widget MyEventCard(Event event) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[Text(event.eventName), Icon(Icons.event)],
        ),
      ],
    );
  }
}
