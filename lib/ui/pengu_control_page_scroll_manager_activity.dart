import 'package:flutter/material.dart';
import 'package:peng_u/ui/list_tiles/friends.dart';
import 'package:peng_u/ui/pengu_control_page_intro_animation.dart';


//debug
import 'package:cloud_firestore/cloud_firestore.dart';



class PengUScrollManagerActivity extends StatefulWidget {
  final PengUControlPageIntroAnimation introAnimation;
  //create debug list
  List debugListActivity = ['Coffee', 'sushi',' Bier', '100Bier' , 'Griechisch'];

  PengUScrollManagerActivity(
      {@required AnimationController animationController})
      : introAnimation = PengUControlPageIntroAnimation(animationController);

  @override
  _PengUScrollManagerActivityState createState() =>
      _PengUScrollManagerActivityState();
}

class _PengUScrollManagerActivityState
    extends State<PengUScrollManagerActivity> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Transform(
        transform: Matrix4.translationValues(
            widget.introAnimation.scrollerXTranslation.value, 0.0, 0.0),
        child: SizedBox.fromSize(
          size: Size.fromHeight(250),
          child: StreamBuilder(
            stream: Firestore.instance.collection('User').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData){ return Text('no data bitch');}

              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, int index) {
                    var course = snapshot.data.documents[index];
                    debugPrint('${snapshot.data.documents[index]}');
                    return FriendsTile(course);
                  });
            }
          ),
        ),
      ),
    );;
  }
}
