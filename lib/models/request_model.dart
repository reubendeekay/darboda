import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/models/driver_model.dart';
import 'package:darboda/models/user_model.dart';

class RequestModel {
  String? id;
  final String? destinationAddress;
  final UserModel? user;
  final RiderModel? rider;
  final String? status;
  final String? riderId;
  final String? amount;
  final GeoPoint? destinationLocation;
  final GeoPoint? pickupLocation;
  final String? pickupAddress;
  final GeoPoint? riverLocation;
  final Timestamp? timestamp;
  final String? paymentMethod;

  RequestModel(
      {this.id,
      this.destinationAddress,
      this.user,
      this.rider,
      this.status,
      this.riderId,
      this.amount,
      this.destinationLocation,
      this.pickupLocation,
      this.pickupAddress,
      this.riverLocation,
      this.timestamp,
      this.paymentMethod});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destinationAddress': destinationAddress ?? 'Destination Address',
      'user': user!.toJson(),
      'rider': rider,
      'status': status,
      'riderId': riderId,
      'amount': amount,
      'destinationLocation': destinationLocation,
      'pickupLocation': pickupLocation,
      'pickupAddress': pickupAddress,
      'riverLocation': riverLocation,
      'timestamp': timestamp,
      'paymentMethod': paymentMethod,
      'pickupTime': Timestamp.now(),
      'dropOffTime': Timestamp.now(),
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      destinationAddress: json['destinationAddress'],
      user: UserModel.fromJson(json['user']),
      rider: json['rider'] == null ? null : RiderModel.fromJson(json['rider']),
      status: json['status'],
      riderId: json['riderId'],
      amount: json['amount'],
      destinationLocation: json['destinationLocation'],
      pickupLocation: json['pickupLocation'],
      pickupAddress: json['pickupAddress'],
      riverLocation: json['riverLocation'],
      timestamp: json['timestamp'],
      paymentMethod: json['paymentMethod'],
    );
  }
}
