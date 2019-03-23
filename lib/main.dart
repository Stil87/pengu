import 'package:flutter/material.dart';
import 'package:peng_u/ideas/peng_u_teambuilder.dart';
import 'package:peng_u/ideas/teambuilder_stfl.dart';
import 'package:peng_u/ui/pengu_control_page_animator.dart';
import 'package:peng_u/ui/walkthrough/root_screen.dart';
import 'package:peng_u/ui/walkthrough/sign_in_screen.dart';
import 'package:peng_u/ui/walkthrough/sign_up_screen.dart';
import 'package:peng_u/ui/walkthrough/walk_screen.dart';
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
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),
        //'/main': (BuildContext context) => new MainScreen(),
        '/main': (BuildContext context) => new PengUControlPageAnimator(),},
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

