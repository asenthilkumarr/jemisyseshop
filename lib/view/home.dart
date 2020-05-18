import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/model/tempData.dart';
import 'package:jemisyseshop/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/animation.dart';

class HomeScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget{
  @override
  _home createState() => _home();
}

class _home extends State<Home> with TickerProviderStateMixin {
  bool isLogin = false;
  String _selcategoryCode = '';
  String _selCategory = "";
  String _selCountry = 'SG';
  int _selectedCategoryIndex = 0;
  final formatter2dec = new NumberFormat('##0.00', 'en_US');
  final formatterint = new NumberFormat('##0', 'en_US');
  AnimationController controller;
  Animation<double> animation;
  ItemScrollController _scrollControllerlist = ItemScrollController();
  TabController _tabController;

  List<DesignCode> selDesign = new List<DesignCode>();
  Country sCountry;

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
    if (screenWidth > 1600)
      _height = 650;
    else if (screenWidth >= 1300)
      _height = 500;
    else if (screenWidth >= 1000)
      _height = 400;
    else if (screenWidth >= 700)
      _height = 300;
    else if (screenWidth >= 500)
      _height = 200;
    else if (screenWidth >= 400)
      _height = 120;
    if (images.length > 1) {
      return new Container(
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
              autoPlay: true,
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
  Widget BannerImage2(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double _height = 100;
    double _ratio = 0.65;
    if (screenWidth > 1600) {
      _height = 350;
      _ratio = 0.5;
    }
    else if (screenWidth >= 1300) {
      _height = 300;
      _ratio = 1;
    }
    else if (screenWidth >= 1000) {
      _height = 250;
      _ratio = 0.55;
    }
    else if (screenWidth >= 850) {
      _height = 220;
      _ratio = 0.9;
    }
//    else if (screenWidth >= 790){
//      _height = 215;_ratio=1.0;
//    }
    else if (screenWidth >= 700) {
      _height = 210;
      _ratio = 1.0;
    }
    else if (screenWidth >= 630) {
      _height = 210;
      _ratio = 0.8;
    }
    else if (screenWidth >= 500) {
      _height = 200;
      _ratio = 0.9;
    }
    else if (screenWidth >= 400) {
      _height = 120;
      _ratio = 0.8;
    }
    if (images.length > 1) {
      return new Container(
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
//              autoPlay: true,
//              aspectRatio: 3.5,
//              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
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
//              CustomPaint(
//                painter: ShapesPainter(),
//                child: Center(
//                  child: Transform.rotate(angle: - pi / 4,
//                    child: Text("50%\nOFF", style: TextStyle(fontSize: 22, ),
//                    ),
//                  ),
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: FractionalOffset.center,
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
                    color: listbgColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                      child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(item.designCode),
                          Spacer(),
                          Text(item.tagPrice > 0 ? '\$${formatterint.format(
                              item.tagPrice)}' : 'Wt.: ${formatter2dec.format(
                              item.grossWeight)}g'),
                        ],
                      ),
                    ),
                  )
              ),
              item.promotion != "" ? Positioned(
                left: 0.0,
                child: Container(
                  child: CustomPaint(
                    painter: ShapesPainter(),
//                      painter: DrawTriangle(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 9.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.rotate(angle: -pi / 4,
                            child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                      width: 40,
                                      child: Text(item.promotion,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      )

                                  ),
                                ])
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(height: 1, width: 1,),
            ]
        )
    );
  }

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
                    width: 80,
                    child: Row(
                      children: [
                         SizedBox(
                             width: 40,
                             child: IconButton(
                           key: _keyRed,
                           icon: new Image.asset('assets/goldRate.png', height: 25,),
                           iconSize: 30,

                           onPressed: () {
                             showGoldRate();
                           },
                         )),
                        Center(
                          child: SizedBox(
                            width: 40,
                            child: Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Stack(
                                    children: <Widget>[
                                      //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                                      IconButton(
                                        icon: new Image.asset(
                                          'assets/shopping_cart.png',
                                          height: 25,),
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
    return !hideTitleMessage ? Padding(
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
                          hideTitleMessage = true;
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

  Widget TopSellingListitem(DesignCode item) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    int count = GridItemCount(screenSize.width);
    return Container(
        width: screenSize.width / count-4,
        //color: Colors.grey,
        child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: listbgColor,
            width: 1.0,
          ),
        ),
        child: Stack(
            children: <Widget>[
//              CustomPaint(
//                painter: ShapesPainter(),
//                child: Center(
//                  child: Transform.rotate(angle: - pi / 4,
//                    child: Text("50%\nOFF", style: TextStyle(fontSize: 22, ),
//                    ),
//                  ),
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: FractionalOffset.center,
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
                    color: listbgColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                      child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(item.designCode),
                          Spacer(),
                          Text(item.tagPrice > 0 ? '\$${formatterint.format(
                              item.tagPrice)}' : 'Wt.: ${formatter2dec.format(
                              item.grossWeight)}g'),
                        ],
                      ),
                    ),
                  )
              ),
              item.promotion != "" ? Positioned(
                left: 0.0,
                child: Container(
                  child: CustomPaint(
                    painter: ShapesPainter(),
//                      painter: DrawTriangle(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 9.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.rotate(angle: -pi / 4,
                            child: Wrap(
                                //runSpacing: 5.0,
                                //spacing: 5.0,
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                      width: 40,
                                      child: Text(item.promotion,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      )
                                  ),
                                ])
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(height: 1, width: 1,),
            ]
        )
    )
    );
  }

  Widget TopSellingListView(List<DesignCode> data) {
    return
      new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            TopSellingListitem(data[index]),
      );
  }

  Widget CategoryListitem(BuildContext context, Category dt, int index, int totindex) {
    int nindex = index;

    if (dt.categoryCode != null) {
      return Container(
        width: 110,
//        color: selectedColor,
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
                        if (index < totindex - 1 && index > 1) {
                          if(_selectedCategoryIndex<index)
                            nindex = index -1;
                          else
                            nindex = index;

                          _scrollControllerlist.scrollTo(
                              index: nindex, duration: Duration(seconds: 1));
                        }
                        _selectedCategoryIndex = index;
                        setState(() {
                        });
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
  Widget CategoryListView(List<Category> data) {
    return
      new ScrollablePositionedList.builder(
        itemScrollController: _scrollControllerlist,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            CategoryListitem(context, data[index], index, data.length),
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
      child: Center(
        child: Text('JEMiSys eShop',
            style: GoogleFonts.oswald(
              textStyle: TextStyle(color: Colors.white, fontSize: 34,),
            ),
            //style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.normal,)
        ),
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
    if (kIsWeb && hideTitleMessage)
      p = 45.0;
    else if (kIsWeb && !hideTitleMessage)
      p = 75.0;
    else if (!kIsWeb && hideTitleMessage)
      p = 70.0;
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    double topp = positionRed.dy+30;
//    double rightp = positionRed.dx;
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
                                hideGoldRate = true;
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
    _tabController = new TabController(vsync: this, length: hMenuCount,);
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
    if(hideGoldRate == false)
      Future.delayed(Duration.zero, () => showGoldRate());

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    /*animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });*/

    controller.forward();

//    return Container(
//        color: Colors.white,
//        child: FadeTransition(
//            opacity: animation,
//            child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children:[
//                  Icon(Icons.check, size: 100.0,color: Colors.green,),
//                ]
//            )
//        )
//    );

  }
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
//    double screenheight = screenSize.height;
//    if (!kIsWeb) screenheight = screenSize.height - 24;
    int itemCount = GridItemCount(screenSize.width);
    double itemheight = GridItemHeight(screenSize.height, screenSize.width);

    return DefaultTabController(
        length: hMenuCount,
        child: Scaffold(
      key: scaffoldKey,
//      appBar: pageAppBar(),
      drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
      body: SafeArea(
          child: Container(
              color: Colors.white,
              child: Scrollbar(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: titleMessage(), //CompanyLogo(),
                    ),
                    SliverToBoxAdapter(
                      child: titleBar(), //CompanyLogo(),
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
                            height: 37,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: listbgColor)
                                  ),
                                  //child: HorizontalMenu(menuitem, context),
                                  child:
                                  Stack(
                                      children: <Widget>[
                                        HorizontalMenuWedget(tabController: _tabController, key: null,),
//                                        Positioned(
//                                            right: 0.0,
//                                            key: _keyRed,
//                                            child: GestureDetector(
//                                              onTap: () {
//                                                showGoldRate();
//                                                setState(() {});
//                                              },
//                                              //child: Icon( Image.asset('assets/goldRate.png', height: 20,)),
////                                            child: Icon(Icons.close, color: primary1Color, size: 18,),
//                                              child: Padding(
//                                                padding: const EdgeInsets.only(
//                                                    top: 2.0),
//                                                child: Container(
//                                                    color: listLabelbgColor,
//                                                    child: Padding(
//                                                      padding: const EdgeInsets
//                                                          .all(2.0),
//                                                      child: Image.asset(
//                                                        'assets/goldRate.png',
//                                                        height: 17,),
//                                                    )),
//                                              ),
//                                            )),
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
                                      return CategoryListView(data);
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
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Text(_selCategory,
                                      style: TextStyle(
                                          color: Colors.white)),
                                ),
                                Spacer(),
                                IconButton(
                                    icon: new Image.asset(
                                      'assets/filter_icon.png', height: 20,),
                                    iconSize: 30,
                                    onPressed: () {
                                      print('filter');
                                    }
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                    //Design List
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemCount,
                        childAspectRatio: itemheight - 0.15,
                      ),
                      delegate: SliverChildListDelegate(
                        [
                          for(var i in selDesign)
                            DesignGridWidgets(i),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF9DB1C6)),
                                  color: Color(0xFF517295)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 0.0, 10.0),
                                child: Text('TOP SELLING PRODUCTS',
//                                  style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                    style: TextStyle(color: Colors.white, fontSize: 16)
                                ),
                              )
                          ),
                        )
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0),
                            child: Container(
                                height: screenSize.width / itemCount + 25,
                                color: Color(0xFFD6DFE4),
                                child: FutureBuilder<List<DesignCode>>(
                                  //future: _fetchData(),
                                  builder: (context, snapshot) {
                                    if (categoryList.length > 0) {
                                      List<DesignCode> data = topSelling;
                                      return TopSellingListView(data);
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
                    SliverToBoxAdapter(
                      child: SizedBox(height: 50,),
                    ),
                  ],
                ),
              )
          )
      ),
      floatingActionButton: new Container(
          height: 30,
          child: FloatingActionButton.extended(
            backgroundColor: listLabelbgColor,
            icon: Icon(Icons.arrow_drop_up,),
            onPressed: () {
              setState(() {
//              _messages.insert(0, new Text("message ${_messages.length}"));
              });
              _scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
            label: Text('Top'),
          )),
    )
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    // Create a rectangle with size and width same as the canvas
    //var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    paint.color = Color(0xFFF96013);
    // create a path
    var path = Path();
    path.lineTo(0, 90);
    path.lineTo(90, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
    paint.color = Colors.white;
    path = Path();
    path.lineTo(0, 25);
    path.lineTo(25, 0);
    path.close();
    canvas.drawPath(path, paint);
    // set the color property of the paint
    paint.color = Colors.deepOrange;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);
    // draw the circle with center having radius 75.0
//    canvas.drawCircle(center, 75.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

