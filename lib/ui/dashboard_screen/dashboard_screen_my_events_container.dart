import 'package:flutter/material.dart';
import 'package:peng_u/blocs/dashboard_bloc.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/ui/dashboard_screen/dashboard_screen_event_card.dart';

class DashboardScreenMyEventsContainer extends StatefulWidget {
  @override
  _DashboardScreenMyEventsContainerState createState() =>
      _DashboardScreenMyEventsContainerState();
}

class _DashboardScreenMyEventsContainerState
    extends State<DashboardScreenMyEventsContainer> {
  final _bloc = DashboardBloc();
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentFirebaseUserID();
  }

  _getCurrentFirebaseUserID() {
    _bloc.getCurrentUserId().then((val) => setState(() {
          _currentUserId = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: getData(),
    );
  }

  Widget getData() {
    if (_currentUserId == null) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    } else {
      return StreamBuilder(
          stream: _bloc.streamUserPersonalEventsObjectList(
              currentUserID: _currentUserId),
          builder: (BuildContext context, AsyncSnapshot<List<Event>> list) {
            if (list.hasData) {
              var events = list.requireData;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EventCard(events[index]);
                  });
            }
            return Container(
              alignment: Alignment.center,
              child: Text('No Events'),
            );
          });
    }
  }
}
