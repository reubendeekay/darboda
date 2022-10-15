import 'dart:math' as math;
import 'package:darboda/constants.dart';

import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/screens/home/widgets/home_sliding_sheet.dart';
import 'package:darboda/screens/settings/settings_overview.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = <Marker>{};

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller!.setMapStyle(value);
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
      setState(() {});
    }
    setState(() {});
  }

  bool isDelivery = false;

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false).locationData!;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _markers,
            buildingsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  locationProvider.latitude!, locationProvider.longitude!),
              zoom: 16,
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            top: kToolbarHeight + 10,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => const SettingsOverview());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/logo.png',
                  height: 30,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: HomepageDialog(
                                  isDelivery: isDelivery,
                                  onChanged: (val) {
                                    setState(() {
                                      isDelivery = val;
                                    });
                                  }),
                            ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(isDelivery ? Iconsax.box : Iconsax.user),
                  ),
                ),
              ],
            ),
          ),
          HomeSlidingPanel(
              isDelivery: isDelivery,
              onChanged: (val) {
                setState(() {
                  isDelivery = val;
                });
              }),
        ],
      ),
    );
  }
}

class HomepageDialog extends StatefulWidget {
  final bool isDelivery;
  final Function(bool isDel) onChanged;

  const HomepageDialog(
      {super.key, required this.isDelivery, required this.onChanged});

  @override
  State<HomepageDialog> createState() => _HomepageDialogState();
}

class _HomepageDialogState extends State<HomepageDialog> {
  late int selectedType;
  @override
  void initState() {
    super.initState();
    selectedType = widget.isDelivery ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Choose Ride Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    selectedType == 0
                        ? Icons.play_circle
                        : Icons.circle_outlined,
                    color: selectedType == 0 ? kPrimaryColor : Colors.grey,
                  ),
                  title: const Text('Book Ride'),
                  onTap: () {
                    setState(() {
                      selectedType = 0;
                      widget.onChanged(false);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    selectedType == 1
                        ? Icons.play_circle
                        : Icons.circle_outlined,
                    color: selectedType == 1 ? kPrimaryColor : Colors.grey,
                  ),
                  title: const Text('Package Delivery'),
                  onTap: () {
                    setState(() {
                      selectedType = 1;
                      widget.onChanged(true);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'))),
              ],
            )));
  }
}
