import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
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
        backgroundColor: Colors.blueAccent,
        key: _scaffoldKey,
        appBar: AppBar(),
        body: StreamBuilder<Object>(
            stream: _bloc.stream$,
            builder: (context, snapshot) {
              List<User> _justFriendsList = [];
              _friendsList.forEach((user) {
                if (user.requestStatus == 'friend') {
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
                                      return Container(
                                        height: 10,
                                        alignment: Alignment.center,
                                        child: Text(
                                          snapshot.data[index],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }),
                              );
                            }

                            return Expanded(
                                child: Container(
                                    color: Colors.blueAccent,
                                    alignment: Alignment.center,
                                    child: Text('We need a funny name!')));
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
                              return Column(
                                children: <Widget>[
                                  Text(_getDate(snap.data)),
                                  Text(TimeOfDay.fromDateTime(snap.data)
                                      .format(context)),
                                ],
                              );
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
                        Expanded(
                            flex: 2,
                            child: Container(
                                color: Colors.blueAccent,
                                child: _createNameFinderRow()))
                      ],
                      if (snapshot.data == 1) ...[
                        Expanded(flex: 4, child: _createPlaceFinder())
                      ],
                      if (snapshot.data == 2) ...[
                        Expanded(flex: 2, child: _createTimeFinder())
                      ],
                      if (snapshot.data == 3) ...[
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
                              onPressed: () {
                                _sendEvent(
                                    SidekickTeamBuilder.of(context).targetList);
                                _showSnackbar();
                                return Navigator.pop(context);
                              },
                              child: Icon(Icons.send),
                            ),
                          )
                        ]
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            if (snapshot.data != 3) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, right: 30.0),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: FloatingActionButton(
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.arrow_forward),
                                        heroTag: 0,
                                        onPressed: () => _bloc.increment())),
                              )
                            ],
                            /* if (snapshot.data == 3) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, right: 30.0),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Checkbox()),
                              )
                            ],*/
                            if (snapshot.data != 0) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 30.0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: FloatingActionButton(
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.arrow_back),
                                        heroTag: 1,
                                        onPressed: () => _bloc.decrement())),
                              ),
                            ]
                          ],
                        ),
                      )
                    ]);
                  });
            }));
  }

  _createTimeFinder() {
    double height = 30;
    double fontSize = 20;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ListView(
            itemExtent: 200,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                    color: Colors.blueAccent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      _bloc.setTimeToDateTime(DateTime.now());
                    },
                    child: Text(
                      'Now!',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _bloc.setTimeToDateTime(
                            DateTime.now().add(Duration(minutes: 30)));
                      },
                      child:
                          Text('In 30!', style: TextStyle(fontSize: fontSize))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _bloc.setTimeToDateTime(
                            DateTime.now().add(Duration(minutes: 60)));
                      },
                      child:
                          Text('in 60!', style: TextStyle(fontSize: fontSize))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _bloc.setTimeToDateTime(
                            DateTime.now().add(Duration(minutes: 90)));
                      },
                      child:
                          Text('in 90!', style: TextStyle(fontSize: fontSize))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _bloc.setTimeToDateTime(
                            DateTime.now().add(Duration(minutes: 120)));
                      },
                      child: Text('in 120!',
                          style: TextStyle(fontSize: fontSize))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _DayButtonClicked(0);
                      },
                      child:
                          Text('Today!', style: TextStyle(fontSize: fontSize))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _DayButtonClicked(1);
                      },
                      child: Text('Tomorrow!',
                          style: TextStyle(fontSize: fontSize))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height,
                  child: OutlineButton(
                      color: Colors.blueAccent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _dateTimePicker();
                      },
                      child: Text('some time',
                          style: TextStyle(fontSize: fontSize))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _createNameFinderRow() {
    return Container(
      child: Row(
        children: <Widget>[
          _createNameFinder(1),
          _createNameFinder(2),
          _createNameFinder(0)
        ],
      ),
    );
  }

  _createNameFinder(int num) {
    List nameList;
    if (num == 1) {
      nameList = NameList().nameListOne;
    } else if (num == 2) {
      nameList = NameList().nameList2;
    } else {
      nameList = NameList().activityList;
    }
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: nameList.length,
              itemBuilder: (_, index) => ListTile(
                    onTap: () =>
                        _bloc.addToThreeWordNameList(name: nameList[index]),
                    title: Text(nameList[index]),
                  )),
        ),
      ),
    );
  }

  _createPlaceFinder() {
    double size = 35;
    return Column(
      children: <Widget>[
        Container(
          child: Image(
            height: 15,
            image: AssetImage("assets/images/powered_google.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration:
                InputDecoration(hintText: 'type in location or use buttons'),
            textAlign: TextAlign.center,
            onSubmitted: (string) => _updatePlacesList(string),
          ),
        ),
        Expanded(
          child: ListView(
            //runAlignment: WrapAlignment.spaceBetween,
            scrollDirection: Axis.horizontal, itemExtent: 70,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.my_location,
                  size: size,
                ),
                onPressed: () => _updatePlacesList('My location'),
              ),
              IconButton(
                icon: Icon(
                  Icons.restaurant,
                  size: size,
                ),
                onPressed: () => _updatePlacesList('Restaurant'),
              ),
              IconButton(
                icon: Icon(
                  Icons.local_bar,
                  size: size,
                ),
                onPressed: () => _updatePlacesList('Bar'),
              ),
              IconButton(
                icon: Icon(
                  Icons.local_cafe,
                  size: size,
                ),
                onPressed: () => _updatePlacesList('Cafe'),
              ),
              IconButton(
                icon: Icon(
                  Icons.movie,
                  size: size,
                ),
                onPressed: () => _updatePlacesList('Movies'),
              ),
              IconButton(
                icon: Icon(
                  Icons.pool,
                  size: size,
                ),
                onPressed: () => _updatePlacesList('swimming pool'),
              ),
              IconButton(
                  icon: Icon(
                    Icons.local_florist,
                    size: size,
                  ),
                  onPressed: () => _updatePlacesList('parks')),
              IconButton(
                  icon: Icon(
                    Icons.local_see,
                    size: size,
                  ),
                  onPressed: () => _updatePlacesList('attractions')),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          // color: Colors.red,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placesList.length,
              itemBuilder: (_, index) => ListTile(
                    onTap: () => _bloc.addPlace(_placesList[index]),
                    //onLongPress: _bloc.,
                    leading: Image(
                      image: NetworkImage(
                        _placesList[index].icon,
                      ),
                      height: 25,
                    ),
                    title: Text(_placesList[index].name),
                    subtitle: Row(
                      children: <Widget>[
                        Text(_getOpeninghours(_placesList[index])),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(_getVicinity(_placesList[index])),
                        ),
                      ],
                    ),
                  )),
        )
      ],
    );
  }

  String _getDate(DateTime dateTime) {
    var time = dateTime;
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(time);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dateToCheck = DateTime(time.year, time.month, time.day);

    if (dateToCheck == today) {
      formatted = 'Today';
    }
    if (dateToCheck == yesterday) {
      formatted = 'Yesterday';
    }
    if (dateToCheck == tomorrow) {
      formatted = 'tomorrow';
    } else {
      formatted = formatted.toString();
    }
    return formatted;
  }

  String _getOpeninghours(PlacesSearchResult results) {
    String open;
    PlacesSearchResult result = results;
    if (result != null &&
        result.openingHours != null &&
        result.openingHours.openNow != null &&
        result.openingHours.openNow) {
      open = 'Open now';
      return open;
    } else
      open = 'closed';
    return open;
  }

  String _getVicinity(PlacesSearchResult results) {
    String vicinity = 'so close';
    PlacesSearchResult result = results;

    if (result.vicinity != null) {
      return result.vicinity;
    } else
      return vicinity;
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

    showTimePicker(
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

  _dateTimePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(days: 1)),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 700)))
        .then((date) {
      if (date.isAfter(DateTime.now())) {
        showTimePicker(context: context, initialTime: TimeOfDay.now())
            .then((time) {
              DateTime combinedTime = DateTime(date.year,date.month,date.day, time.hour,time.minute);
              _bloc.setTimeToDateTime(combinedTime);
        });
      } else {
        final snackBar = SnackBar(content: Text('Travelling back in Time?!'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        _bloc.decrement();
      }
    });
  }

  void _sendEvent(List userList) async {
    await _bloc.setInvitedUserList(userList);
    print(userList);
    await _bloc.createEvent();
  }

  void _showSnackbar() {
    final snackBar = SnackBar(content: Text('Sent!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
          padding: const EdgeInsets.all(5.0),
          child: Material(
              color: Colors.blueAccent, child: UserBubble(user: user))),
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
