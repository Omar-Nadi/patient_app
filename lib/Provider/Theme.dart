// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  late ThemeData themeMode;
  bool valueOfNotification = true;
  bool valueOfTheme = false;

  ThemeNotifier(bool isDarkMode) {
    themeMode = isDarkMode ? darkTheme : lightTheme;
  }
  final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.blue,
    dividerColor: Colors.white54,
  );
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    dividerColor: Colors.black12,
  );

  Future setTheme(String str) async {
    final prefs = await SharedPreferences.getInstance();
    if (str == 'dark') {
      themeMode = darkTheme;
      prefs.setBool('isDarkTheme', true);
    } else {
      themeMode = lightTheme;
      prefs.setBool('isDarkTheme', false);
    }
    notifyListeners();
  }
  Icon get getThemeIcon => themeMode == darkTheme?const Icon(Icons.dark_mode):const Icon(Icons.light_mode);
  Text get getThemeText => themeMode == darkTheme?const Text('Dark') : const Text('light');
  ThemeData get getTheme => themeMode;
}
