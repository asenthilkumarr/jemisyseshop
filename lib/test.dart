import 'dart:async';
//import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;
import 'package:webview_flutter/webview_flutter.dart';

class Test extends StatefulWidget {
  @override
  _test createState() => _test();
}

class _test extends State<Test> {
  String src = 'https://flutter.dev';
  //String src2 = 'https://flutter.dev/community';
  String src3 = 'http://www.youtube.com/embed/IyFZznAk69U';
  static ValueKey key = ValueKey('key_0');
  static ValueKey key2 = ValueKey('key_1');
  static ValueKey key3 = ValueKey('key_2');
  bool _isHtml = false;
  bool _isMarkdown = false;
  bool _useWidgets = false;
  bool _editing = false;
  bool _isSelectable = false;

  bool open = false;
  String src2 = "http://51.79.160.233/JEMiSyseShopAPI/api/Payment?paymentMode=VM&orderID=T001&payType=S&amount=0.02&currency=SGD";
//  void LaunchUrl(String url) async{
//    await html.window.open(url, 'new tab');
//    print("XXX---------------------------------------AAA------------------------------------------ZZZ");
//  }
  LaunchUrl(String url)  async {
    if (await canLaunch(url)) {
      await launch(url,
        forceSafariVC: true,
        enableJavaScript: true,);
      print("XXX---------------------------------------------------------------------------------ZZZ");
    } else {
      throw 'Could not launch $url';
    }
  }
  Future LaunchUrl2(String url) async{
    print("---------------------------------------------------------------------------------");
    print(url);
    if(await canLaunch(url)){
      print("---------------------------------------------------------------------------------");
      print(url);
     var val = await launch(url, forceSafariVC: true, forceWebView: true,
          enableJavaScript: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
       enableDomStorage: true,
      );
     print("--------AAAAAA-----------BBBBBBBBBBBBBBBBB--------------------BBBBBBB-----------");
     if(val!= null)
        print(val);
    }
    else {
      print("Can't Launch "+ url);
    }
  }

  @override
  void initState() {
    super.initState();
    src2 = "http://localhost/Payment/SuccessMessage.html";

  }

  @override
  Widget build(BuildContext context) {
 /*
    return MaterialApp(
      title: 'About Us',

      home: Scaffold(
        appBar: AppBar(
          title: Text('Test ', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
              //scaffoldKey.currentState.openDrawer();
            },
          ),
          centerTitle: true,
        ),

        body: EasyWebView(
          src: src2,
          isHtml: false, // Use Html syntax
          isMarkdown: false, // Use markdown syntax
          convertToWidgets: false,
          onLoaded: () {
            print("AAA-------------------------------------------------------------AAA");
            print(src2);
          },
        ),
      ),
    );
*/
    return Scaffold(
        appBar: AppBar(
          title: Text('Easy Web View'),
          leading: IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              setState(() {
                print("Click!");
                open = !open;
              });
            },

            //tooltip: "Menu",
          ),
        ),
      body: Container(
        child: RaisedButton(
          onPressed: () async{
//            await js.context.callMethod("open", [src2]);
            await LaunchUrl(src2);
  print("-----CC-----------------CCCCCCCCCCC-----------------------CC-----");
          },
          child: Text("Payment"),
        ),
      ),
      /*
        body: WebviewScaffold(
          url: aboutusUrl,
          withZoom: false,
          withLocalStorage: true,
          withJavascript: true,
        ),

        body: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: EasyWebView(
                      onLoaded: () {
                        print('$key2: Loaded: $src2');
                      },
                      src: src2,
                      isHtml: _isHtml,
                      isMarkdown: _isMarkdown,
                      convertToWidgets: _useWidgets,
                      key: key2
                    // width: 100,
                    // height: 100,
                  ),
                ),
              ],
            ),
            /*
            Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: (open) ? 500 : 0,
                      child: EasyWebView(
                          src: src3,
                          onLoaded: () {
                            print('$key3: Loaded: $src3');
                          },
                          isHtml: _isHtml,
                          isMarkdown: _isMarkdown,
                          convertToWidgets: _useWidgets,
                          key: key3
                        // width: 100,
                        // height: 100,
                      ),
                    )),
              ],
            )
            */
          ],
        ),
      */
    );
  }
}