import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:patient_app/Provider/doctorProfileProvider.dart';
import 'package:provider/provider.dart';

import 'package:patient_app/UI/previous_appointments.dart';

import '../Module/appointmrntsDetailsModule.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  bool _isLoading = true;
  DateTime dateNow = DateTime.now();
  @override
  void initState() {
    Provider.of<DoctorDetailsProvider>(context, listen: false)
        .fetchData()
        .then((_) => _isLoading = false)
        .catchError((onError) => print(onError));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<appointmentsDetails> appointmentsList =
        Provider.of<DoctorDetailsProvider>(context, listen: true)
            .appointmentsList;

    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<DoctorDetailsProvider>(context, listen: false)
              .RefreshScreen(),
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.schedule,
                                size: 25,
                              ),
                              Text(
                                'Scheduled Appointments',
                                style: TextStyle(fontSize: 25),
                              )
                            ],
                          ),
                        )),
                      ),
                      appointmentsList.isEmpty
                          ? const SizedBox(
                              width: double.infinity,
                              child: Card(
                                  child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Text(
                                  'No appointments booked!!',
                                  style: TextStyle(fontSize: 25),
                                ),
                              )),
                            )
                          : Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: ListView(children: [
                                    ...appointmentsList.map((e) {
                                      return ReportAppointment(
                                          e.doctorName, e.date, e.time);
                                    }),
                                  ]),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider<
                                          DoctorDetailsProvider>(
                                        create: (context) =>
                                            DoctorDetailsProvider(),
                                        child: const PreivousAppointments(),
                                      ))),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 120,
                                    color: Colors.blueGrey,
                                  ),
                                  Text('Previous Appointments',
                                      style: TextStyle(fontSize: 25)),
                                  Text('View Previous Appointments',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
      ),
    );
  }

  Widget ReportAppointment(String doctorName, String date, String time) {
    return Container(
      width: 130,
      height: 130,
      child: SizedBox(
        width: double.infinity,
        child: Card(
            child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dr Name:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Date :', style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Hour :", style: TextStyle(fontSize: 20)),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(date, style: const TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(time, style: const TextStyle(fontSize: 20)),
                  ]),
            ),
          ],
        )),
      ),
    );
  }
}
