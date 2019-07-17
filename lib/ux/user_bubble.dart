import 'package:flutter/material.dart';
import 'package:peng_u/model/user.dart';

class UserBubble extends StatefulWidget {
  final User user;

  UserBubble( {this.user});

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
    return Column(
      children: <Widget>[
       // Text(widget.user.firstName),
        Center(
            child: CircleAvatar(
                foregroundColor: Colors.blue,
                minRadius: 30.0,
                child: CircleAvatar(
                    backgroundImage: getProfileImage(widget.user)))),
      ],
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
}
