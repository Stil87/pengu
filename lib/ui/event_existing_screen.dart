import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/blocs/event_existing_bloc.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/ux/user_bubble.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventExistingScreen extends StatefulWidget {
  List<User> _friendList;

  Event event;

  EventExistingScreen(this._friendList, this.event);

  @override
  _EventExistingScreenState createState() => _EventExistingScreenState();
}

class _EventExistingScreenState extends State<EventExistingScreen> {
  EventExistingBloc _bloc = EventExistingBloc();

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
      appBar: AppBar(),
      body: SidekickTeamBuilder(
          initialTargetList: widget.event.invitedUserObjectList,
          initialSourceList: widget._friendList,
          builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
            return Column(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.event.eventName),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.event.dateTime.toString()),
                )),
                Expanded(
                  child: Wrap(
                    direction: Axis.vertical,
                    children: targetBuilderDelegates
                        .map((builderDelegate) => builderDelegate.build(
                              context,
                              WrapItem(
                                widget._friendList,
                                builderDelegate.message,
                                false,
                              ),
                              animationBuilder: (animation) => CurvedAnimation(
                                parent: animation,
                                curve: FlippedCurve(Curves.ease),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                if (widget._friendList.length > 0) ...[
                  Expanded(
                    //height: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: sourceBuilderDelegates
                            .map((builderDelegate) => builderDelegate.build(
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
                    ),
                  )
                ],
                if (widget.event.invitedUserObjectList.length <
                    SidekickTeamBuilder.of<User>(context)
                        .targetList
                        .length) ...[
                  Expanded(
                    child: FloatingActionButton(
                        onPressed: () => _bloc.forwardEventToAddedFriend(
                            widget.event,
                            SidekickTeamBuilder.of<User>(context).targetList)),
                  )
                ]
              ],
            );
          }),
    );
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
          padding: const EdgeInsets.all(2.0), child: UserBubble(user: user)),
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
