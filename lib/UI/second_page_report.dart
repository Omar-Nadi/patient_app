import 'package:flutter/material.dart';
import 'package:patient_app/Provider/Report.dart';
import 'package:patient_app/UI/report_download_page.dart';
import 'package:provider/provider.dart';

import '../Module/AppBar.dart';

class ReportSecondPage extends StatelessWidget {
  late List results;
  ReportSecondPage(this.results);
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    //  List results =
    //     Provider.of<ReportProvider>(context,listen: true).SelectedResults;
    return Scaffold(
      appBar: const MainAppBar(
        title: 'Detail of Reports',
      ),
      body: SafeArea(
          child:Container(
        width: screenWidth,
        height: screenheight,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(2, 5), // Shadow position
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
                padding: const EdgeInsets.all(11),
                height: screenheight * 0.15,
                width: screenWidth,
                color: const Color.fromARGB(255, 239, 239, 239),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "My Labatory Results",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 79, 79, 79)),
                          ),
                          Text(
                            "Displaying Up to 15 Records",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 165, 35, 26),
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          )
                        ]),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert))
                  ],
                )),
           ...results.map(((e) {
              return ResultsBox(screenheight, screenWidth, context, e["name"],
                  e["date"], e["imageUrl"], e["time"]);
            }))
          ]),
        ),
      )),
    );
  }

  Column ResultsBox(
     double screenheight,
    double screenWidth,
    BuildContext context,
    String name,
    String date,
    String imageUrl,
    String time,
  ) {
    final DMY = date.split(' ');
    return Column(
      children: [
        SizedBox(
          width: screenWidth,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 167, 167, 167),
                      offset: Offset(1, 0),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]),
              width: screenWidth * 0.1,
              height: screenheight * 0.25,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      DMY[0],
                      style: const TextStyle(
                          height: 1.2,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DMY[1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          height: 1.2,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 128, 128, 128)),
                    ),
                    Text(
                      DMY[2],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          height: 1.2,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 128, 128, 128)),
                    )
                  ]),
            ),
            SizedBox(
              width: screenWidth * 0.29,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 128, 128, 128)),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        height: 1.6,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenWidth * 0.41,
              height: screenheight * 0.064,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 17, 93, 155)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DownloadPage(imageUrl)),
                    );
                  },
                  child: const Text(
                    "View Restults",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )),
            )
          ]),
        ),
        const Divider(color: Colors.grey, indent: 20, endIndent: 20)
      ],
    );
  }
}
