import 'dart:async';

import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/screens/home/confirm_map_screen.dart';
import 'package:darboda/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map_picker/map_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class ChooseMapLocation extends StatefulWidget {
  const ChooseMapLocation({Key? key}) : super(key: key);

  @override
  _ChooseMapLocationState createState() => _ChooseMapLocationState();
}

class _ChooseMapLocationState extends State<ChooseMapLocation> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 16,
  );

  var textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraPosition = CameraPosition(
      target: LatLng(
          Provider.of<LocationProvider>(context, listen: false)
              .locationData!
              .latitude!,
          Provider.of<LocationProvider>(context, listen: false)
              .locationData!
              .longitude!),
      zoom: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: Image.asset(
              "assets/images/pin.png",
              height: 60,
            ),
            //add map picker controller
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              // hide location button
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              //  camera position
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () {
                // notify map is moving
                mapPickerController.mapMoving!();
                textController.text = "checking ...";
              },
              onCameraMove: (cameraPosition) {
                this.cameraPosition = cameraPosition;
              },
              onCameraIdle: () async {
                // notify map stopped moving
                mapPickerController.mapFinishedMoving!();
                //get address name from camera position
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition.target.latitude,
                  cameraPosition.target.longitude,
                );

                // update the ui with the address
                textController.text =
                    '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
              },
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const Text(
                    'Choose pickup point',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          readOnly: true,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              border: InputBorder.none),
                          controller: textController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                    text: 'Confirm Location',
                    onTap: () {
                      Get.to(
                        () => ConfirmMapScreen(
                          location: LatLng(cameraPosition.target.latitude,
                              cameraPosition.target.longitude),
                          address: textController.text,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
