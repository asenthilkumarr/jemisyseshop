import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/home.dart';
import 'package:jemisyseshop/view/home2.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'model/common.dart';
import 'model/dataObject.dart';
import 'model/menu.dart';
class Test extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      home: TestHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class TestHome extends StatefulWidget{
  _TabBarDemo createState() => _TabBarDemo();


}



class _TabBarDemo extends State<TestHome> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyRed = GlobalKey();
  bool hidetitleMsg = false;
  final List<menuList> mnuList = [
    menuList('Home', HomeScreen()),
    menuList('Home 2', HomeScreen2()),
  ];

  Widget titleBar() {
    return Container(
      color: primary1Color,
      child: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white,),
                  iconSize: 25,

                  onPressed: () {
                    scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: CompanyLogo(),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 105,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 35,
                            child: IconButton(
                              key: _keyRed,
                              icon: new Image.asset('assets/goldRate.png', height: 20,),
                              iconSize: 25,

                              onPressed: () {
                                showGoldRate();
                              },
                            )),
                        Center(
                          child: SizedBox(
                            width: 35,
                            child: Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Stack(
                                    children: <Widget>[
                                      //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                                      IconButton(
                                        icon: new Image.asset(
                                          'assets/shopping_cart.png',
                                          height: 20,),
//                                     icon: Icon(Icons.cur, color: Colors.white,),
                                        iconSize: 25,
                                        onPressed: () {},),
                                      new Positioned( // draw a red marble
                                        top: 5.0,
                                        right: 10.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: new Text(
                                              '5',
                                              style: new TextStyle(
                                                color: Colors.red,
                                                fontSize: 9,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
              )


            ],
          ),

        ],
      ),

    );
  }

  Widget titleMessage() {
    return !hidetitleMsg ? Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Container(
          color: primary1Color,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, top: 8.0, bottom: 8.0, right: 5.0),
            child: Stack(
                children: <Widget>[
                  Wrap(
                    runSpacing: 5.0,
                    spacing: 5.0,
                    direction: Axis.horizontal,
                    children: [
                      Center(
                        child: Text("FREE SHIPPING ON EVERY ORDER",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          hidetitleMsg = true;
                          setState(() {

                          });
                        },
                        child: Icon(
                          Icons.close, color: Colors.white, size: 18,),

                      )),
                ]
            ),
          ),
        ))
        : Container();
  }
  Widget CompanyLogo() {
    return new Container(
      color: primary1Color,
      child: Text('JEMiSys eShop',
        style: GoogleFonts.oswald(
          textStyle: TextStyle(color: Colors.white, fontSize: 35),
        ),
        //style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.normal,)
      ),
//      child: SizedBox(
//        height: 30,
//        child: new Image.network(
//          'http://42.61.99.57/JEMiSyseShopImage/Banner3.png',
//          //"http://42.61.99.57/JEMiSyseShopImage/logo.png",
//          fit: BoxFit.fitHeight,
//        ),
//      ),
    );
  }
  void showGoldRate() {
    bool _fromTop = true;
    double p = 100.0;
//    double topp=positionRed.dx;
//    double rightp=positionRed.dy;
    if (kIsWeb && hidetitleMsg)
      p = 45.0;
    else if (kIsWeb && !hidetitleMsg)
      p = 75.0;
    else if (!kIsWeb && hidetitleMsg)
      p = 70.0;
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    double topp = positionRed.dy+30;
//    double rightp = positionRed.dx;
//        print('$topp and $rightp');
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Padding(
//            padding: EdgeInsets.only(top: p, left:20.0, right:kIsWeb ? 50 : 50),
            padding: EdgeInsets.only(top: topp, left: 20.0, right: 50),
            child: Align(
                alignment: _fromTop ? Alignment.topRight : Alignment
                    .bottomCenter,
                child: Material(
                  type: MaterialType.transparency,
                  child: new Stack(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: SizedBox(width: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 10.0),
                              child: Column(
                                children: [
                                  Text('Gold Rate'),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0),
                                        child: Text('916 :'),
                                      ),
                                      Text('\$55.50'),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0),
                                        child: Text('999 :'),
                                      ),
                                      Text('\$65.50'),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
//              margin: EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 50),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(1000.0),
                              topRight: const Radius.circular(300.0),
                              bottomLeft: const Radius.circular(150.0),
                              bottomRight: const Radius.circular(1000.0),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                            )),
                      ]),
                )
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: mnuList.length,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(150.0), // here the desired height
              child: AppBar(
                title: PreferredSize(
                    preferredSize: Size.fromHeight(130.0),
                    child: Column(
                  children: [
                    Container(
                    height: 90,
                    child: Column(
                      children: [
                        Text('Home'),
                        Text('Home2'),
                        Text('Home3'),
                      ],
                    ),
                    )

                  ],
                )),
                backgroundColor: Colors.deepOrange,
//                centerTitle: true,
                leading: IconButton(icon:Icon(Icons.arrow_back),
                    onPressed:() {
//                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
////                        InvoiceList()), (Route<dynamic> route) => false);
                      Navigator.pop(context, false);
                    }
                ),

                bottom:  PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Column(
                    children: <Widget>[
                      new Container(
                          height: 60.0,
                          color: Colors.white,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20,9,0,0),
                                      child: Text(
                                        'gDocNo',
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30,9,0,0),
                                      child: Text(
                                        'gDocType',
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20,5,0,0),
                                      child: Text(
                                        'gStoreCode',
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30,5,0,0),
                                      child: Text(
                                        'gVipName',
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          )
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.clear),
//                  onPressed: () => _paths.clear(),
//                  color: Colors.white,
//                ),
                ],
              )
          ),

          body: TabBarView(
            children: [
              for(var i in mnuList)
                i.url,
            ],
          ),
        ),
      ),
    );
  }
}