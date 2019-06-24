import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(heroTag: null,
      onPressed: () {Navigator.pushNamed(context, '/group');},
      highlightElevation: 50.0,
      child: Icon(Icons.account_circle),
    );
  }
}
