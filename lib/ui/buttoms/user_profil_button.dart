import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/model/user.dart';
import 'package:provider/provider.dart';

import '../profile_and_add_friends_screen.dart';

class UserProfileButton extends StatelessWidget {
  String userId;

  UserProfileButton(this.userId);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => UserProfileScreen(userId));
        Navigator.push(context, route);
      },
      highlightElevation: 50.0,
      child: Icon(Icons.account_circle),
    );
  }


    
    
  
}
