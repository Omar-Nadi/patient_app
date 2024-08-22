import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final int doctorId;
  final String doctorName;
  final int doctorPhoneNumber;
  final String doctorSpeciality;
  final String imageUrl;

  const DoctorCard({
    required this.doctorId, 
    required this.doctorName,
    required this.doctorPhoneNumber,
    required this.doctorSpeciality, 
    required this.imageUrl, 
    }
    );
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}