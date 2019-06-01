import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:peng_u/model/event.dart';
import 'package:peng_u/model/user.dart';

import 'package:peng_u/resources/repository.dart';

class NewEventBloc {
  final _repository = Repository();

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
