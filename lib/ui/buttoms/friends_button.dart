import 'package:flutter/material.dart';

class FriendsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(heroTag: null,onPressed: (){},
      highlightElevation: 50.0,
    child: Icon(Icons.people),);
  }
}
