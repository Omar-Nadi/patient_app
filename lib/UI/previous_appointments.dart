import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:patient_app/Module/AppBar.dart';

import '../Module/appointmrntsDetailsModule.dart';
import '../Provider/doctorProfileProvider.dart';

class PreivousAppointments extends StatefulWidget {
  const PreivousAppointments({super.key});

  @override
  State<PreivousAppointments> createState() => _PreivousAppointmentsState();
}

class _PreivousAppointmentsState extends State<PreivousAppointments> {
  bool _isLoading = true;

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
        appBar: const MainAppBar(title: 'Preivous Appointments'),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : appointmentsList.isEmpty
                ? const Center(
                    child: Text('No preivous appointments for now'),
                  )
                : Center(
                    child: ListView.builder(
                      itemCount: appointmentsList.length,
                      itemBuilder: (context, index) {
                        var item = appointmentsList[index];

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (c) {
                                  context
                                      .read<DoctorDetailsProvider>()
                                      .delete(item.id)
                                      .then((value) =>
                                          appointmentsList.removeAt(index));
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                label: 'Delete',
                                spacing: 8,
                              )
                            ],
                          ),
                          child: Container(
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                  child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Dr Name:',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('Date :',
                                              style: TextStyle(fontSize: 20)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Hour :",
                                              style: TextStyle(fontSize: 20)),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.doctorName,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(item.date,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(item.time,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                        ]),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
