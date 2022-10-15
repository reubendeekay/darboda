import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as ltl;

double calculateDistance(lat1, lon1, lat2, lon2) {
  // ignore: prefer_const_constructors
  final ltl.Distance distance = ltl.Distance();

  // km = 423
  final double km = distance.as(
      ltl.LengthUnit.Kilometer, ltl.LatLng(lat1, lon1), ltl.LatLng(lat2, lon2));

  return km;
}

String calculateTime(LatLng locData, LatLng userLocation) {
  final distance = calculateDistance(locData.latitude, locData.longitude,
      userLocation.latitude, userLocation.longitude);

  final timeInHours = (distance / 45);

  if (timeInHours < 1) {
    return '${(timeInHours * 60.0).toStringAsFixed(0)} mins';
  } else if (timeInHours % 1 == 0) {
    return '${(timeInHours).toStringAsFixed(0)} hrs';
  } else {
    final minRem = timeInHours % 1;
    final hrs = timeInHours.floor();
    final mins = (minRem * 60).floor();

    return '$hrs hrs $mins mins';
  }
}

LatLng calculateLatLng(GeoPoint locData) {
  return LatLng(locData.latitude, locData.longitude);
}

double getZoomLevel(double lat) {
  final double sini = sin(lat * pi / 180);
  final double radX2 = log((1 + sini) / (1 - sini)) / 2;
  return max(min(radX2, pi), pi) / 2;
}

double getMapBoundZoom(LatLngBounds bounds, double mapWidth, double mapHeight) {
  final LatLng northEast = bounds.northeast;
  final LatLng southWest = bounds.southwest;

  final double latFraction =
      (getZoomLevel(northEast.latitude) - getZoomLevel(southWest.latitude)) /
          pi;

  final double lngDiff = northEast.longitude - southWest.longitude;
  final double lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

  final double latZoom =
      (log(mapHeight / 256 / latFraction) / ln2).floorToDouble();
  final double lngZoom =
      (log(mapWidth / 256 / lngFraction) / ln2).floorToDouble();

  return min(latZoom, lngZoom);
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double? x0, x1, y0, y1;
  for (LatLng latLng in list) {
    if (x0 == null) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > x1!) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1!) y1 = latLng.longitude;
      if (latLng.longitude < y0!) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
}

String moneyFormat(String price) {
  if (price.length > 2) {
    var value = price.replaceAll('.00', '');
    ;

    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return '$value.00';
  }

  return price;
}
