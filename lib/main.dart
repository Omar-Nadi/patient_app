import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/Provider/Report.dart';
import 'package:patient_app/Provider/doctorProfileProvider.dart';
import 'package:patient_app/UI/Profile.dart';
import 'package:provider/provider.dart';
import 'package:responsive_bottom_bar/responsive_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:patient_app/Provider/Theme.dart';
import 'package:patient_app/UI/appointments.dart';
import 'package:patient_app/UI/settings.dart';

import 'Module/AppBar.dart';
import 'UI/loginScreen.dart';
import 'UI/physicaians.dart';
import 'UI/report_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      child: const MyApp(),
      create: (context) => ThemeNotifier(prefs.getBool('isDarkTheme') == null
          ? false
          : prefs.getBool('isDarkTheme')!),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Patient App',
        theme: themeNotifier.getTheme,
        darkTheme: themeNotifier.darkTheme,
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MyHomePage();
              } else {
                return LoginScreen();
              }
            },
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var title = 'My Reports';
  final List<Widget> _widgetOptions = [
    ChangeNotifierProvider<ReportProvider>(
        child: FirstPageInReport(), create: (context) => ReportProvider()),
    ChangeNotifierProvider<DoctorDetailsProvider>(
        child: Physicainas(), create: (context) => DoctorDetailsProvider()),
    ChangeNotifierProvider<DoctorDetailsProvider>(
        child: const Appointments(),
        create: (context) => DoctorDetailsProvider()),
    const Profile()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        title = 'My Reports';
      } else if (_selectedIndex == 1) {
        title = 'Physicians & Appointments';
      } else if (_selectedIndex == 2) {
        title = 'My Appointments';
      } else if (_selectedIndex == 3) {
        title = 'My Profile';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: title,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search_rounded),
            label: 'Physicians',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 20,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
