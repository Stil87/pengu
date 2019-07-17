import 'package:flutter/material.dart';
import 'package:peng_u/blocs/add_friends_bloc.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  AddFriendsBloc _bloc = AddFriendsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List>(
          stream: _bloc.tempSearchStoreStream,
          builder: (_, snap) {
            return Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'look for a friend'),
                  onChanged: (value) => _bloc.initiateSearch(value),
                ),
                if (snap.hasData) ...[
                  ListView.builder(
                    shrinkWrap: true,
                      itemCount: snap.data.length,
                      itemBuilder: (_, index) {
                        return Text(snap.data[index]['firstName']);
                      })
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
