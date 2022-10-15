// ignore_for_file: use_build_context_synchronously

import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/screens/home/homepage.dart';
import 'package:darboda/screens/home/searching_map.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  String loadingText = 'Loading...';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation();
      setState(() {
        loadingText = 'Getting user details...';
      });
      await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();

      final user = Provider.of<AuthProvider>(context, listen: false).user!;

      if (user.rideId.isEmpty) {
        setState(() {
          loadingText = 'Getting nearby riders...';
        });
        await Provider.of<LocationProvider>(context, listen: false)
            .getNearbyDrivers();
        Get.off(() => const Homepage());
      } else {
        Get.off(() => SearchingMap(
              requestId: user.rideId,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Lottie.asset('assets/rider.json'),
        const Spacer(),
        Text(
          loadingText,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    ));
  }
}
