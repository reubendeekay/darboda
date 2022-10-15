import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  Future<void> signUp(UserModel userModel) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    userModel.userId = uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toJson());
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      _user = UserModel.fromJson(value);
    });
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'pushToken': token});
    });
    notifyListeners();
  }
}
