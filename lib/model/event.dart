import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/model/user.dart';

import 'event_place.dart';
import 'name_challenge.dart';

class Event {
  String roomId;
  String eventName;
  DateTime dateTime;
  EventPlace eventPlace;
  List<User> invitedUserObjectList;
  List<NameChallenge> nameChallenge;

  Event({
    this.roomId,
    this.eventName,
    this.dateTime,
    this.eventPlace,
    this.invitedUserObjectList,
    this.nameChallenge,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    DateTime _toDateTime(timeStamp) {
      if (timeStamp is Timestamp) {
        DateTime dateTime = timeStamp.toDate();
        return dateTime;
      }
      return timeStamp;
    }

    List<User> _userListJsonToList(Map jsonUserList) {
      List<User> _userList = [];
      jsonUserList.forEach((key, value) {
        _userList.add(User.fromJson(value));
      });
      return _userList;
    }

    _nameChallengeListGenerator(Map doc) {
      List<NameChallenge> list = [];
      doc.forEach((key, value) =>list.add( NameChallenge.fromJson(value)));

      return list;


    }
    
    return Event(
        roomId: doc.documentID ?? '',
        eventName: data['eventName'] ?? 'we need a name',
        dateTime: _toDateTime(data['dateTime']) ?? DateTime.now(),
        eventPlace:
            EventPlace.fromJson(data['eventPlace']) ?? ' we need a place',
        invitedUserObjectList:
            _userListJsonToList(data['invitedUserObjectList']) ?? null,
        nameChallenge: _nameChallengeListGenerator(data['nameChallenge']) ?? null);
  }

  Map<String, Object> toJson() {
    return {
      'roomId': roomId,
      'eventName': eventName,
      'dateTime': dateTime,
      'eventPlace': eventPlace.toJson(),
      'invitedUserObjectList': userListToJson(invitedUserObjectList),
    };
  }

  Map<String, Object> userListToJson(List<User> list) {
    Map<String, Object> userMap = {};
    if (list.length > 0) {
      list.forEach((user) {
        userMap.addAll({user.userID: user.toJson()});
      });
    }
    print('here is the userMAp: $userMap');
    return userMap;
  }
}
