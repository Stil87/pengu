import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/blocs/event_existing_bloc.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/ux/user_bubble.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dashboard_screen/dashboard_screen.dart';

class EventExistingScreen extends StatefulWidget {
  List<User> _friendList;
  String currentUserID;
  Event event;

  EventExistingScreen(this._friendList, this.event, this.currentUserID);

  @override
  _EventExistingScreenState createState() => _EventExistingScreenState();
}

class _EventExistingScreenState extends State<EventExistingScreen> {
  EventExistingBloc _bloc = EventExistingBloc();
  Color _backgroundColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    List<User> _toRemove = [];
    if (widget._friendList.isNotEmpty) {
      widget.event.invitedUserObjectList.forEach((invitedUser) {
        widget._friendList.forEach((userFriends) {
          if (invitedUser.userID == userFriends.userID) {
            _toRemove.add(userFriends);
          }
        });
      });
      widget._friendList.removeWhere((user) => _toRemove.contains(user));
    }

    // TODO: implement build
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(),
      body: StreamBuilder<Event>(
          stream:
              _bloc.getRoomStream(widget.event.roomId, widget.currentUserID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Text('Deleted or no Data!?'),
                  CircularProgressIndicator(),
                ],
              );
            }
            User inviter = snapshot.data.invitedUserObjectList.firstWhere(
                (user) =>
                    user.eventRequestStatus == 'inviter' ||
                    user.eventRequestStatus == 'inviterThere');
            User currentUser = snapshot.data.invitedUserObjectList
                .firstWhere((user) => user.userID == widget.currentUserID);
            List<User> _userInList = snapshot.data.invitedUserObjectList
                .where((user) => user.eventRequestStatus == 'in')
                .toList();
            List<User> _userOutList = snapshot.data.invitedUserObjectList
                .where((user) => user.eventRequestStatus == 'out')
                .toList();
            List<User> _userThereList = snapshot.data.invitedUserObjectList
                .where((user) => user.eventRequestStatus == 'there')
                .toList();
            List<User> _userInvitedList = snapshot.data.invitedUserObjectList
                .where((user) => user.eventRequestStatus == '')
                .toList();

            return SidekickTeamBuilder(
                initialTargetList: _userInvitedList,
                initialSourceList: widget._friendList,
                builder:
                    (context, sourceBuilderDelegates, targetBuilderDelegates) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 100.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  _getInviterBubble(inviter),
                                  Text(snapshot.data.eventName),
                                ],
                              ),
                            )),
                        GestureDetector(
                          onTap: () => _bloc.launchMapsUrl(
                              snapshot.data.eventPlace.placeId,
                              snapshot.data.eventPlace.placeName),
                          child: SizedBox(
                            height: 50.0,
                            child: Text(snapshot.data.eventPlace.placeName),
                          ),
                        ),
                        Container(
                          height: 1.0,
                          color: Colors.black,
                        ),
                        SizedBox(
                            height: 50.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data.dateTime.toString()),
                            )),
                        if (_userThereList.length > 0) ...[
                          SizedBox(
                            height: 105.0,
                            child: Container(
                              color: Colors.red,
                              child: Column(
                                children: <Widget>[
                                  Text('people already there'),
                                  SizedBox(
                                    height: 85.0,
                                    child: Container(
                                      color: Colors.blue,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _userThereList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) => UserBubble(
                                              user: _userThereList[index])),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (_userInList.length > 0) ...[
                          SizedBox(
                            height: 105.0,
                            child: Column(
                              children: <Widget>[
                                Text('people in'),
                                SizedBox(
                                  height: 85.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _userInList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (_, index) =>
                                          UserBubble(user: _userInList[index])),
                                )
                              ],
                            ),
                          ),
                        ],
                        if (_userOutList.length > 0) ...[
                          SizedBox(
                            height: 105.0,
                            child: Column(
                              children: <Widget>[
                                Text('Boring people'),
                                SizedBox(
                                  height: 85.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _userOutList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (_, index) => UserBubble(
                                          user: _userOutList[index])),
                                )
                              ],
                            ),
                          ),
                        ],
                        if (_userInvitedList.length > 0) ...[
                          Text('invited people')
                        ],
                        SizedBox(
                          height: 105.0,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: targetBuilderDelegates
                                .map((builderDelegate) => builderDelegate.build(
                                      context,
                                      WrapItem(
                                        widget._friendList,
                                        builderDelegate.message,
                                        false,
                                      ),
                                      animationBuilder: (animation) =>
                                          CurvedAnimation(
                                        parent: animation,
                                        curve: FlippedCurve(Curves.ease),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        if (sourceBuilderDelegates.length > 0) ...[
                          SizedBox(
                            height: 105.0,
                            //height: 50.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: sourceBuilderDelegates
                                  .map((builderDelegate) =>
                                      builderDelegate.build(
                                        context,
                                        WrapItem(widget._friendList,
                                            builderDelegate.message, true),
                                        animationBuilder: (animation) =>
                                            CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.ease,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                        if (_userInvitedList.length <
                            SidekickTeamBuilder.of<User>(context)
                                .targetList
                                .length) ...[
                          SizedBox(
                            height: 85.0,
                            child: FloatingActionButton(
                                onPressed: () => _bloc
                                        .forwardEventToAddedFriend(
                                            snapshot.data,
                                            SidekickTeamBuilder.of<User>(
                                                    context)
                                                .targetList)
                                        .whenComplete(() {
                                      List<User> _toRemove = [];
                                      if (widget._friendList.isNotEmpty) {
                                        SidekickTeamBuilder.of<User>(context)
                                            .targetList
                                            .forEach((invitedUser) {
                                          widget._friendList
                                              .forEach((userFriends) {
                                            if (invitedUser.userID ==
                                                userFriends.userID) {
                                              _toRemove.add(userFriends);
                                            }
                                          });
                                        });

                                        setState(() {
                                          widget._friendList.removeWhere(
                                              (user) =>
                                                  _toRemove.contains(user));
                                        });
                                      }
                                    })),
                          )
                        ] else ...[
                          SizedBox(
                              height: 85.0,
                              child: GestureDetector(
                                  onTap: () => _bloc.changeEventRequestStatus(
                                      snapshot.data,
                                      widget.currentUserID,
                                      inviter.userID),
                                  child: UserBubble(user: currentUser)))
                        ],
                        if (inviter.userID == currentUser.userID) ...[
                          _deleteIconButton(context, widget.event)
                        ]
                      ],
                    ),
                  );
                });
          }),
    );
  }

  _getInviterBubble(User inviter) {
    return UserBubble(user: inviter);
  }

  _deleteIconButton(_, Event event) {
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => launchDeleteAlert(context, event));
  }

  launchDeleteAlert(BuildContext context, Event event) {
    //set up the alerts buttons
    Widget cancelButton = FlatButton(
        onPressed: () {
          return Navigator.pop(context);
        },
        child: Text('Nay!'));
    //New FirebaseAuth user
    Widget deleteButton = FlatButton(
        child: Text('Delete it'),
        onPressed: () {
          _bloc.deleteEvent(event);
          // Route route =
          // MaterialPageRoute(builder: (context) => DashboardScreen());
          Navigator.pop(context);
          return Navigator.pop(context);
        });

    //set up the alertDialog
    AlertDialog alertDialog = AlertDialog(
      title: Text('We love events!'),
      content: Text('Do u want to delete this event? People love events!'),
      actions: <Widget>[deleteButton, cancelButton],
    );

    //show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

class WrapItem extends StatelessWidget {
  const WrapItem(
    this.userList,
    this.user,
    this.isSource,
  ) : size = isSource ? 40.0 : 70.0;

  final bool isSource;
  final double size;
  final List userList;

  //final Item item;
  final User user;

  @override
  Widget build(BuildContext context) {
    //Todo: Add circular progress bar
    return GestureDetector(
      onTap: () {
        if (userList.contains(user)) {
          SidekickTeamBuilder.of<User>(context).move(user);
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Material(
              color: Colors.blueAccent, child: UserBubble(user: user))),
    );
  }

  Future<SidekickTeamBuilder> handleUserGrouping(BuildContext context) {
    return SidekickTeamBuilder.of<User>(context).move(user);
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
