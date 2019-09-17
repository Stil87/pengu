import 'package:flutter/material.dart';
import 'package:peng_u/model/user.dart';

class UserBubble extends StatefulWidget {
  final User user;

  UserBubble({this.user});

  @override
  _UserBubbleState createState() => _UserBubbleState();
}

class _UserBubbleState extends State<UserBubble>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blueAccent,
      child: Column(
        children: <Widget>[
          SizedBox(height: 16.0,child: Text(_getName())),
          // Text(widget.user.firstName),
          Container(color: Colors.blueAccent,
              child: CircleAvatar(
                  backgroundColor: _setColor(),
                  minRadius: 33.0,
                  child: CircleAvatar(
                      minRadius: 26.0,
                      maxRadius: 29.0,
                      backgroundImage: getProfileImage(widget.user)))),
        ],
      ),
    );
  }

  getProfileImage(User user) {
    if (user.profilePictureURL == null || user.profilePictureURL == '') {
      return AssetImage("assets/images/default.png");
    } else {
      try {
        return NetworkImage(widget.user.profilePictureURL);
      } catch (e) {
        debugPrint('User NewtworkImage error: $e');
        return Icon(Icons.error);
      }
    }
  }

  _setColor() {
    String status = widget.user.eventRequestStatus;
    if (status == '') {
      return Colors.black;
    } else if (status == 'in' || status == 'inviter') {
      return Colors.green;
    } else if (status == 'out') {
      return Colors.red[100];
    } else if (status == 'there' || status == 'inviterThere') {
      return Colors.tealAccent;
    } else {
      return Colors.black;
    }
  }

  String _getName() {
    int max = 7;
    String name = widget.user.firstName;
    if (name.length < max) {
      return name;
    }
    return name.substring(0, max);
  }
}
