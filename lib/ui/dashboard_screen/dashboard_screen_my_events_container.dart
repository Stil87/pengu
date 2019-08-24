import 'package:flutter/material.dart';
import 'package:peng_u/blocs/dashboard_bloc.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/ui/dashboard_screen/dashboard_screen_event_card.dart';
import 'package:provider/provider.dart';

import '../event_existing_screen.dart';

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
    var events = Provider.of<List<Event>>(context);
    if (events == null || events.isEmpty) {
      CircularProgressIndicator();
    }
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: getData(events),
    );
  }

  Widget getData(List<Event> events) {
    var _friendsList = Provider.of<List<User>>(context);
    List<User> _justRealFriendsList = [];
    if (_friendsList == null) {
      return CircularProgressIndicator();
    }
    if (_friendsList != null || _friendsList.length > 0) {
      _friendsList.forEach((user) {
        if (user.requestStatus == 'friend') {
          _justRealFriendsList.add(user);
        }
      });
    }
    if (_currentUserId == null) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    } else if (events == null || events.length == 0) {
      return Text('No events yet');
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => EventExistingScreen(
                          _justRealFriendsList, events[index], _currentUserId));
                  Navigator.push(context, route);
                },
                child: Container(
                    color: Colors.blueAccent,
                    child: EventCard(events[index], _currentUserId)));
          });
    }
  }
}
