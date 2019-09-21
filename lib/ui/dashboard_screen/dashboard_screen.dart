import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/blocs/dashboard_bloc.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/ui/buttoms/friends_button.dart';
import 'package:peng_u/ui/buttoms/user_profil_button.dart';
import 'package:peng_u/ui/dashboard_screen/dashboard_screen_my_events_container.dart';

import 'package:peng_u/ui/buttoms/new_event_button.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  final _bloc = DashboardBloc();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    print('user from provider with: ${user.displayName}');
    _bloc.createNewFirestoreCollectionUser(currentUserId: user.uid);

    return Column(
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        Expanded(flex:1,child: DashboardScreenMyEventsContainer()),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        //Expanded(child: DashboardScreenMyFriendsEventsContainer(user)),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, right: 30.0),
              child: Align(
                  alignment: Alignment.bottomRight, child: NewEventButton()),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 30.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: UserProfileButton(user.uid)),
            ),
          ],
        )
      ],
    );
  }
}

/*class DashboardScreenMyFriendsEventsContainer extends StatefulWidget {
  FirebaseUser currentUser;

  DashboardScreenMyFriendsEventsContainer(this.currentUser);

  @override
  _DashboardScreenMyFriendsEventsContainerState createState() =>
      _DashboardScreenMyFriendsEventsContainerState();
}

class _DashboardScreenMyFriendsEventsContainerState
    extends State<DashboardScreenMyFriendsEventsContainer> {
  final _bloc = DashboardBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
        stream: _bloc.streamUserPersonalFriendsEventObjectList(
            currentUserID: widget.currentUser.uid),
        builder: (_, snap) {
          return ListView.builder(itemBuilder: ((_, index) {
            return Text(snap.data[index].eventName);
          }));
        });
  }
}*/
