import 'package:flutter/material.dart';
import 'package:peng_u/model/user.dart';

import 'package:peng_u/ui/new_event_screen/new_event_screen.dart';

import 'package:provider/provider.dart';

class NewEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _friendsList = Provider.of<List<User>>(context);
    return Container(
      child: FloatingActionButton(
        heroTag: 'newEvent',
        onPressed: () {
          Route route = MaterialPageRoute(
              builder: (context) => NewEventScreenPlay(_friendsList));
          Navigator.push(context, route);
        },
        highlightElevation: 50.0,
        child: Icon(Icons.local_activity),
      ),
    );
  }
}
