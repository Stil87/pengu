import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/event_place.dart';
import 'package:peng_u/model/user.dart';

import 'package:peng_u/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class NewEventBloc {
  final _repository = Repository();

  BehaviorSubject _counter = BehaviorSubject(seedValue: 0);
  BehaviorSubject<List> _threeWordNameList = BehaviorSubject<List>();
  BehaviorSubject<PlacesSearchResult> _pickedPlace = BehaviorSubject();
  BehaviorSubject<DateTime> _dateTime = BehaviorSubject();
  BehaviorSubject<List<User>> _invitedUserList = BehaviorSubject();

  Observable<List<User>> get invitedUserListStream => _invitedUserList.stream;

  List get invitedUserList => _invitedUserList.value;

  Observable get stream$ => _counter.stream;

  int get current => _counter.value;

  Observable<List> get treeWordNameListStream => _threeWordNameList.stream;

  List get currentThreeWordList => _threeWordNameList.value;

  Observable<PlacesSearchResult> get pickedPlaceStream => _pickedPlace.stream;

  PlacesSearchResult get pickedPlace => _pickedPlace.value;

  Observable<DateTime> get dateTimeStream => _dateTime.stream;

  DateTime get selectedDateTime => _dateTime.value;

  setTimeToDateTime(DateTime dateTime) {
    _dateTime.add(dateTime);
  }

  setInvitedUserList(List userList) async {
    //add the user itself to the list
    FirebaseUser currentFirebaseUser =
        await _repository.getCurrentFirebaseUser();
    await _repository
        .getUserFromFirestoreCollectionFuture(userID: currentFirebaseUser.uid)
        .then((user) {
      user.eventRequestStatus = 'inviter';
      userList.add(user);
      _invitedUserList.add(userList);
    });
  }

  addPlace(PlacesSearchResult place) {
    _pickedPlace.add(place);
  }

  increment() {
    _counter.add(current + 1);
    print(_counter.value);
  }

  decrement() {
    if (current > 0) {
      _counter.add(current - 1);
      print(_counter.value);
    }
  }

  setZero() {
    _counter.add(0);
  }

  addToThreeWordNameList({String name, int position}) {
    List _list = List();
    _list = [];

    if (_threeWordNameList.value != null) {
      _list = _threeWordNameList.value;
    }
    if (_list.length <= 2 || _list.isEmpty) {
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
    await _pickedPlace.drain();
    _pickedPlace.close();
    await _dateTime.drain();
    _dateTime.close();
    await _invitedUserList.drain();
    _invitedUserList.close();
  }

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

  Stream<Event> streamDummyEvent(String eventId) {
    return _repository.streamDummyEventById(eventId: eventId);
  }

  Future<String> createEventDummy() async {
    String uniqueRoomId = await _repository
        .createNewRoomWithUniqueIDAtFirestoreRoomCollection(); //rooms/unique key
    return uniqueRoomId;
  }

  Future<Event> createEvent() async {
    String uniqueRoomId =
        await _repository.createNewRoomWithUniqueIDAtFirestoreRoomCollection();

    Event event = Event(
        eventName: currentThreeWordList.toString(),
        dateTime: selectedDateTime,
        eventPlace: EventPlace(
            placeName: pickedPlace.name, placeId: pickedPlace.placeId),
        invitedUserObjectList: invitedUserList,
        roomId: uniqueRoomId);
    spreadEventToFriends(event);
  }

  Future<void> spreadEventToFriends(Event event) {
    event.invitedUserObjectList.forEach((user) async {
      await _repository.addRoomObjectToUsersPrivateRoomList(
          userID: user.userID, roomID: event.roomId, event: event);
      print('event created');
    });
  }
}
