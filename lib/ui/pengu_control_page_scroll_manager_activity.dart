import 'package:flutter/material.dart';
import 'package:peng_u/ui/pengu_control_page_intro_animation.dart';

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
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              itemCount: widget.debugListActivity.length,
              itemBuilder: (_, int index) {
                var course = widget.debugListActivity[index];
                return Dismissible(
                    onDismissed: (direction) {
                      // Remove the item from our data source.
                      setState(() {
                        // Show a snackbar! This snackbar could also contain "Undo" actions.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(" dismissed")));
                      });


                    },
                    //dismissThresholds: {DismissDirection.horizontal: 1.0  },
                    background: Icon(Icons.ac_unit),
                    movementDuration: Duration(seconds: 2),
                    crossAxisEndOffset: 0,
                    resizeDuration: Duration(seconds: 1),
                    direction: DismissDirection.up,
                    key: Key(widget.debugListActivity[index]),
                    child: Text(widget.debugListActivity[index],style: TextStyle(fontSize: 50.0),));
              }),
        ),
      ),
    );;
  }
}
