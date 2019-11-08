import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider {
  static const String _googleApiKey = 'AIzaSyCFvSvlS_QGpJdZAUgAWj_fxTtoM_AuM50';
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _googleApiKey);

  /// method returns the USers current location as a Future LatLng, On exceptions returns null

  /*Future<LatLng> getUserLocation_() async {
    LocationManager.LocationData currentLocation;
    Location location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.altitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }*/

  Future <LatLng>getUserLocation()async{
    //Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
     Position position = await Geolocator().getLastKnownPosition();
    final lat = position.altitude;
    final lng = position.longitude;
    final center = LatLng(lat, lng);
    return center;
  }



  Future<PlaceDetails> getPlaceById(String id) async {
    PlacesDetailsResponse placeDetailRespond =
        await _places.getDetailsByPlaceId(id);
    print('Cost----use of placeAPI getDetailsByPLaceId');
    PlaceDetails placeDetails = placeDetailRespond.result;
    return placeDetails;
  }

  ///method returns PlacesSearchResponse which can turn with .result into List<PlacesSearchResult>

  Future<PlacesSearchResponse> getNearbyPlacesByText(
      {String searchString, Location location}) async {
    final _result = await _places.searchByText(
      searchString,
      location: location,radius: 0.1
    );
    print('Cost:-----use of PlacesAPI searchByText');
    return _result;
  }
}
