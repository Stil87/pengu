import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:peng_u/blocs/dashboard_bloc.dart';
import 'package:peng_u/blocs/dashboard_bloc_provider.dart';
import 'package:peng_u/blocs/push_notification.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/old/ui/pengu_control_page_animator.dart';
import 'package:peng_u/old/ui/walkthrough/main_screen.dart';
import 'package:peng_u/old/ui/walkthrough/welcome_screen.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:peng_u/ui/dashboard_screen/dashboard_screen.dart';
import 'package:peng_u/ui/login.dart';
import 'package:peng_u/ux/event.dart';
import 'package:peng_u/ux/login_screen/login_screen.dart';
import 'package:peng_u/ux/standard_Screen.dart';
import 'package:peng_u/blocs/login_bloc_provider.dart';
import 'package:peng_u/ux/teambuilder_grouping.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final _repository = Repository();
  final _bloc = DashboardBloc();

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

            var user = snapshot.data.uid;
            return MultiProvider(
                providers: [
                  // Make user events stream available
                  StreamProvider<List<Event>>.value(
                      stream: _bloc.streamUserPersonalEventsObjectList(
                          currentUserID: user)),
                  // Make user events stream available
                  StreamProvider<List<User>>.value(
                      stream: _bloc.streamUserPersonalFriendsObjectList(
                          currentUserID: user))
                ],
                child: Scaffold(backgroundColor: Colors.blueAccent,
                  appBar: AppBar(
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () => _repository.signOutFirebaseAuth(),
                      )
                    ],
                  ),
                  body:  DashboardBlocProvider(
                   child: DashboardScreen(),
                  ),
                )); //StandardScreen());
          } else {
            return Scaffold(
                body: LoginBlocProvider(child: LoginScreen())); //LoginPage();
          }
        }
      },
    );
  }
}
