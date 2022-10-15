import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? phoneNumber;
  String? userId;
  final bool? isBlocked;
  final String? name;
  Timestamp? createdAt = Timestamp.now();
  final String? profilePic;
  final bool isDriver;
  final String rideId;

  UserModel(
      {this.phoneNumber,
      this.isBlocked = false,
      this.userId,
      this.profilePic =
          'https://www.nicepng.com/png/detail/933-9332131_profile-picture-default-png.png',
      this.name,
      this.rideId = '',
      this.isDriver = false,
      this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'isBlocked': isBlocked,
      'name': name,
      'isDriver': isDriver,
      'rideId': rideId,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      phoneNumber: json['phoneNumber'],
      isBlocked: json['isBlocked'],
      name: json['name'],
      isDriver: json['isDriver'],
      rideId: json['rideId'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      profilePic: json['profilePic'],
    );
  }
}
