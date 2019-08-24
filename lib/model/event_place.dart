import 'package:cloud_firestore/cloud_firestore.dart';

class EventPlace {
  final String placeName;
  final String placeId;

  EventPlace({this.placeName, this.placeId});

  factory EventPlace.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return EventPlace.fromJson(data);
  }

  factory EventPlace.fromJson(Map doc) {
    return EventPlace(placeName: doc['placeName'], placeId: doc['placeId']);
  }

  Map<String, Object> toJson() {
    return {'placeName': placeName, 'placeId': placeId};
  }
}
