import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../Module/AppBar.dart';

class DownloadPage extends StatelessWidget {
  String ImageURL;
  DownloadPage(
    this.ImageURL,
  );
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    var imageUrl = ImageURL;
    return Scaffold(
      appBar: const MainAppBar(
        title: 'Download Report',
      ),
      body:SingleChildScrollView( 
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          width: screenWidth,
          height: screenheight,
          child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Image.network(imageUrl),
        SizedBox(
          width: screenWidth,
          height: 50,
          child: ElevatedButton(
              onPressed: () async {
                var response = await Dio().get(imageUrl,
                    options: Options(responseType: ResponseType.bytes));
                final result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(response.data),
                    quality: 60,
                    name: "hello");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Image has been Downloaded")));
              },
              child: const Text(
                "Download Report",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )),
        ),
          ]),
        ),
      ),
    );
  }
}
