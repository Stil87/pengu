import 'package:flutter/material.dart';
import 'package:peng_u/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_webservice/places.dart';

class EventCardBloc {
  Repository _repository = Repository();

  getGooglePlaceObject(String googlePlaceId) =>
      _repository.getPlaceById(googlePlaceId);

  BehaviorSubject<PlaceDetails> _placeDetails = BehaviorSubject();

  Observable<PlaceDetails> get placeDetailsStream => _placeDetails.stream;

  dispose() async {
    await _placeDetails.drain();
    _placeDetails.close();
  }
}
