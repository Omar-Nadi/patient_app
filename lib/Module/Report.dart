import 'package:flutter/material.dart';

class Report {
  String id;
  String name;
  String date;
  String number;
  String logoURL;
  List results;
  Report({
    required this.id,
    required this.name,
    required this.date,
    required this.number,
    required this.logoURL,
    required this.results,
  });
}