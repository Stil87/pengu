import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/model/pengU_user.dart';

class Teambuilderstfl extends StatefulWidget {
  @override
  _TeambuilderstflState createState() => _TeambuilderstflState();
}


class _TeambuilderstflState extends State<Teambuilderstfl> {
  List<User> userList = List();

  @override
  void initState() {
    super.initState();
    startfunction();
  }



  Future startfunction() async {
    QuerySnapshot snapshot =
    await Firestore.instance.collection('users').getDocuments();

    Map snapshotMap = snapshot.documents.asMap();
    debugPrint('${snapshotMap[0]['email']}');

    try {
      for (int i = 0; i <= snapshotMap.length; i++) {
        userList.add(User.fromDocument(snapshotMap[i]));
        debugPrint('${userList[i].firstName}');
      }
    } catch (e) {
      debugPrint('penis');
    }
  }


@override
Widget build(BuildContext context) {
  return SidekickTeamBuilder<User>(
    initialSourceList: userList,//List.generate(20, (i) => Item(id: i)),
    builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () =>
                        SidekickTeamBuilder.of<User>(context)
                            .moveAll(SidekickFlightDirection.toTarget),
                  ),
                  SizedBox(width: 60.0, height: 60.0),
                  FlatButton(
                    color: Colors.blue
                    ,
                    onPressed: () =>
                        SidekickTeamBuilder.of<User>(context)
                            .moveAll(SidekickFlightDirection.toSource),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250.0,
              child: Wrap(
                children: targetBuilderDelegates
                    .map((builderDelegate) =>
                    builderDelegate.build(
                      context,
                      WrapItem(builderDelegate.message, false),
                      animationBuilder: (animation) =>
                          CurvedAnimation(
                            parent: animation,
                            curve: FlippedCurve(Curves.ease),
                          ),
                    ))
                    .toList(),
              ),
            ),
            SizedBox(
              height: 50.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: sourceBuilderDelegates
                    .map((builderDelegate) =>
                    builderDelegate.build(
                      context,
                      WrapItem(builderDelegate.message, true),
                      animationBuilder: (animation) =>
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.ease,
                          ),
                    ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}}

class WrapItem extends StatelessWidget {
  const WrapItem(this.user,
      this.isSource,) : size = isSource ? 40.0 : 70.0;
  final bool isSource;
  final double size;
  //final Item item;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => SidekickTeamBuilder.of<User>(context).move(user),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          radius: 30.0,
          child: Text(user.firstName[0]),

          //color: //_getColor(item.id),
        ),
      ),
    );
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
