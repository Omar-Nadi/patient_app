import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:patient_app/Module/AppBar.dart';
import 'package:patient_app/Provider/doctorProfileProvider.dart';
import 'package:provider/provider.dart';

class DoctorProfile extends StatefulWidget {
  final int id;
  DoctorProfile({required this.id});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  bool isLoading = true;
  final doctorNameController = TextEditingController();
  final doctorSpecailityController = TextEditingController();
  final doctorPhoneController = TextEditingController();
  late int doctorRating;
  late int doctorExperince;
  String? imageUrl;
  bool isSelected = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<void> fetchData() async {
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.id.toString())
        .get()
        .then((ds) => {
              doctorNameController.text = ds.data()!['doctorname'],
              doctorRating = ds.data()!['rating'],
              doctorExperince = ds.data()!['experience'],
              doctorSpecailityController.text = ds.data()!['specialty'],
              doctorPhoneController.text = ds.data()!['phoneNumber'].toString(),
              setState(() {
                imageUrl = ds.data()!['imageUrl'];
              }),
              isLoading = false,
            });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    Icon iconDoc = Provider.of<DoctorDetailsProvider>(context, listen: false)
        .iconOfSpeciality(doctorSpecailityController.text);
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: const MainAppBar(
          title: 'Doctor Profile',
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Material(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.7),
                                Colors.blue.withOpacity(0),
                                Colors.blue.withOpacity(0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Experience",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '$doctorExperince Years',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rating",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '$doctorRating of 5',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorNameController.text,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(iconDoc.icon),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                doctorSpecailityController.text,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            doctorPhoneController.text,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(140, 50),
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () async {
                        _datepicker();
                      },
                      child: Text(DateFormat.yMMMd().format(_selectedDate)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(140, 50),
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () async {
                        _timePicker();
                      },
                      child: Text(_period(_selectedTime)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(250, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        Provider.of<DoctorDetailsProvider>(context,
                                listen: false)
                            .addAppointmentPaitent(
                          doctorNameController.text,
                          DateFormat.yMd().format(_selectedDate),
                          _period(_selectedTime).toString(),
                        );
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Appointment booked successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: const Text('Book'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void _datepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2024))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  void _timePicker() async {
    TimeOfDay? newTime =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (newTime == null) return;
    setState(() {
      _selectedTime = newTime;
    });
  }

  String _period(TimeOfDay time) {
    int hour = time.hour, minute = time.minute;
    String period = 'AM';
    if (time.hour >= 12) {
      hour = time.hour - 12;
      period = 'PM';
    }
    return ('$hour:$minute $period');
  }
}
