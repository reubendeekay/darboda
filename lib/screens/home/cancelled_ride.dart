import 'package:darboda/loading_screen.dart';
import 'package:darboda/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

class CancelledRideWidget extends StatelessWidget {
  const CancelledRideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Lottie.asset('assets/cancelled.json', repeat: false),
            ),
            const Text(
              'Ride Cancelled',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              ('The current ride has been cancelled.\n Please try again later'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 30,
            ),
            PrimaryButton(
                text: 'Okay',
                onTap: () {
                  Navigator.of(context).pop();
                  Get.offAll(() => const InitialLoadingScreen());
                })
          ],
        ),
      ),
    );
  }
}
