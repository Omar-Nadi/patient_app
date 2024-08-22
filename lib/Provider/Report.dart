import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Module/CarouselItem.dart';
import '../Module/Report.dart';
import '../Module/Result.dart';

class ReportProvider with ChangeNotifier {
  late List SelectedResults;
  List<CarouselItem> carouselItems = [];
  List<Report> reports = [];
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  void UpdateSelectedReport(int index) {
    SelectedResults = reports[index].results;
    notifyListeners();
  }

  Future<void> RefreshScreen() async {
    getDataBaseReportsData();
    getDataBaseCarouselData();
    notifyListeners();
  }

  void getDataBaseCarouselData() async {
    final data = await _firestore.collection("Carousels").get();
    carouselItems = [];
    for (var item in data.docs) {
      carouselItems.add(CarouselItem(
          title: item.data()["title"],
          description: item.data()["description"],
          imageUrl: item.data()["imageUrl"],
          id: item.id));
    }
    notifyListeners();
  }

  Future<void> getDataBaseReportsData() async {
    final data = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("Reports")
        .get();
    reports = [];
    for (var item in data.docs) {
      reports.add(Report(
          name: item.data()["name"],
          date: item.data()["date"],
          number: item.data()["number"],
          logoURL: item.data()["logoURL"],
          results: item.data()["results"],
          id: item.id));
    }
    notifyListeners();
  }

  Future<void> addNewReportFireStore() async {
    _firestore.collection("users").doc(user.uid).collection("Reports").add({
      "name": "Forward View Labs",
      "date": "2nd May 22",
      "number": "06",
      "logoURL":
          "https://c8.alamy.com/comp/2AWAWRM/flask-sign-lab-logo-science-chemical-research-template-vector-design-2AWAWRM.jpg",
      "results": [
        result1.toJson(),
        result2.toJson(),
        result3.toJson(),
        result4.toJson(),
      ]
    });
  }

  Future<void> addNewCarouselsFireStore() async {
    _firestore.collection("Carousels").add({
      "title": "Lorem Ipsum",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      "imageUrl":
          "https://images.sampleforms.com/wp-content/uploads/2019/01/Medical-Report-Form-Sample.jpg",
    });
  }
}
