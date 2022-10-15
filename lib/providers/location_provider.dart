import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/helpers/distance_helper.dart';
import 'package:darboda/models/driver_model.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:location/location.dart';
import 'package:geocoder2/geocoder2.dart';

class UserLocation {
  final GeoPoint? location;
  final String? city;
  final String? country;
  final String? street;
  final String? postalCode;
  final String? state;
  final String? address;

  UserLocation(
      {this.location,
      this.city,
      this.country,
      this.address,
      this.street,
      this.postalCode,
      this.state});

  Map<String, dynamic> toJson() {
    return {
      'location': GeoPoint(location?.latitude ?? 0, location?.longitude ?? 0),
      'city': city,
      'country': country,
      'street': street,
      'postalCode': postalCode,
      'state': state,
      'address': address,
    };
  }

  factory UserLocation.fromJson(dynamic json) {
    return UserLocation(
      location: json['location'],
      city: json['city'],
      country: json['country'],
      street: json['street'],
      postalCode: json['postalCode'],
      state: json['state'],
      address: json['address'],
    );
  }
}

class LocationProvider with ChangeNotifier {
  double? _longitude;
  double? _latitude;
  double? get longitude => _longitude;
  double? get latitude => _latitude;
  LocationData? _locationData;
  LocationData? get locationData {
    return _locationData;
  }

  List<RiderModel> _nearbyRiders = [];
  List<RiderModel> get nearbyRiders {
    return [..._nearbyRiders];
  }

  UserLocation? _userLocation;
  UserLocation? get userLocation {
    return _userLocation;
  }

  final List<Map<String, dynamic>> _addressList = [];
  Future<void> getCurrentLocation() async {
    //using location package
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //GETTING CURRENT LOCATION OF USER

    _locationData = await location.getLocation();

    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: _locationData!.latitude!,
        longitude: _locationData!.longitude!,
        googleMapApiKey: "AIzaSyDIL1xyrMndlk2dSSSSikdobR8qDjz0jjQ");

    _userLocation = UserLocation(
      city: data.city,
      country: data.country,
      street: data.streetNumber,
      postalCode: data.postalCode,
      address: data.address,
      state: data.state,
      location: GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
    );

    notifyListeners();
  }

  List preferredUserLocations({Map<String, dynamic>? locations}) {
    final currentLocation = {
      'title': 'Current Location',
      'address': userLocation!.address,
    };
    if (locations != null) {
      _addressList.add(locations);
    }
    return [
      currentLocation,
      ..._addressList,
    ];
  }

  Future<UserLocation> getLocationDetails(LatLng loc) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: loc.latitude,
        longitude: loc.longitude,
        googleMapApiKey: "AIzaSyDIL1xyrMndlk2dSSSSikdobR8qDjz0jjQ");

    return UserLocation(
      city: data.city,
      country: data.country,
      street: data.streetNumber,
      postalCode: data.postalCode,
      address: data.address,
      state: data.state,
      location: GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
    );
  }

  Future<List> searchPlace(String searchTerm) async {
    var googlePlace = GooglePlace("AIzaSyCzgo2cyjncjSLKElT7OIC0lj9hDdj1Fj4");
    var result = await googlePlace.queryAutocomplete.get(searchTerm,
        location: LatLon(locationData!.latitude!, locationData!.longitude!),
        radius: 1000);
    if (result == null) {
      return [];
    }

    final results = [];

    for (var prediction in result.predictions!) {
      var name = prediction.structuredFormatting!.mainText;

      results.add({
        'place': prediction.description!,
        'name': name,
        'placeId': prediction.placeId,
      });
    }

    return results;
  }

  Future<void> getNearbyDrivers() async {
    final List<RiderModel> drivers = [];

    final results = await FirebaseFirestore.instance
        .collection('riders')
        .where('isOnline', isEqualTo: true)
        .limit(30)
        .get();

    for (var element in results.docs) {
      drivers.add(RiderModel.fromJson(element.data()));
    }

    //Sort the drivers by distance
    drivers.sort((a, b) {
      final aDistance = calculateDistance(
          a.currentLocation!.latitude,
          a.currentLocation!.longitude,
          _locationData!.latitude!,
          _locationData!.longitude!);
      final bDistance = calculateDistance(
          b.currentLocation!.latitude,
          b.currentLocation!.longitude,
          _locationData!.latitude!,
          _locationData!.longitude!);

      return aDistance.compareTo(bDistance);
    });

    _nearbyRiders = drivers;
    notifyListeners();
  }
}
