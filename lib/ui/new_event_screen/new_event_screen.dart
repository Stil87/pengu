import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/blocs/event_new_bloc.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/utils/name_list.dart';
import 'package:peng_u/ux/user_bubble.dart';
import 'package:rxdart/rxdart.dart';

class NewEventScreenPlay extends StatefulWidget {
  List _friendsList;

  NewEventScreenPlay(this._friendsList);

  @override
  _NewEventScreenPlayState createState() =>
      _NewEventScreenPlayState(_friendsList);
}

class _NewEventScreenPlayState extends State<NewEventScreenPlay> {
  _NewEventScreenPlayState(this._friendlist);

  List _friendlist;
  NewEventBloc _bloc = NewEventBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<Object>(
            stream: _bloc.stream$,
            builder: (context, snapshot) {
              return SidekickTeamBuilder(
                  initialSourceList: _friendlist,
                  builder: (context, sourceBuilderDelegates,
                      targetBuilderDelegates) {
                    return Column(children: <Widget>[
                      Expanded(child: Text('here könnte ihre Werbung stehen')),
                      Expanded(
                        child: Wrap(
                          direction: Axis.vertical,
                          //todo: List statefull widget mit targetdelegate as child
                          children: targetBuilderDelegates
                              .map((builderDelegate) => builderDelegate.build(
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
                      if (snapshot.data == 0) ...[
                        Expanded(child: _createNameFinderRow())
                      ],
                      if (snapshot.data == 1) ...[
                        Expanded(
                          //height: 50.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: sourceBuilderDelegates
                                .map((builderDelegate) => builderDelegate.build(
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
                    ]);
                  });
            }));
  }

  _createNameFinderRow() {
    return Container(
      child: Row(
        children: <Widget>[
          _createNameFinder(),
          _createNameFinder(),
          _createNameFinder()
        ],
      ),
    );
  }

  _createNameFinder() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: NameList().nameList.length,
              itemBuilder: (_, index) => ListTile(onTap: _bloc.increment(),
                    title: Text(NameList().nameList[index]),
                  )),
        ),
      ),
    );
  }
}

class WrapItem extends StatelessWidget {
  const WrapItem(
    this.user,
    this.isSource,
  ) : size = isSource ? 40.0 : 70.0;
  final bool isSource;
  final double size;

  //final Item item;
  final User user;

  @override
  Widget build(BuildContext context) {
    //Todo: Add circular progress bar
    return GestureDetector(
      onTap: () => SidekickTeamBuilder.of<User>(context).move(user),
      child: Padding(
          padding: const EdgeInsets.all(2.0), child: UserBubble(user: user)),
    );
  }

  Future<SidekickTeamBuilder> handleUserGrouping(BuildContext context) {
    return SidekickTeamBuilder.of<User>(context).move(user);
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
