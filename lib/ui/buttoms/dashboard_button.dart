import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'newEvent',
      onPressed: () {Navigator.pop(context);},
      highlightElevation: 50.0,
      child: Icon(Icons.dashboard),
    );
  }
}
