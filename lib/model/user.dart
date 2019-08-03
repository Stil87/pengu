import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/model/event.dart';

class User {
  final String userID;
  final String firstName;
  final String email;
  final String profilePictureURL;
  final List<Event> eventList;
  final String requestStatus;
  final String searchKey;

  User(
      {this.userID,
      this.firstName,
      this.email,
      this.profilePictureURL,
      this.eventList,
      this.requestStatus,
      this.searchKey});

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': firstName ?? 'default Name',
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'appIdentifier': 'PengYou',
      'eventList': eventList,
      'requestStatus': requestStatus,
      'searchKey': searchKey ?? 'd'
    };
  }

  Map eventListToJson(List<Event> eventList) {}

  factory User.fromJson(Map doc) {
    User user = new User(
        userID: doc['userID'] ?? 'defaultId',
        firstName: doc['firstName'] ?? 'default name',
        email: doc['email'] ?? 'default email',
        profilePictureURL: doc['profilePictureURL'],
        requestStatus: doc['requestStatus'] ?? 'noRequest',
        searchKey: doc['searchKey'] ?? 'd');
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
