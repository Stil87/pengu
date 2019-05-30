import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/model/pengU_user.dart';

class Event {
  String roomId;
  String eventName;
  DateTime dateTime;
  String googlePlaceId;
  List<User> invitedUserObjectList;

  Event({
    this.roomId,
    this.eventName,
    this.dateTime,
    this.googlePlaceId,
    this.invitedUserObjectList,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Event(
        roomId: doc.documentID,
        eventName: data['eventName'] ?? '',
        dateTime: data['dateTime'] ?? DateTime.now(),
        googlePlaceId: data['googlePlaceId'] ?? '',
        invitedUserObjectList: data['invitedUserObjectList'] ?? null);
  }

  Map<String, Object> toJson() {
    return {
      'roomId': roomId,
      'eventName': eventName,
      'dateTime': dateTime,
      'googlePlaceId': googlePlaceId,
      'invitedUserObjectList': invitedUserObjectList,
    };
  }
}

