// ignore_for_file: use_build_context_synchronously

import 'package:darboda/constants.dart';
import 'package:darboda/helpers/distance_helper.dart';
import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/screens/search/amount_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';

class ConfirmMapScreen extends StatefulWidget {
  const ConfirmMapScreen({
    Key? key,
    required this.location,
    required this.address,
  }) : super(key: key);

  final LatLng? location;
  final String? address;

  @override
  State<ConfirmMapScreen> createState() => _ConfirmMapScreenState();
}

class _ConfirmMapScreenState extends State<ConfirmMapScreen> {
  GoogleMapController? _controller;

  final Set<Marker> _markers = <Marker>{};
  final Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
//Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = const PolylineId("1");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.green,
        points: _coordinates,
        width: 4,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
    });
  }

//google cloud api key
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyDIL1xyrMndlk2dSSSSikdobR8qDjz0jjQ");

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    // String value = await DefaultAssetBundle.of(context)
    //     .loadString('assets/map_style.json');
    // _controller!.setMapStyle(value);
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData!;
    final user = Provider.of<AuthProvider>(context, listen: false).user!;

    _markers.add(
      Marker(
        markerId: const MarkerId('customer'),
        onTap: () {},
        icon: await MarkerIcon.downloadResizePictureCircle(user.profilePic!,
            size: 100, borderColor: kPrimaryColor),
        position: LatLng(loc.latitude!, loc.longitude!),
      ),
    );
    final drivers =
        Provider.of<LocationProvider>(context, listen: false).nearbyRiders;

    for (int i = 0; i < drivers.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('$i'),
        position: LatLng(drivers[i].currentLocation!.latitude,
            drivers[i].currentLocation!.longitude),
        infoWindow: InfoWindow(
          title: drivers[i].name,
          snippet: i % 2 == 0 ? 'Passenger' : 'Goods',
        ),
        icon: await MarkerIcon.pictureAsset(
            assetPath: 'assets/images/rider.png', height: 110, width: 110),
      ));
    }

    setState(() {});
    var coordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(loc.latitude!, loc.longitude!),
        destination: widget.location!,
        mode: RouteMode.driving);
    _addPolyline(coordinates!);

    setState(() {});
//Get center of the route
    final bounds = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(loc.latitude!, loc.longitude!),
        destination: widget.location!,
        mode: RouteMode.driving);
    final center = LatLng((bounds!.first.latitude + bounds.last.latitude) / 2,
        (bounds.first.longitude + bounds.last.longitude) / 2);

//Get LatLngBounds

    //Calculate zoom level to make sure the route is visible

    final zoom = getMapBoundZoom(boundsFromLatLngList(bounds),
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    setState(() {
      _controller!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: center, zoom: zoom)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          polylines: _polylines.values.toSet(),
          initialCameraPosition:
              CameraPosition(target: widget.location!, zoom: 18),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AmountDialog(
              location: widget.location!,
              address: widget.address!,
            ))
      ],
    ));
  }
}
