import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peng_u/model/event.dart';

class User {
  final String userID;
  final String firstName;
  final String email;
  final String profilePictureURL;
  final List<Event> eventList;

  User({this.userID,
    this.firstName,
    this.email,
    this.profilePictureURL,
    this.eventList});

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'appIdentifier': 'PengYou',
      'eventList': eventList
    };
  }

  Map eventListToJson(List<Event> eventList) {


  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      userID: doc['userID'],
      firstName: doc['firstName'],
      email: doc['email'],
      profilePictureURL: doc['profilePictureURL'],
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
