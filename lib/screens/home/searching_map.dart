import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/constants.dart';
import 'package:darboda/helpers/distance_helper.dart';
import 'package:darboda/loading_screen.dart';
import 'package:darboda/models/request_model.dart';
import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/providers/request_provider.dart';
import 'package:darboda/screens/home/cancelled_ride.dart';
import 'package:darboda/screens/home/driver_sliding_panel.dart';
import 'package:darboda/screens/review/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';

class SearchingMap extends StatefulWidget {
  const SearchingMap({Key? key, required this.requestId}) : super(key: key);
  final String requestId;

  @override
  State<SearchingMap> createState() => _SearchingMapState();
}

class _SearchingMapState extends State<SearchingMap> {
  GoogleMapController? _controller;
  bool isStarted = false;
  bool isFinishSearch = false;
  BitmapDescriptor icon1 =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor icon2 =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

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
        width: 5,
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
    final requestModel =
        await Provider.of<RequestProvider>(context, listen: false)
            .getRequestedRide(widget.requestId);

    _markers.addAll([
      if (requestModel.riderId != null)
        Marker(
          markerId: const MarkerId('driver'),
          onTap: () {},
          //circle to show the mechanic profile in map
          icon: await MarkerIcon.pictureAsset(
              assetPath: 'assets/images/bike.png', height: 110, width: 110),
          position: LatLng(requestModel.rider!.currentLocation!.latitude,
              requestModel.rider!.currentLocation!.longitude),
        ),
      Marker(
        markerId: const MarkerId('customer'),
        onTap: () {},
        icon: await MarkerIcon.downloadResizePictureCircle(user.profilePic!,
            size: 100, borderColor: kPrimaryColor),
        position: LatLng(loc.latitude!, loc.longitude!),
      ),
    ]);
    icon1 = await MarkerIcon.pictureAsset(
        assetPath: 'assets/images/rider.png', height: 130, width: 130);
    icon2 = await MarkerIcon.downloadResizePictureCircle(user.profilePic!,
        size: 100, borderColor: kPrimaryColor);
    setState(() {});
    if (requestModel.riderId != null) {
      var coordinates = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(loc.latitude!, loc.longitude!),
          destination: LatLng(requestModel.destinationLocation!.latitude,
              requestModel.destinationLocation!.longitude),
          mode: RouteMode.driving);
      _addPolyline(coordinates!);

      setState(() {});
//Get center of the route
      final bounds = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(loc.latitude!, loc.longitude!),
          destination: LatLng(requestModel.destinationLocation!.latitude,
              requestModel.destinationLocation!.longitude),
          mode: RouteMode.driving);
      final center = LatLng((bounds!.first.latitude + bounds.last.latitude) / 2,
          (bounds.first.longitude + bounds.last.longitude) / 2);

//Get LatLngBounds

      //Calculate zoom level to make sure the route is visible

      final zoom = getMapBoundZoom(
          boundsFromLatLngList(bounds),
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);

      setState(() {
        _controller!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: center, zoom: zoom)));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      //Animate zoom out to see all markers in view.
      setState(() {
        isStarted = true;
      });
      for (int i = 0; i < 11; i++) {
        await Future.delayed(const Duration(milliseconds: 100), () async {
          await _controller!
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                Provider.of<LocationProvider>(context, listen: false)
                    .locationData!
                    .latitude!,
                Provider.of<LocationProvider>(context, listen: false)
                    .locationData!
                    .longitude!),
            zoom: (23 - i).toDouble(),
          )));
        });
      }
      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isStarted = false;
          isFinishSearch = true;
        });
      });
    });
  }

  void animateCamera(GoogleMapController contr, LatLng loc) {
    contr.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: loc,
      zoom: 20.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false).locationData!;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('rides')
              .doc(widget.requestId)
              .snapshots(),
          builder: (context, snapshot) {
            if (_controller != null &&
                snapshot.hasData &&
                snapshot.data!['rider'] != null) {
              animateCamera(
                  _controller!,
                  LatLng(snapshot.data!['rider']['currentLocation'].latitude,
                      snapshot.data!['rider']['currentLocation'].longitude));
            }
            return Stack(
              children: [
                if (!snapshot.hasData || snapshot.data!['rider'] == null)
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    zoomControlsEnabled: false,
                    markers: _markers,
                    polylines: _polylines.values.toSet(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(locationProvider.latitude!,
                          locationProvider.longitude!),
                      zoom: 22,
                    ),
                  ),
                if (snapshot.hasData && snapshot.data!['rider'] != null)
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    zoomControlsEnabled: false,
                    markers: {
                      Marker(
                        markerId: const MarkerId('driver'),
                        onTap: () {},
                        //circle to show the mechanic profile in map
                        icon: icon1,
                        position: LatLng(
                            snapshot.data!['rider']['currentLocation'].latitude,
                            snapshot
                                .data!['rider']['currentLocation'].longitude),
                      ),
                      if (snapshot.data!['status'] == 'accepted' &&
                          snapshot.data!['status'] == 'arrived')
                        Marker(
                          markerId: const MarkerId('customer'),
                          onTap: () {},
                          icon: icon2,
                          position: LatLng(locationProvider.latitude!,
                              locationProvider.longitude!),
                        ),
                    },
                    polylines: _polylines.values.toSet(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(locationProvider.latitude!,
                          locationProvider.longitude!),
                      zoom: 22,
                    ),
                  ),
                if (!snapshot.hasData || snapshot.data!['rider'] == null)
                  Center(
                    child: AnimatedOpacity(
                      opacity:
                          !snapshot.hasData || snapshot.data!['rider'] == null
                              ? 1
                              : 0,
                      duration: const Duration(milliseconds: 2500),
                      child: Lottie.asset(
                        'assets/blink.json',
                      ),
                    ),
                  ),
                if (snapshot.hasData &&
                    RequestModel.fromJson(snapshot.data!.data()!).rider != null)
                  AnimatedPositioned(
                    bottom: snapshot.hasData &&
                            RequestModel.fromJson(snapshot.data!.data()!)
                                    .rider !=
                                null
                        ? 0
                        : -300,
                    left: 0,
                    right: 0,
                    duration: const Duration(milliseconds: 500),
                    child: DriverSlidingPanel(
                      request: RequestModel.fromJson(snapshot.data!.data()!),
                    ),
                  ),
                if (snapshot.hasData && snapshot.data!['status'] == 'failed')
                  const PopContainer(),
                if (snapshot.hasData && snapshot.data!['status'] == 'paid')
                  ReviewScreen(
                    rideId: widget.requestId,
                  ),
                if (snapshot.hasData && snapshot.data!['status'] == 'reviewed')
                  const PopContainer(),
                if (snapshot.hasData && snapshot.data!['status'] == 'cancelled')
                  Positioned(bottom: 0, child: CancelledRideWidget())
              ],
            );
          }),
    );
  }
}

class PopContainer extends StatefulWidget {
  const PopContainer({super.key});

  @override
  State<PopContainer> createState() => _PopContainerState();
}

class _PopContainerState extends State<PopContainer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      Get.offAll(() => const InitialLoadingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
