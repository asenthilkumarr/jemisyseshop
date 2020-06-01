import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../style.dart';
//import 'package:zoomable_image/zoomable_image.dart';

class ImageZoomPage extends StatelessWidget {
  final String imgUrl;

  ImageZoomPage({this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        body: SafeArea(
          child: Stack(
              children: <Widget>[
                Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: PhotoView(
                imageProvider: NetworkImage(imgUrl),
                backgroundDecoration: BoxDecoration(
                color: Colors.white,
              ),
              )
          ),
                Positioned(
                    right: 1.0,
                    top: 1.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          radius: 20.0,
//                          radius: 14.0,
                          backgroundColor: primary1Color,
                          child: Icon(Icons.close, color: Colors.white, size: 30,),
                        ),
                      ),
                    )),
              ]
          ),
        ),
      ),
        debugShowCheckedModeBanner: false,
    );
  }
}

//ZoomableImage(
//new AssetImage('images/squirrel.jpg'),
//placeholder: const Center(child: const CircularProgressIndicator()),
//backgroundColor: Colors.red)