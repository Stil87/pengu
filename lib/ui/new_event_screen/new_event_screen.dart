import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:peng_u/blocs/event_new_bloc.dart';
import 'package:peng_u/model/user.dart';
import 'package:peng_u/utils/name_list.dart';
import 'package:peng_u/ux/user_bubble.dart';
import 'package:rxdart/rxdart.dart';

class NewEventScreenPlay extends StatefulWidget {
  final List _friendsList;

  NewEventScreenPlay(this._friendsList);

  @override
  _NewEventScreenPlayState createState() =>
      _NewEventScreenPlayState(_friendsList);
}

class _NewEventScreenPlayState extends State<NewEventScreenPlay> {
  _NewEventScreenPlayState(this._friendsList);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<User> _friendsList;
  List<PlacesSearchResult> _placesList = [];
  NewEventBloc _bloc = NewEventBloc();

  @override
  void initState() {
    super.initState();
    _bloc.setZero();
    _friendsList.forEach((user) => print(user.firstName));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: StreamBuilder<Object>(
            stream: _bloc.stream$,
            builder: (context, snapshot) {
              List<User> _justFriendsList = [];
              _friendsList.forEach((user){
                if (user.requestStatus == 'friend'){
                  _justFriendsList.add(user);
                }
              });
              return SidekickTeamBuilder(
                  initialSourceList: _justFriendsList,
                  builder: (context, sourceBuilderDelegates,
                      targetBuilderDelegates) {
                    return Column(children: <Widget>[
                      StreamBuilder<List>(
                          stream: _bloc.treeWordNameListStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      return Card(
                                        child: Text(snapshot.data[index]),
                                      );
                                    }),
                              );
                            }

                            return Expanded(
                                child: Text('We need a funny name!'));
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder<PlacesSearchResult>(
                            stream: _bloc.pickedPlaceStream,
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return Container();
                              }
                              if (snap.hasData) {
                                return ListTile(
                                  leading: Image(
                                      image: NetworkImage(snap.data.icon)),
                                  title: Text(snap.data.name),
                                );
                              }
                            }),
                      ),
                      StreamBuilder<DateTime>(
                          stream: _bloc.dateTimeStream,
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return Container();
                            }
                            if (snap.hasData) {
                              return Text(snap.data.toString());
                            }
                          }),
                      Expanded(
                        child: Wrap(
                          direction: Axis.vertical,
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
                        Expanded(flex: 2, child: _createPlaceFinder())
                      ],
                      if (snapshot.data == 2) ...[
                        Expanded(flex: 2, child: _createTimeFinder())
                      ],
                      if (snapshot.data == 3 ) ...[
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
                        if (snapshot.data == 3) ...[
                          Expanded(
                            child: FloatingActionButton(
                              onPressed: () {_sendEvent(SidekickTeamBuilder.of(context).targetList);},
                              child: Icon(Icons.send),
                            ),
                          )
                        ]
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, right: 30.0),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton(
                                      heroTag: 0,
                                      onPressed: () => _bloc.increment())),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, left: 30.0),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: FloatingActionButton(
                                      heroTag: 1,
                                      onPressed: () => _bloc.decrement())),
                            ),
                          ],
                        ),
                      )
                    ]);
                  });
            }));
  }

  _createTimeFinder() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FlatButton(
              color: Colors.blueAccent,
              onPressed: () {
                _bloc.setTimeToDateTime(DateTime.now());
              },
              child: Text('Now!')),
        ),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 10.0,
          children: <Widget>[
            FlatButton(
                color: Colors.blue,
                onPressed: () {
                  _bloc.setTimeToDateTime(
                      DateTime.now().add(Duration(minutes: 30)));
                },
                child: Text('In 30')),
            FlatButton(
                color: Colors.blue,
                onPressed: () {
                  _bloc.setTimeToDateTime(
                      DateTime.now().add(Duration(minutes: 60)));
                },
                child: Text('In 60')),
            FlatButton(
                color: Colors.blue,
                onPressed: () {
                  _bloc.setTimeToDateTime(
                      DateTime.now().add(Duration(minutes: 90)));
                },
                child: Text('In 90')),
            FlatButton(
                color: Colors.blue,
                onPressed: () {
                  _bloc.setTimeToDateTime(
                      DateTime.now().add(Duration(minutes: 120)));
                },
                child: Text('In 120')),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10.0,
          children: <Widget>[
            FlatButton(
                color: Colors.pink,
                onPressed: () {
                  _DayButtonClicked(0);
                },
                child: Text('Today')),
            FlatButton(
                color: Colors.pink,
                onPressed: () {
                  _DayButtonClicked(1);
                },
                child: Text('Tomorrow'))
          ],
        ),
      ],
    );
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
              itemBuilder: (_, index) => ListTile(
                    onTap: () => _bloc.addToThreeWordNameList(
                        name: NameList().nameList[index]),
                    title: Text(NameList().nameList[index]),
                  )),
        ),
      ),
    );
  }

  _createPlaceFinder() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.restaurant),
                onPressed: () => _updatePlacesList('Restaurant'),
              ),
              IconButton(
                icon: Icon(Icons.local_bar),
                onPressed: () => _updatePlacesList('Bar'),
              ),
              IconButton(
                icon: Icon(Icons.local_cafe),
                onPressed: () => _updatePlacesList('Cafe'),
              )
            ],
          ),
        ),
        Container(
          color: Colors.red,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placesList.length,
              itemBuilder: (_, index) => ListTile(
                  onTap: () => _bloc.addPlace(_placesList[index]),
                  leading: Image(image: NetworkImage(_placesList[index].icon)),
                  title: Text(_placesList[index].name))),
        )
      ],
    );
  }

  _updatePlacesList(String place) async {
    await _bloc.getListOfPlaces(search: place).then((v) {
      setState(() {
        _placesList = v.results;
      });
    });
  }

  void _DayButtonClicked(int day) {
    _bloc.increment();
    DateTime todaySelectedDateTime;

    Future<TimeOfDay> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((time) {
      if (day == 0) {
        final now = new DateTime.now();
        todaySelectedDateTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
      }
      if (day == 1) {
        final now = new DateTime.now().add(Duration(days: 1));
        todaySelectedDateTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
      }
      if (todaySelectedDateTime.isAfter(DateTime.now())) {
        _bloc.setTimeToDateTime(todaySelectedDateTime);
      } else {
        final snackBar = SnackBar(content: Text('Travelling back in Time?!'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        _bloc.decrement();
      }
    });
  }

  void _sendEvent(List userList) async {
   await _bloc.setInvitedUserList(userList);
    print( userList);
    await _bloc.createEvent();
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
