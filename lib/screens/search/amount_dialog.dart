import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/helpers/distance_helper.dart';
import 'package:darboda/models/request_model.dart';
import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/providers/request_provider.dart';
import 'package:darboda/screens/home/searching_map.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AmountDialog extends StatefulWidget {
  const AmountDialog({Key? key, required this.location, required this.address})
      : super(key: key);
  final LatLng location;
  final String address;

  @override
  State<AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<AmountDialog> {
  @override
  Widget build(BuildContext context) {
    final userLocation =
        Provider.of<LocationProvider>(context, listen: false).userLocation!;
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    String getAmount() {
      final LatLng latLng =
          LatLng(widget.location.latitude, widget.location.longitude);

      final distance = calculateDistance(latLng.latitude, latLng.longitude,
          userLocation.location!.latitude, userLocation.location!.longitude);

      return (distance * 600).floor().toStringAsFixed(2);
    }

    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Pricing',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const Text(
                  'Please select your ride type',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ListTile(
                  leading: const Icon(Iconsax.box),
                  title: const Text('Parcel delivery'),
                  trailing: Text('TZS ${moneyFormat(getAmount())}'),
                  onTap: () async {
                    final requestModel = RequestModel(
                      amount: getAmount(),
                      destinationAddress: widget.address,
                      pickupAddress: userLocation.address,
                      destinationLocation: GeoPoint(
                          widget.location.latitude, widget.location.longitude),
                      pickupLocation: GeoPoint(userLocation.location!.latitude,
                          userLocation.location!.longitude),
                      paymentMethod: 'Cash',
                      status: 'pending',
                      timestamp: Timestamp.now(),
                      user: user,
                    );
                    final id = await Provider.of<RequestProvider>(context,
                            listen: false)
                        .bookRide(requestModel);

                    Get.to(() => SearchingMap(requestId: id));
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.user),
                  title: const Text('Customer Ride'),
                  trailing: Text(
                      'TZS ${moneyFormat((double.parse(getAmount()) + 200.00).toStringAsFixed(2))}'),
                  onTap: () async {
                    final requestModel = RequestModel(
                      amount: getAmount(),
                      destinationAddress: widget.address,
                      pickupAddress: userLocation.address,
                      destinationLocation: GeoPoint(
                          widget.location.latitude, widget.location.longitude),
                      pickupLocation: GeoPoint(userLocation.location!.latitude,
                          userLocation.location!.longitude),
                      paymentMethod: 'Cash',
                      status: 'pending',
                      timestamp: Timestamp.now(),
                      user: user,
                    );
                    final id = await Provider.of<RequestProvider>(context,
                            listen: false)
                        .bookRide(requestModel);

                    Get.to(() => SearchingMap(requestId: id));
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
