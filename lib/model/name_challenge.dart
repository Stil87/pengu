import 'package:cloud_firestore/cloud_firestore.dart';

class NameChallenge {
  final String challenger;
  final String newName;

  NameChallenge({this.challenger, this.newName});

  factory NameChallenge.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return NameChallenge.fromJson(data);
  }

  factory NameChallenge.fromJson(Map doc) {
    return NameChallenge(
        challenger: doc['challenger'], newName: doc['newName']);
  }

  Map<String, Object> toJson() {
    return {'challenger': challenger, 'newName': newName};
  }
}
