import 'package:flutter/cupertino.dart';
import 'dart:convert';

class appointmentsDetails {
  final String id;
  final String doctorName;
  late final String date;
  final String time;

  appointmentsDetails({
    required this.id,
    required this.doctorName,
    required this.date,
    required this.time,
  });
}
