import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/model/user.dart';

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
        roomId: doc.documentID ?? '',
        eventName: data['eventName'] ?? 'we need a name',
        dateTime: data['dateTime'] ?? DateTime.now(),
        googlePlaceId: data['googlePlaceId'] ?? ' we need a place',
        invitedUserObjectList: data['invitedUserObjectList'] ?? null);
  }

  Map<String,Object> toJson()  {
    return {
      'roomId': roomId,
      'eventName': eventName,
      'dateTime': dateTime,
      'googlePlaceId': googlePlaceId,
      'invitedUserObjectList': userListToJason(invitedUserObjectList),
    };
  }

  Map<String, Object> userListToJason(List<User> list)  {
    Map<String, Object> userMap = {};
    if (list.length > 0) {
      list.forEach((user) {
        userMap.addAll({
          user.userID: user.toJson()
        });
      });
    }
print ('here is the userMAp: $userMap');
    return userMap;
  }
}
