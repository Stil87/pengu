import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:peng_u/old/ui/pengu_control_page_animator.dart';
import 'package:peng_u/old/ui/walkthrough/main_screen.dart';
import 'package:peng_u/old/ui/walkthrough/welcome_screen.dart';
import 'package:peng_u/ui/login.dart';
import 'package:peng_u/ux/event.dart';
import 'package:peng_u/ux/login_screen/login_screen.dart';
import 'package:peng_u/ux/standard_Screen.dart';
import 'package:peng_u/blocs/login_bloc_provider.dart';

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
            return StandardScreen();
          } else {
            return Scaffold(body: LoginBlocProvider(child: LoginScreen()));//LoginPage();
          }
        }
      },
    );
  }
}
