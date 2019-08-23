import 'package:flutter/material.dart';
import 'package:peng_u/blocs/add_friends_bloc.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/ux/user_bubble.dart';

class UserProfileScreen extends StatefulWidget {
  String userId;

  UserProfileScreen(this.userId);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState(userId);
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  AddFriendsBloc _bloc = AddFriendsBloc();
  String userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _UserProfileScreenState(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: StreamBuilder<List<User>>(
          stream: _bloc.tempSearchStoreStream,
          builder: (_, snap) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<User>(
                      stream: _bloc.getUserObject(userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: UserBubble(user: snapshot.data),
                          );
                        }
                        return CircularProgressIndicator();
                      }),
                  SizedBox(
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            color: Colors.blue, child: Text('Your Friends')),
                      )),
                  StreamBuilder<List<User>>(
                      stream: _bloc.getUserFriendsList(userId),
                      builder: (_, snap2) {

                        if (snap2.hasData && snap2.data.length > 0) {
                          _bloc.setfriendsList = snap2.data;
                          List<User> friendsList = [];
                          //requested by the current user
                          List<User> requestedFriendList = [];
                          //requested from other user to current user
                          List<User> friendRequested = [];
                          snap2.data.forEach((user) {
                            if (user.requestStatus == 'requested') {
                              requestedFriendList.add(user);
                            } else if (user.requestStatus ==
                                'friendRequested') {
                              print(user.requestStatus);
                              print(friendRequested.length);
                              friendRequested.add(user);
                              print(friendRequested.length);
                            } else if (user.requestStatus == 'friend') {
                              friendsList.add(user);
                            }
                          });
                          return Column(
                            children: <Widget>[
                              //Freunde
                              if (friendsList.length > 0) ...[
                                SizedBox(
                                  height: 110.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: friendsList.length,
                                        itemBuilder: (_, index) {
                                          return GestureDetector(
                                            onLongPress: () {
                                              return showAlertDialog(
                                                  _, friendsList[index].userID);
                                            },
                                            child: UserBubble(
                                                user: friendsList[index]),
                                          );
                                        }),
                                  ),
                                )
                              ],
                              //from user requested freindship
                              if (requestedFriendList.length > 0) ...[
                                SizedBox(
                                  height: 105.0,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          'You asked someone to be your friend'),
                                      SizedBox(
                                        height: 85.0,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                requestedFriendList.length,
                                            itemBuilder: (_, index) {
                                              return GestureDetector(
                                                onLongPress: () {
                                                  return showAlertDialog(
                                                      _,
                                                      requestedFriendList[index]
                                                          .userID);
                                                },
                                                child: UserBubble(
                                                    user: requestedFriendList[
                                                        index]),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              // from other user requested
                              if (friendRequested.length > 0) ...[
                                Column(
                                  children: <Widget>[
                                    Text('Someone wants you as a friend'),
                                    SizedBox(
                                      height: 105.0,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: friendRequested.length,
                                          itemBuilder: (_, index) {
                                            return GestureDetector(
                                              onLongPress: () {
                                                return showAlertDialog(
                                                    _,
                                                    friendRequested[index]
                                                        .userID);
                                              },
                                              onTap: () =>
                                                  _bloc.acceptFriendshipRequest(
                                                      userId,
                                                      friendRequested[index]
                                                          .userID),
                                              child: UserBubble(
                                                  user: friendRequested[index]),
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            ],
                          );
                        } else {
                          return Text('You dont have friends');
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      decoration:
                          InputDecoration(hintText: 'look for a friend'),
                      onChanged: (value) => _bloc.initiateSearch(value),
                    ),
                  ),
                  if (snap.hasData) ...[
                    SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                          shrinkWrap: true,
                          //itemExtent: 10.0,
                          itemCount: snap.data.length,
                          itemBuilder: (_, index) {
                            return Container(
                              color: Colors.red,
                              child: ListTile(
                                  onTap: () => _sendInvitation(
                                      snap.data[index]),
                                  leading: Image(
                                      image: getImage(snap.data[index]
                                         )),
                                  title: Text(snap.data[index].firstName)),
                            );
                          }),
                    )
                  ]
                ],
              ),
            );
          }),
    );
  }

  showAlertDialog(BuildContext context, String userToDeleteId) {
    //set up the alerts buttons
    Widget cancelButton = FlatButton(
        onPressed: () {
          return Navigator.pop(context);
        },
        child: Text('Nea!'));
    //New FirebaseAuth user
    Widget signUpButton = FlatButton(
        onPressed: () {
          _bloc.deleteFriend(userId, userToDeleteId);
          //todo: route to dashboard screen
          return Navigator.pop(context);
        },
        child: Text('Yeah!'));

    //set up the alertDialog
    AlertDialog alertDialog = AlertDialog(
      title: Text('Delete Friend'),
      content: Text('Do u wanna delete?'),
      actions: <Widget>[cancelButton, signUpButton],
    );

    //show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  getImage(User user) {
    if (user.profilePictureURL != null) {
      return NetworkImage(user.profilePictureURL);
    } else
      return AssetImage("assets/images/default.png");
  }

  _sendInvitation(User toInviteUser) {
    if (userId != toInviteUser.userID) {
      _bloc.sendFriendshipRequest(userId, toInviteUser.userID);
    } else {}
    if (userId == toInviteUser.userID) {
      final snackyBar = SnackBar(content: Text('Loving yourself is key'));

      _scaffoldKey.currentState.showSnackBar(snackyBar);
    }
  }
}
