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
import 'package:jemisyseshop/widget/goldRate.dart';

class CategoryScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Category',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: CategoryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CategoryPage extends StatefulWidget{
  @override
  _categoryPage createState() => _categoryPage();
}

class _categoryPage extends State<CategoryPage> with TickerProviderStateMixin {
  bool isLogin = false;
  String _selcategoryCode = '';
  String _selCountry = 'SG';
  int _selectedCategoryIndex = 0;
  final formatter2dec = new NumberFormat('##0.00', 'en_US');
  final formatterint = new NumberFormat('##0', 'en_US');
  AnimationController controller;
  Animation<double> animation;
  ItemScrollController _scrollControllerlist = ItemScrollController();
  TabController _tabController;
  GlobalKey _keyGoldRate = GlobalKey();
  GoldRateWedgit objGoldRate = new GoldRateWedgit();

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
                              key: _keyGoldRate,
                              icon: new Image.asset('assets/goldRate.png', height: 25,),
                              iconSize: 30,

                              onPressed: () {
                                objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate);
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

  Widget CategoryListitem(Category item) {
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
                  Padding(
                    padding: const EdgeInsets.only(left:20.0, right:20.0, bottom:25.0, top:10.0),
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
                              left: 10.0, right: 10.0, top: 8.0, bottom: 8.0),
                          child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Spacer(),
                              Text(item.description),
                              Spacer(),
                            ],
                          ),
                        ),
                      )
                  ),

                ]
            )
        )
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

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: hMenuCount,);
    _tabController.index = 1;
    getDefault();
    if (categoryList.length > 0) {
      _selcategoryCode = categoryList[0].categoryCode;

      getDesign();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
//    Future.delayed(Duration.zero, () => showGoldRate());

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
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
                                          ]
                                      )
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: SizedBox(height: 3,),
                        ),

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
                                        10.0, 8.0, 0.0, 8.0),
                                    child: Text('CATEGORY',
//                                      style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 18)),
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  )
                              ),
                            )
                        ),

                        SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: itemCount,
                            childAspectRatio: itemheight - 0.15,
                          ),
                          delegate: SliverChildListDelegate(
                            [
                              for(var i in categoryList)
                                CategoryListitem(i),
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
    path.lineTo(0, 85);
    path.lineTo(85, 0);
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

