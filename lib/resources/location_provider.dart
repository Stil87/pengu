import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:google_maps_webservice/places.dart';

class LocationProvider {
  static const String _googleApiKey = 'AIzaSyCFvSvlS_QGpJdZAUgAWj_fxTtoM_AuM50';
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _googleApiKey);

  /// method returns the USers current location as a Future LatLng, On exceptions returns null

  Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
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
  }

  ///method returns PlacesSearchResponse which can turn with .result into List<PlacesSearchResult>

  Future<PlacesSearchResponse> getNearbyPlacesByText(
      {String searchString, Location location}) async {
    final _result = await _places.searchByText(searchString,
      location: location,
    );
print (_result.status);
    return _result;
  }
}
