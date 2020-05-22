
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/main.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/model/tempData.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jemisyseshop/view/category.dart';
import 'package:jemisyseshop/widget/goldRate.dart';

import '../style.dart';
import 'home.dart';
class MasterScreen extends StatelessWidget {
  // This widget is the root of your application.
  final int currentIndex;
  MasterScreen({Key key, this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MasterPage(currentIndex: currentIndex,key: null,),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MasterPage extends StatefulWidget{
  final int currentIndex;
  MasterPage({Key key, this.currentIndex}) : super(key: key);

  @override
  _masterPage createState() => _masterPage();
}

class _masterPage extends State<MasterPage> with TickerProviderStateMixin {
  DataService dataService = DataService();
  List<Group> groupdt = List<Group>();
  List<Product> productdt = List<Product>();
  List<Product> selProductlist = new List<Product>();
  List<Product> mostPopularProductlist = new List<Product>();
  Group selDt = new Group();

  bool isLogin = false;
  String _selgroup = 'RINGS';
  String _selCountry = 'SG';
  String _filter = "ALL", _where;
  int _selectedCategoryIndex = 0;
  final formatter2dec = new NumberFormat('##0.00', 'en_US');
  final formatterint = new NumberFormat('##0', 'en_US');
  AnimationController controller;
  Animation<double> animation;
  ScrollController _scrollController = new ScrollController();
  ItemScrollController _scrollControllerlist = ItemScrollController();
  TabController _tabController;
  TabController _tabControllerFilter;
  GlobalKey _keyGoldRate = GlobalKey();
  GlobalKey _keyFiltermenu = GlobalKey();
  GoldRateWedgit objGoldRate = new GoldRateWedgit();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Country sCountry;
  int menuSelected = 0;
  int submenuSelectedIndex = 0;
  Future<void> getDefault() async {
    var sitem = country.firstWhere((d) => d.shortCode == _selCountry);
    sCountry = sitem;

    await getGroup();
    await getProduct();
    await getMostPopular();
    setState(() {
    });
  }
  Future<List<Group>> getGroup() async {
    var dt = await dataService.GetGroup();
    groupdt = dt;
    if(dt.length>0)
      _selgroup = dt[0].groupName;
    return dt;
  }
  Future<List<Product>> getProduct() async {
    ProductParam param = new ProductParam();
    param.productType = _selgroup;
    param.filter = _filter;
    param.where = _where;
    var dt = await dataService.GetProduct(param);
    productdt = dt;
    selProductlist = dt;
    return dt;
  }
  Future<List<Product>> getMostPopular() async {
    ProductParam param = new ProductParam();
    param.productType = "ALL";
    param.filter = "MOST POPULAR";
    param.where = "";
    var dt = await dataService.GetProduct(param);
    mostPopularProductlist = dt;
    return dt;
  }
  void getSelProduct() {
    var sitem = productdt.where((d) => d.groupName == _selgroup)
        .toList();
    selProductlist = new List<Product>();
    selProductlist = sitem;
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

  Widget DesignGridWidgets(Product item) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: listbgColor,
            width: 1.0,
          ),
        ),
        child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,top:10.0, right:20.0, bottom:5),
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: Image(
                          image: CachedNetworkImageProvider(
                            item.imageFile1,
                          ),
                          fit: BoxFit.fitHeight,
                        ),
//                  child: Image.network(
//                    item.imageUrl, fit: BoxFit.fitHeight,),
                      ),
                    ),
                  ),
                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
//                    height: 100,
                        color: listbgColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  SizedBox(child: Text('')),
                                  Spacer(),
                                  item.listingPrice > 0 && item.discountPercentage != 0 ?
                                  Text(item.listingPrice > 0 ? '\$${formatterint.format(
                                      item.listingPrice)}' : '${formatter2dec.format(
                                      item.weightFrom)}g',
                                      style: TextStyle(decoration: TextDecoration.lineThrough))
                                      : Text(item.weightFrom > 0 ? '${formatter2dec.format(
                                      item.weightFrom)} -' : ''),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text(item.designCode),
                                  Spacer(),
                                  item.listingPrice > 0 && item.discountPercentage > 0 ?
                                  Text('\$${formatterint.format(
                                      item.onlinePrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                      : Text(item.listingPrice > 0 ? '\$${formatterint.format(
                                      item.listingPrice)}' : 'Wt.: ${formatter2dec.format(
                                      item.weightTo)}g'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),
              item.discountPercentage > 0 ? Positioned(
                left: 0.0,
                child: Container(
                  child: CustomPaint(
                    painter: ShapesPainter(),
//                      painter: DrawTriangle(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.rotate(angle: -pi / 4,
                            child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                      width: 40,
                                      child: Text("${formatterint.format(item.discountPercentage)}% OFF",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
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
                              left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  SizedBox(child: Text('')),
                                  Spacer(),
                                  item.tagPrice > 0 && item.promotionPrice != 0 ?
                                  Text(item.tagPrice > 0 ? '\$${formatterint.format(
                                      item.tagPrice)}' : '${formatter2dec.format(
                                      item.grossWeight)}g',
                                      style: TextStyle(decoration: TextDecoration.lineThrough))
                                      : Text(item.goldWeight2 > 0 ? '${formatter2dec.format(
                                      item.goldWeight2)} -' : ''),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text(item.designCode),
                                  Spacer(),
                                  item.tagPrice > 0 && item.promotionPrice > 0 ?
                                  Text('\$${formatterint.format(
                                      item.promotionPrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                      : Text(item.tagPrice > 0 ? '\$${formatterint.format(
                                      item.tagPrice)}' : 'Wt.: ${formatter2dec.format(
                                      item.grossWeight)}g'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  item.discountCode != "" ? Positioned(
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
                                          child: Text(item.discountCode,
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

  Widget CategoryListitem(BuildContext context, Group dt, int index, int totindex) {
    int nindex = index;

    if (dt.groupName != null) {
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
                      onTap: () async {
                        _selgroup = dt.groupName;
                        _filter = "ALL";
                        _tabControllerFilter.index = 0;
                        await getProduct();
                        //getSelProduct();
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
                            dt.imageFileName,
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
                      Text('${dt.groupName}',
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
  Widget CategoryListView(List<Group> data) {
    return
      new ScrollablePositionedList.builder(
        itemScrollController: _scrollControllerlist,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            CategoryListitem(context, data[index], index, data.length),
      );
  }

  Widget CategoryGriditem(Group item) {
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
                          item.imageFileName,
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
                            children: [
                              Spacer(),
                              Text(item.groupName),
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
            textStyle: TextStyle(color: Colors.white, fontSize: 31, letterSpacing: 1.5),
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
  Widget HorizontalMenuHomeWedget(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return new TabBar(
      isScrollable: true,
      controller: _tabController, indicatorColor: listLabelbgColor, tabs: [
      for(var i in hitem)
        Tab(
          child: Text(
            i,
            style: TextStyle(fontFamily: "BarlowBold", color: Colors.black),
          ),
        ),
    ],
      onTap: (index) async {
        menuSelected = index;
        if(index == 0){
          _tabControllerFilter.index = 0;
          _filter="ALL";
          await getProduct();
        }

        setState(() {

        });
      },
    );
  }
  Widget subMenu(){
    List<String> smitem = [
      'ALL',
      'LATEST',
      'SALE',
      'MOST POPULAR',
    ];
    return new TabBar(
      isScrollable: true,
      controller: _tabControllerFilter,
      indicatorColor: listLabelbgColor,
      tabs: [
        for(var i in smitem)
          Tab(
            child: Text(
              i,
              style: TextStyle(
                  fontFamily: "BarlowBold", color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal ),
            ),
          ),
      ],
      labelPadding: EdgeInsets.only(left: 10, right:10),
//      indicatorWeight: 1.0,
      onTap: (index) async {
        _filter = smitem[index];
        await getProduct();
        setState(() {
        });
      },
    );
  }

  Widget mainContainer(int itemCount, double itemheight, double screenwidth){
    if(menuSelected == 0){
      return Flexible(
        child: homeWidget(itemCount, itemheight, screenwidth),
      );
    }
    else if(menuSelected == 1){
      return Flexible(
        child: categoryWidget(itemCount, itemheight, screenwidth),
      );
    }
    else if(menuSelected == 2){
      return Flexible(
        child: mostPopularWidget(itemCount, itemheight, screenwidth),
      );
    }
  }
  Widget homeWidget(int itemCount, double itemheight, double screenwidth) {
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          //Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: BannerImage(context),
            ),
          ),
          //Menu
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
                              HorizontalMenuHomeWedget(context),
                            ]
                        )
                    ),
                  ),
                ),

              ],
            ),
          ),
          //Group
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5.0),
                  child: Container(
                      height: 120,
                      color: listbgColor,
                      child: FutureBuilder<List<Group>>(
//                        future: getGroup(),
                        builder: (context, snapshot) {
                          if (groupdt.length > 0) {
                            List<Group> data = groupdt;
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
          //Group Title
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
                            10.0, 8.0, 0.0, 8.0),
                        child: Text(_selgroup,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 37, width: 35,
                        child: IconButton(
                            icon: new Image.asset(
                              'assets/filter_icon.png', height: 20,),
//                                                iconSize: 20,
                            onPressed: () {
                              print('filter');
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
          //Filer
          SliverToBoxAdapter(
            child: SizedBox(height: 3,),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 37,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                subMenu(),
                                //FilterMenuWedget(tabController: _tabControllerFilter, key: null,),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ]
              )
          ),
          //Design List
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: itemCount,
              childAspectRatio: itemheight - 0.25,
            ),
            delegate: SliverChildListDelegate(
              [
                for(var i in selProductlist)
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
                      child: Text('COMING SOON',
//                                  style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 16)),
                          style: TextStyle(color: Colors.white, fontSize: 16)
                      ),
                    )
                ),
              )
          ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 150,
                  ),
                ),
          //Coming Soon Data
//          SliverList(
//            delegate: SliverChildListDelegate(
//              [
//                Padding(
//                  padding: const EdgeInsets.only(
//                      left: 5.0, right: 5.0),
//                  child: Container(
//                      height: screenwidth / itemCount + 75,
//                      color: Color(0xFFD6DFE4),
//                      child: FutureBuilder<List<DesignCode>>(
//                        //future: _fetchData(),
//                        builder: (context, snapshot) {
//                          if (topSelling.length > 0) {
//                            List<DesignCode> data = topSelling;
//                            return TopSellingListView(data);
//                          } else if (snapshot.hasError) {
//                            return Text("${snapshot.error}");
//                          }
//                          return Container();
//                        },
//                      )
//                  ),
//                ),
//              ],
//            ),
//          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 50,),
          ),
        ],
      ),
    );
  }
  Widget categoryWidget(int itemCount, double itemheight, double screenwidth) {
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
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
                              HorizontalMenuHomeWedget(context),
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
                for(var i in groupdt)
                  CategoryGriditem(i),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 50,),
          ),
        ],
      ),
    );
  }
  Widget mostPopularWidget(int itemCount, double itemheight, double screenwidth) {
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
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
                              HorizontalMenuHomeWedget(context),
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            10.0, 8.0, 0.0, 8.0),
                        child: Text('MOST POPULAR',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 37, width: 35,
                        child: IconButton(
                            icon: new Image.asset(
                              'assets/filter_icon.png', height: 20,),
//                                                iconSize: 20,
                            onPressed: () {
                              print('filter');
                            }
                        ),
                      ),
                    ],
                  ),
//                                  child: Padding(
//                                    padding: const EdgeInsets.fromLTRB(
//                                        10.0, 10.0, 0.0, 10.0),
//                                    child: Text('TOP SELLING PRODUCTS',
////                                      style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 16)),
//                                    style: TextStyle(color: Colors.white, fontSize: 16)
//                                    ),
//                                  )
                ),
              )
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: itemCount,
              childAspectRatio: itemheight - 0.25,
            ),
            delegate: SliverChildListDelegate(
              [
                for(var i in mostPopularProductlist)
                  DesignGridWidgets(i),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 50,),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    menuSelected = widget.currentIndex;

    _tabController = new TabController(vsync: this, length: hMenuCount,);
    _tabControllerFilter = new TabController(vsync: this, length: fMenuCount,);

    getDefault();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
    if(hideGoldRate == false)
      Future.delayed(Duration.zero, () => objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate));

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
                child: Column(
                  children: [
                    titleMessage(),
                    titleBar(),

                    mainContainer(itemCount, itemheight, screenSize.width),
                  ],
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
      path.lineTo(0, 80);
      path.lineTo(80, 0);
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
