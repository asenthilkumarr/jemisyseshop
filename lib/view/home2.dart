import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home 3',
      home: Home2(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Home2 extends StatefulWidget{
  @override
  _home2 createState() => _home2();
}

class _home2 extends State<Home2> {
  bool isLogin = false;
  String _selcategoryCode = '';
  String _selCategory = "";
  String _selCountry = 'SG';
  final formatter = new NumberFormat('##0.00', 'en_US');

  final List<String> images = [
    'http://42.61.99.57/JEMiSyseShopImage/front-banner2-lg.jpg',
    'http://42.61.99.57/JEMiSyseShopImage/mothers-day-2020.jpg',
    'http://42.61.99.57/JEMiSyseShopImage/wedding-band-promo150-banner-2020.jpg',
    'http://42.61.99.57/JEMiSyseShopImage/wedding-band-promo150-banner-ex-2020.jpg',
  ];

  final List<Category> categoryList = [
    Category('R', 'RING',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Ring.jpg'),
    Category('ER', 'EARRING',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Earring.png'),
    Category('PE', 'PENDANT',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Pendant.jpg'),
    Category('NE', 'NECKLACE',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Necklace.jpg'),
    Category('BR', 'BRACELET',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Bracelet.jpg'),
    Category('BA', 'BANGLE',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Bangle.jpg')
  ];
  final List<DesignCode> design = [
    DesignCode(
        'BA101',
        'BA',
        '',
        '18K YG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA101.jpg'),
    DesignCode(
        'BA102',
        'BA',
        '',
        '18K YG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA102.jpg'),
    DesignCode(
        'BA103',
        'BA',
        '',
        '18K YG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA103.jpg'),
    DesignCode(
        'BA104',
        'BA',
        '',
        '18K YG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA104.jpg'),
    DesignCode(
        'BA105',
        'BA',
        '',
        '18K YG',
        0.00,
        24.250,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA105.jpg'),
    DesignCode(
        'BA106',
        'BA',
        '',
        '18K YG',
        0.00,
        32.15,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA106.jpg'),
    DesignCode(
        'BA107',
        'BA',
        '',
        '18K YG',
        0.00,
        15.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA107.jpg'),
    DesignCode(
        'BA108',
        'BA',
        '',
        '18K YG',
        0.00,
        33.12,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BA108.jpg'),

    DesignCode(
        'BR101',
        'BR',
        '',
        '18K WG',
        1250.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BR101.jpg'),
    DesignCode(
        'BR102',
        'BR',
        '',
        '18K WG',
        0.00,
        22.30,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BR102.png'),
    DesignCode(
        'BR103',
        'BR',
        '',
        '18K WG',
        1250.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BR103.jpg'),
    DesignCode(
        'BR104',
        'BR',
        '',
        '18K WG',
        0.00,
        41.30,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BR104.png'),
    DesignCode(
        'BR105',
        'BR',
        '',
        '18K WG',
        0.00,
        35.12,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/BR105.jpg'),

    DesignCode(
        'DR101',
        'R',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/DR101.jpg'),
    DesignCode(
        'DR102',
        'R',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/DR102.jpg'),
    DesignCode(
        'DR103',
        'R',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/DR103.jpg'),
    DesignCode(
        'DR104',
        'R',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/DR104.jpg'),
    DesignCode(
        'DR105',
        'R',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/DR105.jpg'),
    DesignCode(
        'DR106',
        'R',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/DR106.jpg'),

    DesignCode(
        'GR101',
        'R',
        '',
        '18K WG',
        0.00,
        6.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/GR101.jpg'),
    DesignCode(
        'GR102',
        'R',
        '',
        '18K WG',
        0.00,
        8.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/GR102.jpg'),
    DesignCode(
        'GR103',
        'R',
        '',
        '18K WG',
        0.00,
        6.20,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/GR103.jpg'),

    DesignCode(
        'ER101',
        'ER',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER101.jpg'),
    DesignCode(
        'ER102',
        'ER',
        '',
        '18K WG',
        0.00,
        6.40,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER102.jpg'),
    DesignCode(
        'ER103',
        'ER',
        '',
        '18K WG',
        0.00,
        4.50,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER103.jpg'),
    DesignCode(
        'ER104',
        'ER',
        '',
        '18K WG',
        0.00,
        3.50,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER104.jpg'),
    DesignCode(
        'ER105',
        'ER',
        '',
        '18K WG',
        0.00,
        4.30,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER105.jpg'),
    DesignCode(
        'ER106',
        'ER',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER106.jpg'),
    DesignCode(
        'ER107',
        'ER',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/ER107.jpg'),

    DesignCode(
        'NE101',
        'NE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE101.jpg'),
    DesignCode(
        'NE102',
        'NE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE102.jpg'),
    DesignCode(
        'NE103',
        'NE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE103.jpg'),
    DesignCode(
        'NE104',
        'NE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE104.jpg'),
    DesignCode(
        'NE105',
        'NE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE105.jpg'),
    DesignCode(
        'NE106',
        'NE',
        '',
        '18K WG',
        0.00,
        76.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE106.jpg'),
    DesignCode(
        'NE107',
        'NE',
        '',
        '18K WG',
        0.00,
        53.50,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE107.jpg'),
    DesignCode(
        'NE108',
        'NE',
        '',
        '18K WG',
        0.00,
        102.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE108.jpg'),
    DesignCode(
        'NE109',
        'NE',
        '',
        '18K WG',
        0.00,
        35.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/NE109.jpg'),

    DesignCode(
        'PE101',
        'PE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/PE101.jpg'),
    DesignCode(
        'PE102',
        'PE',
        '',
        '18K WG',
        0.00,
        7.52,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/PE102.jpg'),
    DesignCode(
        'PE103',
        'PE',
        '',
        '18K WG',
        0.00,
        10.20,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/PE103.jpg'),
    DesignCode(
        'PE104',
        'PE',
        '',
        '18K WG',
        0.00,
        6.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/PE104.jpg'),
    DesignCode(
        'PE105',
        'PE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/PE105.jpg'),
    DesignCode(
        'PE106',
        'PE',
        '',
        '18K WG',
        1200.00,
        0.00,
        0.00,
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/PE106.jpg'),
  ];

  final List<ItemMasterList> items = [
    ItemMasterList('IN00001', 'Item 1', 'Diamond',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Diamond Necklace.jpg'),
    ItemMasterList('IN00002', 'Item 2', 'Diamond',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Diamond Necklace.jpg'),
    ItemMasterList('IN00003', 'Item 3', 'Diamond',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Diamond Necklace.jpg'),
    ItemMasterList('IN00004', 'Item 4', 'Diamond',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Diamond Necklace.jpg'),
    ItemMasterList('IN00005', 'Item 5', 'Diamond',
        'http://42.61.99.57/JEMiSyseShopImage/jewelimages/Diamond Necklace.jpg'),
    ItemMasterList('IN00006', 'Item 6', 'Diamond',
        'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00007', 'Item 7', 'Diamond',
        'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00008', 'Item 8', 'Diamond',
        'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
  ];

  List<DesignCode> selDesign = new List<DesignCode>();
  Country sCountry;
  bool hidetitleMsg = false;

  void getDefault() {
    var sitem = country.firstWhere((d) => d.shortCode == _selCountry);
    sCountry = sitem;
  }

  void _showPopupMenu() async {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, kIsWeb ? 55 : 80, 50, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('CURRENCY'), value: 'CURRENCY'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Image.asset(
                  sCountry.imageUrl, height: 20, fit: BoxFit.fitHeight,),
                SizedBox(width: 10,),
                Text(sCountry.currency)
              ],
            ))
      ],
      elevation: 8.0,
    );
  }

  void getDesign() {
    var sitem = design.where((d) => d.categoryCode == _selcategoryCode)
        .toList();
    selDesign = new List<DesignCode>();
    selDesign = sitem;
  }

  int GridItemCount(double screenwidth) {
    int itemCount = 0,
        a = 0;
    if (screenwidth <= 550)
      itemCount = 2;
    else if (screenwidth <= 650)
      itemCount = 3;
    else if (screenwidth <= 750)
      itemCount = 4;
    else if (screenwidth <= 950)
      itemCount = 5;
    else if (screenwidth <= 1100)
      itemCount = 6;
    else if (screenwidth <= 1250)
      itemCount = 7;
    else if (screenwidth <= 1400)
      itemCount = 8;
    else
      itemCount = 10;

    return itemCount;
  }

  double GridItemHeight(double screenHeight, double screenWidth) {
    double itemHeight = 0.55;
    if (screenHeight > 880)
      itemHeight = 0.90;
    else if (screenHeight > 780)
      itemHeight = 0.75;
    else if (screenHeight > 580)
      itemHeight = 0.75;
    else if (screenHeight > 270 && screenWidth > 350)
      itemHeight = 0.70;
    itemHeight = 1;
    return itemHeight;
  }

  Widget BannerImage(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double _height = 100;
    double _ratio = 0.65;
    if (screenWidth > 1600){
      _height = 350; _ratio =0.5;
    }
    else if (screenWidth >= 1300){
      _height = 300;_ratio=1;
    }
    else if (screenWidth >= 1000){
      _height = 250;_ratio=0.55;
    }
    else if (screenWidth >= 850){
      _height = 220;_ratio=0.9;
    }
//    else if (screenWidth >= 790){
//      _height = 215;_ratio=1.0;
//    }
    else if (screenWidth >= 700){
      _height = 210;_ratio=1.0;
    }
    else if (screenWidth >= 630){
      _height = 210;_ratio=0.8;
    }
    else if (screenWidth >= 500){
      _height = 200;_ratio=0.9;
    }
    else if (screenWidth >= 400){
      _height = 120;_ratio=0.8;
    }
    if (images.length > 1) {
      return new Container(
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
//              autoPlay: true,
//              aspectRatio: 3.5,
//              enlargeCenterPage: true,
              aspectRatio: 16/9,
              viewportFraction: _ratio,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
//              onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
              height: _height
          ),
          itemBuilder: (context, index) {
            return Container(
              child: SizedBox(
                  child: Image.network(images[index], fit: BoxFit.fitHeight,
                    )
              ),
            );
          },
        ),
      );
    }
    else {
      return new Container(
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              height: _height
          ),
          itemBuilder: (context, index) {
            return Container(
              child: SizedBox(
                  child: Image.network(images[index], fit: BoxFit.fitWidth,
                    width: screenWidth - 30,)
              ),
            );
          },
        ),
      );
    }
  }

  Widget DesignGridWidgets(DesignCode item) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: listbgColor,
            width: 1.0,
          ),
        ),
        child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Image(
                    image: CachedNetworkImageProvider(
                      item.imageUrl,
                    ),
                    fit: BoxFit.fitHeight,
                  ),
//                  child: Image.network(
//                    item.imageUrl, fit: BoxFit.fitHeight,),
                ),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    //color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0.0, bottom: 3.0),
                      child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(item.designCode),
                          Spacer(),
                          Text(item.tagPrice > 0 ? '\$${formatter.format(
                              item.tagPrice)}' : 'Wt.: ${formatter.format(
                              item.grossWeight)}g'),
                        ],
                      ),
                    ),
                  )
              ),
            ]
        )
    );
  }

  Widget DesignGridWidgets2(DesignCode item) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Container(
                child: Image.network(
                  item.imageUrl, width: 500, fit: BoxFit.fill,),
              ),
            ),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(item.designCode),
                      Spacer(),
                      Text(item.tagPrice > 0 ? '\$${formatter.format(
                          item.tagPrice)}' : 'Wt.: ${formatter.format(
                          item.grossWeight)} g'),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  Widget titleBar(){
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
                       width: 80,
                       child: Row(
                       children: [
                         Visibility(
                           visible: !isLogin ? true : true,
                           child: SizedBox(
                           width: 40,
                           child: IconButton(
//                             icon: new Image.asset(
//                                 isLogin ? 'assets/user_profile.png' : 'assets/login.png', height: 25,),
                             icon: Icon(Icons.person, color: !isLogin ? Colors.white : Colors.transparent,),
                             iconSize: 25,
                             onPressed: () {
                               if (isLogin)
                                 isLogin = false;
                               else
                                 isLogin = true;
                               setState(() {

                               });
                             },
                           )),
                         ),
//                         SizedBox(
//                             width: 40,
//                             child: IconButton(
//                           key: _keyRed,
//                           icon: new Image.asset('assets/goldRate.png', height: 20,),
//                           iconSize: 15,
//
//                           onPressed: () {
//                             showGoldRate();
//                           },
//                         )),
                         Center(
                             child: SizedBox(
                                 width: 40,
                                 child: Padding(
                             padding: const EdgeInsets.only(right: 0.0),
                                     child: Stack(
                                 children: <Widget>[
                                   //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                                   IconButton(
                                     icon: new Image.asset('assets/shopping_cart.png', height: 20,),
//                                     icon: Icon(Icons.cur, color: Colors.white,),
                                     iconSize: 15,
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
      padding: const EdgeInsets.only(bottom:1.0),
      child: Container(
          color: primary1Color,
          child: Padding(
            padding: const EdgeInsets.only(left:8.0, top:8.0, bottom:8.0, right:5.0),
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
                      onTap: (){
                        hidetitleMsg = true;
                        setState(() {

                        });
                      },
                      child: Icon(Icons.close, color: Colors.white, size: 18,),

                    )),
            ]
          ),
      ),
      ))
    : Container();
  }
  Widget pageAppBar() {
    return AppBar(
//      title: Text("JEMiSys eShop"),

    elevation: 0.0,
    backgroundColor: primary1Color,
    centerTitle: true,
    actions: <Widget>[
//          Visibility(
//              visible: isLogin ? true : false,
//              child:
//          ),
      Visibility(
        visible: !isLogin ? true : false,
        child: IconButton(
          icon: new Image.asset(
              isLogin ? 'assets/user_profile.png' : 'assets/login.png'),
          iconSize: 20,

          onPressed: () {
            if (isLogin)
              isLogin = false;
            else
              isLogin = true;
            setState(() {

            });
          },
        ),
      ),
      IconButton(
        icon: new Image.asset(sCountry.imageUrl),
        iconSize: 20,
        onPressed: () {
          _showPopupMenu();
        },
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Stack(
              children: <Widget>[
                //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                IconButton(
                  icon: new Image.asset('assets/shopping_cart.png'),
                  iconSize: 20,
                  onPressed: () {},),
                new Positioned( // draw a red marble
                  top: 2.0,
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
          ),
        ),
      ),
    ]
    );
  }

  Widget CategoryListitem(BuildContext context, Category dt) {
    if (dt.categoryCode != null) {
      return Container(
        width: 110,
        //color: Colors.grey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selcategoryCode = dt.categoryCode;
                        _selCategory = dt.description;
                        getDesign();
                        setState(() {});
                      },
                      child: Container(
                        child: ClipRRect(
//                          borderRadius: BorderRadius.circular(20.0),
                          child: _sizedContainer(
                            Image(
                              image: CachedNetworkImageProvider(
                                dt.imageUrl,
                              ),
                            ),
                          ),
//                          child: Image.network(dt.imageUrl,
//                            width: 80, fit: BoxFit.fitHeight,),
                        ),),
                    )
                    //Image.network(dt.imageUrl, height: 80, width: 80,),
                    //Spacer(),
                  ],
                ),
                Spacer(),
                Container(
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${dt.description}',
                        style: TextStyle(color: Colors.white),),
                      //Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return new Text('ERROR');
    }
  }
  Widget CategoryListView(List<Category> data) {
    return
      new ListView.builder(

        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            CategoryListitem(context, data[index]),
      );
  }
  Widget CategoryListitem2(BuildContext context, Category dt) {
    if (dt.categoryCode != null) {
      return Container(
        width: 110,
        //color: Colors.grey,
        child: Card(
//          shape: RoundedRectangleBorder(
//            side: BorderSide(
//              color: Color(0xFFD6DFE4),
//              width: 1.0,
//            ),
//          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selcategoryCode = dt.categoryCode;
                        _selCategory = dt.description;
                        getDesign();
                        setState(() {});
                      },
                      child: _sizedContainer(
                        Image(
                          image: CachedNetworkImageProvider(
                            dt.imageUrl,
                          ),
                        ),
                      ),
                    )
                    //Image.network(dt.imageUrl, height: 80, width: 80,),
                    //Spacer(),
                  ],
                ),
                Spacer(),
                Container(
                  color: listLabelbgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${dt.description}',
                        style: TextStyle(color: Colors.white),),
                      //Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return new Text('ERROR');
    }
  }

  Widget CategoryListView2(List<Category> data) {
    return
      new ListView.builder(

        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            CategoryListitem2(context, data[index]),
      );
  }
  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: Center(child: child),
    );
  }
  Widget CompanyLogo() {
    return new Container(
      color: primary1Color,
child: Text('JEMiSys eShop', style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
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
    if(kIsWeb && hidetitleMsg)
      p = 45.0;
    else if(kIsWeb && !hidetitleMsg)
      p = 75.0;
    else if(!kIsWeb && hidetitleMsg)
      p = 70.0;
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    double topp = positionRed.dy;
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
            padding: EdgeInsets.only(top: topp, left:20.0, right:20),
            child: Align(
              alignment: _fromTop ? Alignment.topRight : Alignment.bottomCenter,
              child: Material(
                type: MaterialType.transparency,
                child: new Stack(
                  children: <Widget>[
                    Container(
                height: 100,
                child: SizedBox( width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left:30.0, top:10.0),
                    child: Column(
                      children: [
                        Text('Gold Rate'),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:15.0),
                              child: Text('916 :'),
                            ),
                            Text('\$55.50'),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:15.0),
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
                    topLeft: const  Radius.circular(1000.0),
                    topRight: const Radius.circular(300.0),
                    bottomLeft: const  Radius.circular(150.0),
                    bottomRight: const  Radius.circular(1000.0),
                  ),
                ),
              ),
              Positioned(
                  right: 0.0,
                  child: GestureDetector(
                    onTap: (){
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

  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyRed = GlobalKey();
  _getPositions() {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Red: $positionRed ");
  }
  @override
  void initState() {
    super.initState();
//    DefaultCacheManager manager = new DefaultCacheManager();
//    manager.emptyCache(); //clears all data in cache.
//    imageCache.clear();
    getDefault();
    if (categoryList.length > 0) {
      _selcategoryCode = categoryList[0].categoryCode;
      _selCategory = categoryList[0].description;
      getDesign();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    Future.delayed(Duration.zero, () => showGoldRate());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
//    double screenheight = screenSize.height;
//    if (!kIsWeb) screenheight = screenSize.height - 24;
    int itemCount = GridItemCount(screenSize.width);
    double itemheight = GridItemHeight(screenSize.height, screenSize.width);

    return Scaffold(
      key: scaffoldKey,
//      appBar: pageAppBar(),
      drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
      body: SafeArea(
          child: Container(
              color: Colors.white,
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: titleMessage(),//CompanyLogo(),
                    ),
                    SliverToBoxAdapter(
                      child: titleBar(),//CompanyLogo(),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: BannerImage(context),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          //PageTitleBar(context),

                          SizedBox(
                            height: 5,
                          ),
                          //Menu
                          SizedBox(
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0),
                              child: Container(
                                //margin: const EdgeInsets.all(15.0),
                                //padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: listbgColor)
                                ),
                                //child: HorizontalMenu(menuitem, context),
                                child:
                                Stack(
                                    children: <Widget>[
HorizontalMenuWedget(),
                                      Positioned(
                                          right: 0.0,
                                          key: _keyRed,
                                          child: GestureDetector(
   onTap: (){
                                              showGoldRate();
                                              setState(() {
                                              });
                                            },
                                            //child: Icon( Image.asset('assets/goldRate.png', height: 20,)),
//                                            child: Icon(Icons.close, color: primary1Color, size: 18,),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:2.0),
                                              child: Container(
                                                color: primary1Color,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Image.asset('assets/goldRate.png', height: 17,),
                                                  )),
                                            ),
                                          )),
                                ]
                              )
                            ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0),
                            child: Container(
                                height: 120,
                                color: listbgColor,
                                child: FutureBuilder<List<ItemMasterList>>(
                                  //future: _fetchData(),
                                  builder: (context, snapshot) {
                                    if (categoryList.length > 0) {
                                      List<Category> data = categoryList;
                                      return CategoryListView2(data);
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }
                                    return Container();
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
//                    SliverList(
//                      delegate: SliverChildListDelegate(
//                        [
//                          Padding(
//                            padding: const EdgeInsets.only(
//                                left: 5.0, right: 5.0),
//                            child: Container(
//                                height: 120,
//                                color: Color(0xFFE5E7E9),
//                                child: FutureBuilder<List<ItemMasterList>>(
//                                  //future: _fetchData(),
//                                  builder: (context, snapshot) {
//                                    if (categoryList.length > 0) {
//                                      List<Category> data = categoryList;
//                                      return CategoryListView(data);
//                                    } else if (snapshot.hasError) {
//                                      return Text("${snapshot.error}");
//                                    }
//                                    return Container();
//                                  },
//                                )
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                    //Space
                    SliverToBoxAdapter(
                      child: SizedBox(height: 3,),
                    ),
                    //Design Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: listbgColor),
                              color: listLabelbgColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 5.0, 0.0, 5.0),
                            child: Text(_selCategory, style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    //Design List
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemCount,
                        childAspectRatio: itemheight-0.05,
                      ),
                      delegate: SliverChildListDelegate(
                        [
                          for(var i in selDesign)
                            DesignGridWidgets(i),
                        ],
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0),
                            child: Container(
                                height: 120,
                                color: Color(0xFFD6DFE4),
                                child: FutureBuilder<List<ItemMasterList>>(
                                  //future: _fetchData(),
                                  builder: (context, snapshot) {
                                    if (categoryList.length > 0) {
                                      List<Category> data = categoryList;
                                      return CategoryListView2(data);
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }
                                    return Container();
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              )
          )
      ),
    );
  }
}
