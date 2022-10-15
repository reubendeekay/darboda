import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RiderModel {
  final String? userId;
  final String? phoneNumber;
  final String? name;
  final String? profilePic;
  final String? vehicleNumber;
  final String? rideId;
  final String? email;
  final GeoPoint? currentLocation;

  bool isOnline;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? nationalId;
  List<dynamic>? documents;

  RiderModel(
      {this.userId,
      this.phoneNumber,
      this.name,
      this.profilePic,
      this.isOnline = false,
      this.vehicleNumber,
      this.email,
      this.rideId = '',
      this.vehicleModel,
      this.currentLocation,
      this.vehicleColor,
      this.nationalId,
      this.documents});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId ?? FirebaseAuth.instance.currentUser!.uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'isOnline': isOnline,
      'profilePic': profilePic,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'email': email,
      'vehicleColor': vehicleColor,
      'nationalId': nationalId,
      'documents': documents,
      'rideId': rideId,
      'currentLocation': currentLocation,
    };
  }

  factory RiderModel.fromJson(dynamic json) {
    return RiderModel(
      userId: json['userId'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      email: json['email'],
      profilePic: json['profilePic'],
      vehicleNumber: json['vehicleNumber'],
      vehicleModel: json['vehicleModel'],
      isOnline: json['isOnline'],
      vehicleColor: json['vehicleColor'],
      nationalId: json['nationalId'],
      documents: json['documents'],
      rideId: json['rideId'],
      currentLocation: json['currentLocation'],
    );
  }
}
