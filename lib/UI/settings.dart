import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:patient_app/UI/editProfile.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:patient_app/Provider/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../Module/AppBar.dart';
import 'changePassword.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String value = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: 'Settings',
      ),
      body: (SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
                onPressed: ((context) => ShowDialog(context)),
              ),
              SettingsTile.navigation(
                  onPressed: (_) {
                    setState(() {
                      if (context.read<ThemeNotifier>().getTheme ==
                          context.read<ThemeNotifier>().darkTheme) {
                        context.read<ThemeNotifier>().setTheme('light');
                      } else {
                        context.read<ThemeNotifier>().setTheme('dark');
                      }
                    });
                  },
                  leading: context.read<ThemeNotifier>().getThemeIcon,
                  title: context.read<ThemeNotifier>().getThemeText),
              SettingsTile.switchTile(
                title: const Text('Notifications'),
                leading: Icon(context.read<ThemeNotifier>().valueOfNotification
                    ? Icons.notifications_on
                    : Icons.notifications_off),
                onToggle: (value) {
                  setState(() {
                    context.read<ThemeNotifier>().valueOfNotification = value;
                  });
                },
                initialValue: context.read<ThemeNotifier>().valueOfNotification,
              ),
              SettingsTile.navigation(
                title: const Text('Edit Profile'),
                leading: const Icon(Icons.edit_outlined),
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfile()));
                }),
              ),
              SettingsTile.navigation(
                title: const Text('Change Password'),
                leading: const Icon(Icons.change_circle),
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                }),
              ),
              SettingsTile.navigation(
                title: const Text('Log Out'),
                leading: const Icon(Icons.logout),
                onPressed: ((context) => FirebaseAuth.instance.signOut()),
              ),
            ],
          ),
        ],
      )),
    );
  }

  ShowDialog(context) {
    showDialog(
      context: context,
      builder: (ic) => AlertDialog(
        title: const Text('Language'),
        content: Container(
          height: 100,
          width: 100,
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ic).pop();
                    showToast('Language is already English');
                  },
                  child: const Text('English')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ic).pop();
                    showToast('The app not supported Arabic yet');
                  },
                  child: const Text('العربية')),
            ],
          ),
        ),
      ),
    );
  }

  showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 15);
  }
}
