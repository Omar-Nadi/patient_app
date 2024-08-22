import 'package:flutter/material.dart';
import 'package:patient_app/UI/Profile.dart';
import 'package:patient_app/UI/settings.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget{

  final title;

  const MainAppBar({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
   return AppBar(
      title:Text(title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon:const Icon(Icons.settings), onPressed: () {Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Setting()));},),
          ),
        ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}