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

  _UserProfileScreenState(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List>(
          stream: _bloc.tempSearchStoreStream,
          builder: (_, snap) {
            return Column(
              children: <Widget>[
                StreamBuilder<User>(
                    stream: _bloc.getUserObject(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image(
                                    image: NetworkImage(
                                        snapshot.data.profilePictureURL)),
                              ),
                              Text(snapshot.data.firstName),
                            ],
                          ),
                        );
                      }
                    }),
                StreamBuilder<List<User>>(
                    stream: _bloc.getUserFriendsList(userId),
                    builder: (_, snap2) {
                      if (snap2.hasData) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snap2.data.length,
                                itemBuilder: (_, index) =>
                                    UserBubble(user: snap2.data[index])),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'look for a friend'),
                    onChanged: (value) => _bloc.initiateSearch(value),
                  ),
                ),
                if (snap.hasData) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                                leading: Image(
                                    image: NetworkImage(
                                        snap.data[index]['profilePictureUR'])),
                                title: Text(snap.data[index]['firstName']));
                          }),
                    ),
                  )
                ]
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
