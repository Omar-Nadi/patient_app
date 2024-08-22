import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/Module/doctor_profileModule.dart';
import 'package:patient_app/Provider/Report.dart';
import 'package:patient_app/Provider/doctorProfileProvider.dart';
import 'package:patient_app/UI/doctorProfile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:settings_ui/settings_ui.dart';

import '../Module/cardviewlist.dart';

class Physicainas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }
}

class _MyHomePage extends State<Physicainas> {
  final ScrollController _firstController = ScrollController();
  final doctorTextController = TextEditingController();
  final specialtTextController = TextEditingController();
  bool showGrid = false;
  bool isLoading = true;
  Color color = Colors.blue;
  List<DoctorProfileModule> foundUsers = [];

  @override
  void initState() {
    Provider.of<DoctorDetailsProvider>(context, listen: false)
        .getDataBaseDoctorsData()
        .then((value) => isLoading = false);
    super.initState();
  }

  void list2() {
    if (foundUsers.isEmpty) {
      foundUsers =
          Provider.of<DoctorDetailsProvider>(context, listen: true).doctorList;
    }
  }

  @override
  Widget build(BuildContext context) {
    list2();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
          body: SingleChildScrollView(
        controller: _firstController,
        child: Column(
          children: [
            searchCard(),
            showGrid ? doctorGridView() : doctorListView(),
          ],
        ),
      ));
    }
  }

  void updateListByName(String value) {
    //for doctor search by name
    setState(() {
      foundUsers = Provider.of<DoctorDetailsProvider>(context, listen: false)
          .doctorList
          .where((element) =>
              element.doctorName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void updateListBySpicalisty(String value) {
    //for doctor search by spicalisty
    setState(() {
      foundUsers = Provider.of<DoctorDetailsProvider>(context, listen: false)
          .doctorList
          .where((element) =>
              element.speciality.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Widget buttonForView(bool showScreen, Icon icon, Color color) {
    //button style function
    return ElevatedButton(
        style: OutlinedButton.styleFrom(backgroundColor: color),
        onPressed: () {
          setState(() {
            showGrid = showScreen;
          });
        },
        child: icon);
  }

  Widget doctorListView() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foundUsers.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                    width: 1, color: const Color.fromARGB(255, 215, 215, 215))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(20)),
                    Container(
                      width: width * 0.2,
                      height: height * 0.2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(foundUsers[index].imageUrl),
                            fit: BoxFit.scaleDown,
                          )),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          foundUsers[index].doctorName,
                          style: TextStyle(
                            fontSize: height / 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          foundUsers[index].speciality,
                          style: TextStyle(
                            fontSize: height / 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AbsorbPointer(
                  ignoringSemantics: true,
                  child: Center(
                    child: RatingBar.builder(
                      initialRating: foundUsers[index].rating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<DoctorDetailsProvider>(
                                    child: DoctorProfile(
                                        id: foundUsers[index].doctorId),
                                    create: (context) =>
                                        DoctorDetailsProvider()),
                          ));
                    },
                    child: Text(
                      "View Profile",
                      style: TextStyle(
                        fontSize: height / 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget doctorGridView() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 2 / 2.1,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: foundUsers.length,
        itemBuilder: (ctx, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                    width: 1, color: const Color.fromARGB(255, 215, 215, 215))),
            child: InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<DoctorDetailsProvider>(
                            child:
                                DoctorProfile(id: foundUsers[index].doctorId),
                            create: (context) => DoctorDetailsProvider()),
                  ),
                )
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: width * 0.08,
                    height: height * 0.08,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(foundUsers[index].imageUrl),
                          fit: BoxFit.scaleDown,
                        )),
                  ),
                  ListTile(
                    title: Text(
                      foundUsers[index].doctorName,
                      style: TextStyle(
                        fontSize: height / 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      foundUsers[index].speciality,
                      style: TextStyle(
                        fontSize: height / 75,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${foundUsers[index].rating}",
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget searchCard() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        //search and 2 buttons to choose grid or list view
        width: double.infinity,
        height: height * 0.30,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(8)),
            TextField(
              controller: doctorTextController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (value) => updateListByName(value),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: specialtTextController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by speciality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (value) => updateListBySpicalisty(value),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                ),
                buttonForView(
                    false,
                    const Icon(
                      Icons.list_alt,
                      size: 25,
                    ),
                    showGrid ? Colors.grey : Colors.blue),
                const SizedBox(
                  width: 20,
                ),
                buttonForView(
                    true,
                    const Icon(
                      Icons.grid_view_outlined,
                      size: 25,
                    ),
                    showGrid ? Colors.blue : Colors.grey),
              ],
            )
          ],
        ));
  }
}
