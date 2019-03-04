import 'package:flutter/material.dart';

class FoldableOptions extends StatefulWidget {
  @override
  _FoldableOptionsState createState() => _FoldableOptionsState();
}

class _FoldableOptionsState extends State<FoldableOptions>
    with SingleTickerProviderStateMixin {
  final List<IconData> options = [
    Icons.folder,
    Icons.share,
    Icons.visibility_off,
    Icons.star_border,
    Icons.notifications_none
  ];
double boxheight = 10;
  Animation<Alignment> firstAnim;
  Animation<Alignment> secondAnim;
  Animation<Alignment> thirdAnim;
  Animation<Alignment> fourthAnim;
  Animation<Alignment> fifthAnim;
  Animation<double> verticalPadding;
  Animation<double> boxHeight;
  AnimationController controller;
  final duration = Duration(milliseconds: 270);

  Widget getItem(IconData source) {
    final size = 40.0;
    return GestureDetector(
      onTap: () {
        controller.reverse();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: Color(0XFF212121),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Icon(
          source,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget buildPrimaryItem(IconData source) {
    final size = 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black87, blurRadius: verticalPadding.value)
          ]),
      child: Icon(
        source,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim = CurvedAnimation(parent: controller, curve: Curves.linear);
    firstAnim = Tween<Alignment>(
            begin: Alignment.bottomCenter, end: Alignment.bottomRight)
        .animate(anim);
    secondAnim =
        Tween<Alignment>(begin: Alignment.bottomCenter, end: Alignment.topRight)
            .animate(anim);
    thirdAnim = Tween<Alignment>(
            begin: Alignment.bottomCenter, end: Alignment.topCenter)
        .animate(anim);
    fourthAnim =
        Tween<Alignment>(begin: Alignment.bottomCenter, end: Alignment.topLeft)
            .animate(anim);
    fifthAnim = Tween<Alignment>(
            begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
        .animate(anim);
    verticalPadding = Tween<double>(begin: 0, end: 35).animate(anim);
    boxHeight = Tween<double>(begin: 0.5, end: 1.0).animate(anim);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.only(bottom: 15.0),
      width: 200,
      height: 150 ,
      margin: EdgeInsets.only(right: 2),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(

            children: <Widget>[
              Align(
                alignment: firstAnim.value,
                child: getItem(options.elementAt(0)),
              ),
              Align(
                  alignment: secondAnim.value,
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 0.0, top: verticalPadding.value),
                      child: getItem(options.elementAt(1)))),
              Align(
                  alignment: thirdAnim.value,
                  child: getItem(options.elementAt(2))),
              Align(
                  alignment: fourthAnim.value,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 0.0, top: verticalPadding.value),
                    child: getItem(options.elementAt(3)),
                  )),
              Align(
                  alignment: fifthAnim.value,
                  child: getItem(options.elementAt(4))),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                    onTap: () {
                      controller.isCompleted
                          ? controller.reverse()
                          : controller.forward();
                    },
                    child: buildPrimaryItem(
                        controller.isCompleted || controller.isAnimating
                            ? Icons.close
                            : Icons.add)),
              )
            ],
          );
        },
      ),
    );
  }
}
