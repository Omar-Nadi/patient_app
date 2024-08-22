import 'package:flutter/cupertino.dart';
import 'dart:convert';

class DoctorProfileModule {
  final int doctorId;
  final int rating;
  final String doctorName;
  final int phoneNumber;
  final String speciality;
  final String imageUrl;
  final int experience;

  DoctorProfileModule(
      {required this.doctorId,
      required this.rating,
      required this.experience,
      required this.doctorName,
      required this.phoneNumber,
      required this.speciality,
      required this.imageUrl});
}
