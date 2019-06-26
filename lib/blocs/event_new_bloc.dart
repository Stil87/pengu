import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';

import 'package:peng_u/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class NewEventBloc {
  final _repository = Repository();

  //add rx stream contoller to each field. they return an observable instead of a stream
  /* final _wordOne = BehaviorSubject<String>();
  final _wordTwo = BehaviorSubject<String>();
  final _wordThree = BehaviorSubject<String>();
 

  Observable<String> get wordOne => _wordOne.stream;

  Observable<String> get wordTwo => _wordTwo.stream;

  Observable<String> get wordThree => _wordThree.stream;*/
  BehaviorSubject _counter = BehaviorSubject(seedValue: 0);
  BehaviorSubject<List> _threeWordNameList = BehaviorSubject<List>();

  Observable get stream$ => _counter.stream;

  int get current => _counter.value;

  Observable<List> get treeWordNameListStream => _threeWordNameList.stream;

  List get currentThreeWordList => _threeWordNameList.value;

  increment(int int) {
    _counter.add(int);
    print(_counter.value);
  }

  addToThreeWordNameList({String name, int position}) {
    List _list = List();
    _list = [];


    if (_threeWordNameList.value != null ) {
      _list = _threeWordNameList.value;
    }
    if (  _list.length <= 2 || _list.isEmpty) {
      _list.add(name);
    } else {
      _list.removeAt(0);
      _list.add(name);
    }
    _threeWordNameList.add(_list);
  }

  BehaviorSubject _pageRoot = BehaviorSubject(seedValue: 0);

  Observable get pageRooterStream => _pageRoot.stream;

  int get pageRootValue => _pageRoot.value;

  updatePAgeRootInt(int int) {
    _pageRoot.add(int);
    print(_pageRoot.value);
  }

  //change data

  void dispose() async {
    await _pageRoot.drain();
    _pageRoot.close();
    await _counter.drain();
    _counter.close();
    await _threeWordNameList.drain();
    _threeWordNameList.close();
  }

/*
  void dispose() async {
    await _wordOne.drain();
    _wordOne.close();
    await _wordTwo.drain();
    _wordTwo.close();
    await _wordThree.drain();
    _wordThree.close();
  }*/

  /// Method returns userLocation
  Future getUserLocation() => _repository.getUserLocation();

  ///Method return List of places
  ///
  Future<PlacesSearchResponse> getNearbyPlacesByText(
          {String searchString, Location location}) =>
      _repository.getNearbyPlacesByText(
          searchString: searchString, location: location);

  ///Method returns lists of places
  Future<PlacesSearchResponse> getListOfPlaces({String search}) async {
    LatLng latLng = await getUserLocation();
    //todo: implementing location dummy
    var location = Location(latLng.latitude, latLng.longitude);
    print(location);
    final locationDummy = Location(48.7643321, 9.1653504);
    var results = await getNearbyPlacesByText(
            searchString: search, location: locationDummy)
        .catchError((e) => print('places error : $e'));

    return results;
  }

  Future<Event> changeEvent(String eventId) {}

  Stream<Event> streamDummyEvent(String eventId) {
    return _repository.streamDummyEventById(eventId: eventId);
  }

  Future<String> createEventDummy() async {
    String uniqueRoomId = await _repository
        .createNewRoomWithUniqueIDAtFirestoreRoomCollection(); //rooms/unique key
    return uniqueRoomId;
  }

  Future<Event> createNewEvent(
      {@required String eventName,
      @required DateTime selectedDateTime,
      @required String googlePlaceId,
      @required List<User> invitedUserObjectList}) async {
    String uniqueRoomId =
        await _repository.createNewRoomWithUniqueIDAtFirestoreRoomCollection();
    Event event = Event(
        eventName: eventName,
        dateTime: selectedDateTime,
        googlePlaceId: googlePlaceId,
        invitedUserObjectList: invitedUserObjectList);
    return event;
  }

  Future<void> spreadEventToFriends(String userId, String roomId, Event event) {
    event.invitedUserObjectList.forEach((user) async {
      await _repository.addRoomObjectToUsersPrivateRoomList(
          userID: user.userID, roomID: roomId, event: event);
    });
  }
}
