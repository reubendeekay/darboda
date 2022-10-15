import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/loading_screen.dart';
import 'package:darboda/providers/request_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rating/rating.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.rideId});
  final String rideId;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final ratingModel = RatingModel(
        id: 1,
        title: 'Rate your ride',
        subtitle: 'How was your ride:',
        ratingConfig: RatingConfigModel(
          id: 1,
          ratingSurvey1: 'Em que podemos melhorar?',
          ratingSurvey2: 'Em que podemos melhorar?',
          ratingSurvey3: 'Em que podemos melhorar?',
          ratingSurvey4: 'Em que podemos melhorar?',
          ratingSurvey5: 'More details',
          items: [
            RatingCriterionModel(id: 1, name: 'Quality and amazing'),
            RatingCriterionModel(id: 2, name: 'Friendly and helpful'),
            RatingCriterionModel(id: 3, name: 'Timely and efficient'),
            RatingCriterionModel(id: 4, name: 'Do not recommend'),
          ],
        ),
      );
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) => RatingWidget(
            controller: PrintRatingController(ratingModel, widget.rideId,
                () => Get.to(() => const InitialLoadingScreen()))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PrintRatingController extends RatingController {
  PrintRatingController(RatingModel ratingModel, this.rideId, this.onPop)
      : super(ratingModel);
  final String rideId;
  final Function onPop;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<void> ignoreForEverCallback() async {
    await FirebaseFirestore.instance.collection('rides').doc(rideId).update({
      'status': 'reviewed',
    });
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'rideId': '',
    });
    onPop();
    Get.back();
  }

  @override
  Future<void> saveRatingCallback(
      int rate, List<RatingCriterionModel> selectedCriterions) async {
    await FirebaseFirestore.instance.collection('rides').doc(rideId).update({
      'status': 'reviewed',
    });

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'rideId': '',
    });
    onPop();

    Get.back();
  }
}
