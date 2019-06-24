import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/old/ui/pengu_control_page_animator.dart';
import 'package:peng_u/old/ui/walkthrough/sign_in_screen.dart';
import 'package:peng_u/old/ui/walkthrough/sign_up_screen.dart';
import 'package:peng_u/old/ui/walkthrough/walk_screen.dart';
import 'package:peng_u/ui/dashboard_screen/dashboard_screen.dart';

import 'package:peng_u/ux/login_screen/root_screen.dart';
import 'package:peng_u/ux/teambuilder_grouping.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            stream: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        title: 'Better place',
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
        routes: <String, WidgetBuilder>{
          '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
          '/root': (BuildContext context) => new RootScreen(),
          '/signin': (BuildContext context) => new SignInScreen(),
          '/signup': (BuildContext context) => new SignUpScreen(),
          //'/main': (BuildContext context) => new MainScreen(),
          '/main': (BuildContext context) => new PengUControlPageAnimator(),

          '/dashboard' : (BuildContext context) => DashboardScreen(),
          '/group' : (BuildContext context) => TeambuilderstflGroup(),
        },
        home: _handleCurrentScreen(),
      ),
    );
  }

  Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      return RootScreen();
    } else {
      return WalkthroughScreen(prefs: prefs);
    }
  }
}
