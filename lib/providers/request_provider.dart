import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/models/request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RequestProvider with ChangeNotifier {
  final ref = FirebaseFirestore.instance.collection('rides');

  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future<String> bookRide(RequestModel request) async {
    final id = ref.doc().id;
    request.id = id;

    await ref.doc(id).set(request.toJson());

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'rideId': id,
    });

    notifyListeners();
    return id;
  }

  Future<RequestModel> getRequestedRide(String id) async {
    final doc = await ref.doc(id).get();
    return RequestModel.fromJson(doc.data()!);
  }

  Future<void> reviewDriver(String rideId) async {
    await ref.doc(rideId).update({
      'status': 'reviewed',
    });
    notifyListeners();
  }

  Future<void> cancelRide(RequestModel request) async {
    await ref.doc(request.id).update({
      'status': 'cancelled',
    });
    await FirebaseFirestore.instance
        .collection('riders')
        .doc(request.rider!.userId)
        .update({'rideId': ''});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(request.user!.userId)
        .update({'rideId': ''});
    notifyListeners();
  }
}
