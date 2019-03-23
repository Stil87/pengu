
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/model/pengU_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Item {
  Item({
    this.id,
  });
  final int id;
}

List<User> userList = List();




//Stream snapshot = Firestore.instance.collection('User').snapshots().




class WrapExample extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return SidekickTeamBuilder<Item>(
      initialSourceList: List.generate(20, (i) => Item(id: i)),
      builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(color: Colors.white,

                      onPressed: () => SidekickTeamBuilder.of<Item>(context)
                          .moveAll(SidekickFlightDirection.toTarget),
                    ),
                    SizedBox(width: 60.0, height: 60.0),
                    FlatButton(color: Colors.white,

                      onPressed: () => SidekickTeamBuilder.of<Item>(context)
                          .moveAll(SidekickFlightDirection.toSource),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250.0,
                child: Wrap(
                  children: targetBuilderDelegates
                      .map((builderDelegate) => builderDelegate.build(
                    context,
                    WrapItem(builderDelegate.message, false),
                    animationBuilder: (animation) => CurvedAnimation(
                      parent: animation,
                      curve: FlippedCurve(Curves.ease),
                    ),
                  ))
                      .toList(),
                ),
              ),
              SizedBox(
                height: 50.0,
                child: ListView(scrollDirection: Axis.horizontal,
                  children: sourceBuilderDelegates
                      .map((builderDelegate) => builderDelegate.build(
                    context,
                    WrapItem(builderDelegate.message, true),
                    animationBuilder: (animation) => CurvedAnimation(
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
  }
}

class WrapItem extends StatelessWidget {
  const WrapItem(
      this.item,
      this.isSource,
      ) : size = isSource ? 40.0 : 70.0;
  final bool isSource;
  final double size;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SidekickTeamBuilder.of<Item>(context).move(item),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: size - 4,
          width: size - 4,
          color: _getColor(item.id),
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


