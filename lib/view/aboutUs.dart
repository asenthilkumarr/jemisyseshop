
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/menu.dart';
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
        key: scaffoldKey,
//        drawer: MenuItemWedget3(scaffoldKey: scaffoldKey, isLogin: false),
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
        body: WebView(
          initialUrl: aboutusUrl,
//          initialUrl: "http://51.79.160.233/eShopWebPages/JEMiSysAboutUs.htm",
//        initialUrl: "http://51.79.160.233/TopCashiPaymentWeb/Home/Contact",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },),
      ),
    );
  }
}