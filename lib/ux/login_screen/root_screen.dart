import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:peng_u/old/ui/pengu_control_page_animator.dart';
import 'package:peng_u/old/ui/walkthrough/main_screen.dart';
import 'package:peng_u/old/ui/walkthrough/welcome_screen.dart';
import 'package:peng_u/ux/login_screen/login_screen.dart';

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Container(
            child: CircularProgressIndicator(),

          );
        } else {
          if (snapshot.hasData) {
            return new PengUControlPageAnimator(
              //firebaseUser: snapshot.data,
            );
          } else {
            return LoginPage();
          }
        }
      },
    );
  }
}
