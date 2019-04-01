import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/model/pengU_user.dart';
import 'package:peng_u/ux/user_bubble.dart';

class Teambuilderstfl extends StatefulWidget {
  @override
  _TeambuilderstflState createState() => _TeambuilderstflState();
}

class _TeambuilderstflState extends State<Teambuilderstfl> {
  //StreamController<User> streamController;
  List<User> userList = List();

  @override
  void initState() {
    //StreamController sc = StreamController.broadcast();
    startfunction();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //streamController.close();

  }

  startfunction() {
    List<User> list = [];

    Firestore.instance.collection('users').snapshots().listen((snapshot) {
      snapshot.documents.forEach((doc) => list.add(User.fromDocument(doc)));

      setState(() {
        userList = [];
        userList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SidekickTeamBuilder<User>(
      //Todo add Streambuilder and Stream function to auth like mainscreen
      // body: StreamBuilder(
      //        stream: Auth.getUser(widget.firebaseUser.uid),
      //        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
      initialSourceList: userList,
      //List.generate(20, (i) => Item(id: i)),
      //initialTargetList: userList,
      builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () => SidekickTeamBuilder.of<User>(context)
                          .moveAll(SidekickFlightDirection.toTarget),
                    ),
                    SizedBox(width: 60.0, height: 60.0),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () => SidekickTeamBuilder.of<User>(context)
                          .moveAll(SidekickFlightDirection.toSource),
                    ),
                  ],
                ),
              ),
              Expanded(
                //height: 250.0,
                child: Wrap(
                  direction: Axis.vertical,
                  children: targetBuilderDelegates
                      .map((builderDelegate) => builderDelegate.build(
                            context,
                            WrapItem(builderDelegate.message, false),
                            animationBuilder: (animation) => CurvedAnimation(
                                  parent: animation,
                                  curve: FlippedCurve(Curves.ease),
                                ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                //height: 50.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: sourceBuilderDelegates
                      .map((builderDelegate) => builderDelegate.build(
                            context,
                            WrapItem(builderDelegate.message, true),
                            animationBuilder: (animation) => CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.ease,
                                ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WrapItem extends StatelessWidget {
  const WrapItem(
    this.user,
    this.isSource,
  ) : size = isSource ? 40.0 : 70.0;
  final bool isSource;
  final double size;

  //final Item item;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SidekickTeamBuilder.of<User>(context).move(user),
      child: Padding(
          padding: const EdgeInsets.all(2.0), child: UserBubble(user: user)),
    );
  }

  Color _getColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.red;
    }
    return Colors.indigo;
  }
}

class Item {
  Item({
    this.id,
  });

  final int id;
}
