import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile_and_add_friends_screen.dart';

class UserProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => UserProfileScreen());
        Navigator.push(context, route);
      },
      highlightElevation: 50.0,
      child: Icon(Icons.account_circle),
    );
  }
}
