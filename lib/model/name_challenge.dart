import 'package:cloud_firestore/cloud_firestore.dart';

class NameChallenge {
  final String challenger;
  final String newName;
  final String challengeId;

  NameChallenge({this.challenger, this.newName, this.challengeId});

  factory NameChallenge.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return NameChallenge.fromJson(data);
  }

  factory NameChallenge.fromJson(Map doc) {
    return NameChallenge(
        challenger: doc['challenger'],
        newName: doc['newName'],
        challengeId: doc['challengeId']);
  }

  Map<String, Object> toJson() {
    return {
      'challenger': challenger,
      'newName': newName,
      'challengeId': challengeId
    };
  }
}
