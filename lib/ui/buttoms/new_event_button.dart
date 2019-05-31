import 'package:flutter/material.dart';
import 'package:peng_u/ui/event_new_screen.dart';

class NewEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(heroTag: 'newEvent',onPressed: (){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NewEventScreen()),
      );

    },
      highlightElevation: 50.0,
    child: Icon(Icons.local_activity),);
  }
}
