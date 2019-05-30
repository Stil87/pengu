import 'package:flutter/material.dart';

class UserProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: (){},
      highlightElevation: 50.0,
    child: Icon(Icons.account_circle),);
  }
}
