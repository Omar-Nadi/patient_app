import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/Provider/Report.dart';

import 'package:patient_app/UI/second_page_report.dart';
import 'package:provider/provider.dart';

class FirstPageInReport extends StatefulWidget {
  @override
  State<FirstPageInReport> createState() => _FirstPageInReportState();
}

class _FirstPageInReportState extends State<FirstPageInReport> {
  int currentPage = 0;
  String userName = '';
  bool _isLoading = true;
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  fetchData() {
    Provider.of<ReportProvider>(context, listen: false)
        .getDataBaseCarouselData();
    Provider.of<ReportProvider>(context, listen: false)
        .getDataBaseReportsData();

    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then(
          (ds) => {
            userName =
                ds.data()!['first name'] + '  ' + ds.data()!['last name'],
            setState(() {
              _isLoading = false;
            }),
          },
        );
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () =>
                    Provider.of<ReportProvider>(context, listen: false)
                        .RefreshScreen(),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text("Here's What's Happening Today.",
                                      style: TextStyle(
                                        fontSize: 22,
                                      )),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Stack(
                                    children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                currentPage = index;
                                              });
                                            },
                                            enlargeCenterPage: true,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18),
                                        items: Provider.of<ReportProvider>(
                                                context,
                                                listen: true)
                                            .carouselItems
                                            .map((i) {
                                          return Container(
                                              alignment: Alignment.bottomLeft,
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        i.imageUrl)),
                                              ),
                                              child: Container(
                                                width: screenWidth * 0.5,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      i.title.toUpperCase(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      i.description,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            screenWidth * 0.25,
                                                        height:
                                                            screenheight * 0.02,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              shadowColor:
                                                                  Colors.grey,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20))),
                                                          onPressed: (() {}),
                                                          child: const Text(
                                                            "Find out more",
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ));
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: DotsIndicator(
                                      dotsCount: Provider.of<ReportProvider>(
                                                      context,
                                                      listen: false)
                                                  .carouselItems
                                                  .length ==
                                              0.0
                                          ? 2
                                          : Provider.of<ReportProvider>(context,
                                                  listen: false)
                                              .carouselItems
                                              .length,
                                      position: currentPage.toDouble(),
                                      decorator: const DotsDecorator(
                                        color: Color.fromARGB(221, 219, 219,
                                            219), // Inactive color
                                        activeColor:
                                            Color.fromARGB(255, 82, 160, 255),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      ...Provider.of<ReportProvider>(context,
                                              listen: true)
                                          .reports
                                          .map(
                                        (e) {
                                          return ReportBoxes(
                                              screenWidth,
                                              screenheight,
                                              e.name,
                                              e.date,
                                              e.number,
                                              e.logoURL,
                                              Provider.of<ReportProvider>(
                                                      context,
                                                      listen: true)
                                                  .reports
                                                  .indexOf(e),
                                              e.results);
                                        },
                                      )
                                    ],
                                  )
                                ]),
                          )
                        ]),
                  ),
                ),
              ),
            ),
    );
  }

  Container ReportBoxes(double screenWidth, double screenheight, String name,
      String date, String number, String logoURL, int index, List results) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 215, 215, 215), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      width: screenWidth,
      height: screenheight * 0.28,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(name.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 111, 111, 111),
                      )),
                ),
                Text(date,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            Text(
              number,
              style: const TextStyle(
                  fontSize: 33,
                  color: Color.fromARGB(255, 68, 68, 68),
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.4,
                  height: screenheight * 0.06,
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<ReportProvider>(context, listen: false)
                            .UpdateSelectedReport(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportSecondPage(results),
                          ),
                        );
                      },
                      child: const Text(
                        "View Restults",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                ),
                Container(
                    width: screenWidth * 0.13,
                    height: screenheight * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(logoURL))))
              ],
            )
          ]),
    );
  }
}
