import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/ui/buttoms/dashboard_button.dart';
import 'package:peng_u/ui/buttoms/friends_button.dart';
import 'package:peng_u/ui/buttoms/user_profil_button.dart';
import 'package:provider/provider.dart';

class NewEventScreen extends StatelessWidget {
  TextEditingController _eventNameTextEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            Expanded(child: _createEventNameTextField()),
            Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            //Expanded(child: DashboardScreenMyFriendsEventsContainer()),
            Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: DashboardButton()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 30.0),
                  child: Align(
                      alignment: Alignment.bottomRight, child: FriendsButton()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, left: 30.0),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: UserProfileButton()),
                ),
              ],
            )
          ],
        ));
  }

  _createEventNameTextField() {
    return Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.lightBlue,
        child: TextFormField(
          decoration: InputDecoration(hintText: 'give it a funny name'),
          controller: _eventNameTextEditingController,
        ));
  }
}
