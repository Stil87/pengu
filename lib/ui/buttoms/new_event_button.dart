import 'package:flutter/material.dart';

class NewEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: (){},
      highlightElevation: 50.0,
    child: Icon(Icons.local_activity),);
  }
}
