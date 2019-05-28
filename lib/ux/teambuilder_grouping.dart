import 'dart:async';
import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sidekick/flutter_sidekick.dart';
import 'package:peng_u/business/backend/firebase_auth.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/pengU_user.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:peng_u/ux/user_bubble.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:google_maps_webservice/places.dart';

class TeambuilderstflGroup extends StatefulWidget {
  @override
  _TeambuilderstflGroupState createState() => _TeambuilderstflGroupState();
}

class _TeambuilderstflGroupState extends State<TeambuilderstflGroup> {
  //StreamController<User> streamController;
  List<User> userList = List();
  StreamSubscription streamSub;
  StreamSubscription streamUserRooms;
  List<User> finalUserList = List();
  String currentUserID = '';
  String roomId;
  TextEditingController textEditingController = TextEditingController();
  static const String googleApiKEy = 'AIzaSyCFvSvlS_QGpJdZAUgAWj_fxTtoM_AuM50';
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKEy);
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading;
  String errorMessage;
  final _repository = Repository();

  _statefulWidgetDemoState() {
    Auth.getCurrentFirebaseUserId().then((val) => setState(() {
          currentUserID = val;
        }));
  }

  @override
  void initState() {
    //StreamController sc = StreamController.broadcast();
    startfunction();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    streamSub.cancel();
    //streamController.close();
  }

  startfunction() async {
    List<User> list = [];

    streamSub =
        Firestore.instance.collection('users').snapshots().listen((snapshot) {
      //Todo: add only where...
      snapshot.documents.forEach((doc) => list.add(User.fromDocument(doc)));
      list.toSet();

      _statefulWidgetDemoState(); //get currentuserId

      //Future<List<T>> toList() async {
      //  final result = <T>[];
      //await this.forEach(result.add);
      //return result;
      // }

      setState(() {
        //Todo: List doubles users somehow
        userList = [];
        userList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SidekickTeamBuilder<User>(
      //Todo add Streambuilder and Stream function to auth like mainscreen
      // body: StreamBuilder(
      //        stream: Auth.getUser(widget.firebaseUser.uid),
      //        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
      initialSourceList: userList,
      //List.generate(20, (i) => Item(id: i)),
      //initialTargetList: finalUserList,
      builder: (context, sourceBuilderDelegates, targetBuilderDelegates) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
              ),
              Text('select your besties'),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(0.0, 0.0)),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              Expanded(
                  child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(hintText: 'Search'),
              )),
              Expanded(
                child: ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Text(places[index].name);
                    }),
              ),
              FlatButton(
                color: Colors.lightBlueAccent,
                child: Text('group!'),
                onPressed: () => printPlacesWithUserLoactio(),
              ),
              FlatButton(
                  child: Text('invite'),
                  color: Colors.red,
                  onPressed: () => sendInviteToselectedUser(context)),
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('logOut'),
                      onPressed: () => _repository.signOutFirebaseAuth(),
                    ),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () => SidekickTeamBuilder.of<User>(context)
                          .moveAll(SidekickFlightDirection.toTarget),
                    ),
                    SizedBox(width: 60.0, height: 60.0),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () => SidekickTeamBuilder.of<User>(context)
                          .moveAll(SidekickFlightDirection.toSource),
                    ),
                  ],
                ),
              ),
              Expanded(
                //height: 250.0,
                child: Wrap(
                  direction: Axis.vertical,
                  //todo: List statefull widget mit targetdelegate as child
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
              Expanded(
                //height: 50.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('users')
                          .document(currentUserID)
                          .collection('userRooms')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new Text('Loading...');
                          default:
                            return new ListView(
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                //for (int i = 0; i <= snapshot.data.documents.length; i++)
                                return GestureDetector(
                                  child: Text(document['eventName']),
                                  onTap: changeUserComittment(),
                                );
                              }).toList(),
                            );
                        }
                      })),
            ],
          ),
        );
      },
    );
  }

  void printGroupList(BuildContext context) {
    finalUserList = SidekickTeamBuilder.of(context).targetList;
    print(finalUserList[0].firstName);
    Auth.addUserToMyFavoriteList(finalUserList);
  }

  sendInviteToselectedUser(BuildContext context) async {
    //Todo: create each tim a new  List with in in the method do not use global list
    finalUserList = SidekickTeamBuilder.of(context).targetList;
    //List userIdList =  List();
    var addedUserList =
        finalUserList.map((u) => {u.userID: 'unknown'}).toList();
    /*for( int i = 0; i == finalUserList.length; i++) {
      userIdList.add(finalUserList[i].userID);
    }*/
    //Event event = Event(invitedUserId: userIdList);
    //Map<String, List> userMap = {"invitedUsersIds": addedUserList, 'event' : 'vögelei'};
    Event event = Event(
        invitedUserId: addedUserList, eventName: textEditingController.text);
    roomId = Firestore.instance.collection('rooms').document().documentID;
    print(roomId);
    finalUserList.forEach((user) {
      Firestore.instance
          .collection('users')
          .document(user.userID)
          .collection('userRooms')
          .document(roomId)
          .setData(event.toJson());

      print(user.userID);
    });
  }

  changeUserComittment() {
    Firestore.instance
        .collection('users')
        .document(currentUserID)
        .collection('userRooms')
        .document(roomId)
        .updateData({
      'invitedUser': {currentUserID: 'in'}
    });
    print('change Comittment');
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    //refresh();
  }

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    //getNearbyPlaces(center);
  }

  Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.altitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      print('lat: $lat');
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void printPlacesWithUserLoactio() async {
    //LatLng center = await getUserLocation();
    getNearbyPlaces();
    textEditingController.clear();
    setState(() {
      places.clear();
    });
  }

  void getNearbyPlaces() async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(48.7643321, 9.1653504);
    final result = await _places.searchByText(
      textEditingController.text,
      location: location,
    );
    print('getNearbyPlaces:  ${result.results[1].name}');
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
      }
    });
  }

  void getNearbyPlacesPredicition() async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(48.7643321, 9.1653504);
    final result = await _places.searchByText(
      textEditingController.text,
      location: location,
    );
    print('getNearbyPlaces:  ${result.results[1].name}');
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
      }
    });
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
