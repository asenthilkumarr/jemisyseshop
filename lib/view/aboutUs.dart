import 'dart:async';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AboutUsPage extends StatefulWidget{
  @override
  _aboutUsPage createState() => _aboutUsPage();
}
class _aboutUsPage extends State<AboutUsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Commonfn cfobj = Commonfn();

//  final Completer<WebViewController> _controller =
//  Completer<WebViewController>();
  Future LaunchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    }
    else {
      print("Can't Launch " + url);
    }
  }

  @override
  void initState() {
    super.initState();
    print(aboutusUrl);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    screenWidth = screenSize.width;
    if(kIsWeb){
      screenWidth =  cfobj.ScreenWidth(screenSize.width);
    }

    return MaterialApp(
      title: 'About Us',
      theme: MasterScreen.themeData(context),
      /*
      home: WebviewScaffold(
        url: url,
        appBar: AppBar(
          title: Text("WebView"),
        ),
        withJavascript: true,
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      */

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

        body: Row(
          children: [
            Flexible(
              child: Container(
                color: webLeftContainerColor,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(minWidth: 250, maxWidth: screenWidth),
                child: EasyWebView(
                  src: aboutusUrl,
                  isHtml: false, // Use Html syntax
                  isMarkdown: false, // Use markdown syntax
                  onLoaded: () {},
                ),
              ),
            ),
            Flexible(
              child: Container(
                color: webRightContainerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}