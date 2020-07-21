
import 'dart:async';
//import 'dart:html';

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsPage extends StatefulWidget{
  @override
  _aboutUsPage createState() => _aboutUsPage();
}
class _aboutUsPage extends State<AboutUsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'About Us',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
//        key: scaffoldKey,
        appBar: AppBar(
          title: Text('About Us', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
              //scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
//        url: "https://google.com",

        body: EasyWebView(
          src: "http://51.79.160.233/eShopWebPages/JEMiSysAboutUs.htm",
//          src: "https://youtube.com",
          isHtml: false, // Use Html syntax
          isMarkdown: false, // Use markdown syntax
//          convertToWidets: false, // Try to convert to flutter widgets
          // width: 100,
          // height: 100,
          onLoaded: () {},
        ),


      ),
    );

  }
}