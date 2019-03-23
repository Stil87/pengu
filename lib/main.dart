import 'package:flutter/material.dart';

import 'package:peng_u/old/ui/pengu_control_page_animator.dart';

import 'package:peng_u/old/ui/walkthrough/walk_screen.dart';
import 'package:peng_u/ux/login_screen/login_screen.dart';
import 'package:peng_u/ux/login_screen/root_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    runApp(PengU(prefs: prefs));
  });
}

class PengU extends StatelessWidget {
  final SharedPreferences prefs;

  PengU({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better place',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      routes: <String, WidgetBuilder>{
        '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
        '/root': (BuildContext context) => new RootScreen(),
        '/signin': (BuildContext context) => LoginPage(), //new SignInScreen(),
        '/signup': (BuildContext context) => LoginPage(), //new SignUpScreen(),
        //'/main': (BuildContext context) => new MainScreen(),
        '/main': (BuildContext context) => new PengUControlPageAnimator(),
      },
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      return new RootScreen();
    } else {
      return new WalkthroughScreen(prefs: prefs);
    }
  }
}

//PengUControlPageAnimator(),
