import 'package:cached_network_image/cached_network_image.dart';
import 'package:darboda/constants.dart';
import 'package:darboda/helpers/distance_helper.dart';
import 'package:darboda/models/request_model.dart';
import 'package:darboda/screens/chat/chat_room.dart';
import 'package:darboda/screens/history/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideDetailsScreen extends StatefulWidget {
  const RideDetailsScreen({super.key, required this.request});
  final RequestModel request;

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
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

    var coordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(widget.request.pickupLocation!.latitude,
            widget.request.pickupLocation!.longitude),
        destination: LatLng(widget.request.destinationLocation!.latitude,
            widget.request.destinationLocation!.longitude),
        mode: RouteMode.driving);
    _addPolyline(coordinates!);

    setState(() {});
//Get center of the route
    final bounds = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(widget.request.pickupLocation!.latitude,
            widget.request.pickupLocation!.longitude),
        destination: LatLng(widget.request.destinationLocation!.latitude,
            widget.request.destinationLocation!.longitude),
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
      appBar: AppBar(
        title: const Text('Ride Details'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Trip Completed',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      'TZS ${moneyFormat(widget.request.amount!.toString())}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Today, 12:00 PM',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
              height: 200.h,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                polylines: _polylines.values.toSet(),
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.request.pickupLocation!.latitude,
                        widget.request.pickupLocation!.longitude),
                    zoom: 15),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Stack(
                        children: [
                          Container(
                            height: 35.h,
                            width: 4,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [kPrimaryColor, Colors.green],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            margin: const EdgeInsets.only(left: 10, top: 15),
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.play_circle_fill_outlined,
                                color: kPrimaryColor,
                              ),
                              SizedBox(
                                height: 20.h,
                                width: 2,
                              ),
                              const Icon(
                                Icons.stop_circle,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.request.pickupAddress!,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          widget.request.pickupAddress!,
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.request.rider!.profilePic!),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.request.rider!.name!),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2.5),
                                  decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        color: Colors.green,
                                        size: 12,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        '4.5',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(widget.request.rider!.vehicleModel!),
                              const SizedBox(
                                height: 3,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2.5),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(3)),
                                child: Text(
                                  widget.request.rider!.vehicleNumber!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 40.h,
                            child: TextButton.icon(
                                onPressed: () async {
                                  bool? res =
                                      await FlutterPhoneDirectCaller.callNumber(
                                          widget.request.rider!.phoneNumber!);

                                  if (res == false) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Oops could not make phone call'),
                                    ));
                                  }
                                },
                                icon: const Icon(
                                  Iconsax.call5,
                                  size: 20,
                                ),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey[300],
                                    shadowColor: Colors.grey[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                label: Text(
                                  ' Support',
                                  style: GoogleFonts.ibmPlexSans(
                                      fontWeight: FontWeight.w500),
                                )),
                          )),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: SizedBox(
                            height: 40.h,
                            child: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      ChatRoom.routeName,
                                      arguments: {
                                        'user': widget.request.rider,
                                        'chatRoomId': widget.request.id
                                      });
                                },
                                icon: const Icon(
                                  Iconsax.message5,
                                  size: 20,
                                ),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.green,
                                    backgroundColor: Colors.green[100],
                                    shadowColor: Colors.grey[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                label: Text(
                                  ' Contact',
                                  style: GoogleFonts.ibmPlexSans(
                                      fontWeight: FontWeight.w500),
                                )),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  children: const [
                    Text(
                      'Payment method',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacer(),
                    Text('Cash'),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    const Text(
                      'Completed on',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(DateFormat('dd MMM, yyyy')
                        .format(widget.request.timestamp!.toDate())),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45.h,
                  width: double.infinity,
                  child: TextButton.icon(
                      onPressed: () {
                        Get.to(() => InvoiceScreen(
                              request: widget.request,
                            ));
                      },
                      icon: const Icon(
                        Iconsax.document5,
                        size: 20,
                      ),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                          shadowColor: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      label: Text(
                        'Receipt',
                        style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.w500),
                      )),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
