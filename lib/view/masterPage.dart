
import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jemisyseshop/view/contactUs.dart';
import 'package:jemisyseshop/view/login.dart';
import 'package:jemisyseshop/view/productDetails.dart';
import 'package:jemisyseshop/view/productList.dart';
import 'package:jemisyseshop/view/profile.dart';
import 'package:jemisyseshop/view/registration.dart';
import 'package:jemisyseshop/widget/goldRate.dart';
import 'package:jemisyseshop/widget/productGridWidget.dart';
import 'package:jemisyseshop/widget/scrollingText.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import '../style.dart';

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
          Theme
              .of(context)
              .textTheme,
        ),
        primaryTextTheme:GoogleFonts.latoTextTheme(
          Theme
              .of(context)
              .textTheme,
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
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Group> groupdt = List<Group>();
  List<Product> productdt = List<Product>();
  List<Product> selProductlist = new List<Product>();
//  List<Product> productdetaildt = List<Product>();
  List<Product> mostPopularProductlist = new List<Product>();
  Group selDt = new Group();
  List<DefaultData> dDt = new List<DefaultData>();

  String _selgroup = 'RINGS';
  String _selCountry = 'SG';
  String _filter = "ALL", _filterType = "BYGROUP", _where;
  int _selectedCategoryIndex = 0;
  ScrollController _scrollController = new ScrollController();
  ItemScrollController _scrollControllerlist = ItemScrollController();
  TabController _tabController;
  TabController _tabControllerFilter;
  GoldRateWedgit objGoldRate = new GoldRateWedgit();

  GlobalKey _keyGoldRate = GlobalKey();
  GlobalKey _keyFiltermenu = GlobalKey();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Country sCountry;
  int menuSelected = 0;
  int submenuSelectedIndex = 0;

  CarouselController buttonCarouselController = CarouselController();

  Future<void> getDefault() async {
    var sitem = country.firstWhere((d) => d.shortCode == _selCountry);
    sCountry = sitem;

//    Dialogs.showLoadingDialog(context, _keyLoader);//invoking go
    await getDefaultData();
    await getGroup();
    await getProduct();
    await getMostPopular();
//    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge

    if(titMessage == "") hideTitleMessage = true;

    if(hideGoldRate == false){
      Timer(
        Duration(seconds: 1),showGoldRate,
      );
    }
    setState(() {
    });
  }
  Future<List<DefaultData>> getDefaultData() async {
    DefaultDataParam param = new DefaultDataParam();
    param.docType = "BANNER";
    param.mode = "ACTIVE";
    var dt = await dataService.GetDefaultData(param);
    dDt = dt;
    return dt;
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
    param.filterType = _filterType;
    param.filter = _filter;
    param.where = _where;

    var dt = await dataService.GetProduct(param);
    productdt = dt;
    selProductlist = dt;
    return dt;
  }
  Future<List<Product>> getProductDetail(String productType, String designCode, int version) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.designCode = designCode;
    param.version = version;
    param.where = _where;
    var dt = await dataService.GetProductDetails(param);
    setState(() {

    });
    return dt;
  }

  Future<List<Product>> getMostPopular() async {
    ProductParam param = new ProductParam();
    param.productType = "ALL";
    param.filterType = _filterType;
    param.filter = "TOP SELLERS";
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
  Future<void> _group_onTap(String productType, BuildContext context) async {
    Dialogs.showLoadingDialog(context, _keyLoader);//invoking go
    var productdetail = await getProductDetail(productType, "", 1);
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
    if (productdetail.length > 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListPage(productdt: productdetail, title: productType,),)
      );
    }
    else if (productdetail.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ProductDetailPage(product: productdetail[0],
                title: productdetail[0].designCode,),)
      );
    }
//    else {
//      Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) =>
//              ProductDetailPage(product: item,
//                title: item.designCode,),)
//      );
//    }
  }

  Widget BannerImage(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double _height = 70;
    print(screenWidth);
    if (screenWidth > 1600)
      _height = 400;
    else if (screenWidth >= 1300)
      _height = 300;
    else if (screenWidth >= 1000)
      _height = 400;
    else if (screenWidth >= 700)
      _height = 300;
    else if (screenWidth >= 500)
      _height = 200;
    else if (screenWidth >= 400)
      _height = 120;

    if (dDt.length > 0) {
      return new Container(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height: _height,
            aspectRatio: 16/9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlayInterval: Duration(seconds: 3),
            //autoPlayAnimationDuration: Duration(milliseconds: 0),
            //autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
//            onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: dDt.map((item) =>
              Container(
                child: Center(
                    child: Image.network(item.imageFileName, fit: BoxFit.cover,
                      width: screenWidth - 30,)
                ),
              )
          ).toList(),
        ),
      );
    }
    else {
      return new Container(
      );
    }
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
                  Center(
                    child: Container(
                      height: 20,
                      child: ScrollingText(text: titMessage,
                          textStyle: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          hideTitleMessage = true;
                          setState(() { });
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
                                  Text(item.tagPrice > 0 ? '$currencysymbol${formatterint.format(
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
                                  Text('$currencysymbol${formatterint.format(
                                      item.promotionPrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                      : Text(item.tagPrice > 0 ? '$currencysymbol${formatterint.format(
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
    return new ScrollablePositionedList.builder(
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
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFe2e8ec),
                width: 1,
              ),
              //borderRadius: BorderRadius.circular(12),
            ),
//            shape: RoundedRectangleBorder(
//              side: BorderSide(
//                color: listbgColor,
//                width: 1.0,
//              ),
//            ),
            child: GestureDetector(
                onTap: (){
                  _group_onTap(item.groupName, context);
                },
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
            ))
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
            style: TextStyle(color: Colors.black),
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
      'NEW ARRIVAL',
      'SALE',
      'TOP SELLERS',
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
                  color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal ),
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
                  ProductGridWidgetHome(productType: "", item: i,),
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
                        child: Text('TOP SELLERS',
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
                  ProductGridWidgetHome(productType: "", item: i,),
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
  void showGoldRate(){
    Future.delayed(Duration.zero, () => objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate));
  }

  @override
  void initState() {
    super.initState();
    menuSelected = widget.currentIndex;

    _tabController = new TabController(vsync: this, length: hMenuCount,);
    _tabControllerFilter = new TabController(vsync: this, length: fMenuCount,);

    getDefault();

    //    WidgetsBinding.instance.addPostFrameCallback((_) {
//      images.forEach((imageUrl) {
//        precacheImage(NetworkImage(imageUrl), context);
//      });
//    });



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
                    titMessage != "" ?  titleMessage() : Container(),
                    titleBar(context, scaffoldKey, _keyGoldRate),

                    mainContainer(itemCount, itemheight, screenSize.width),
                  ],
                )

          )
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            SizedBox(
               width: 50.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                      child: Icon(
                        Icons.home,
                        color: Colors.grey,
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            color: Color(0xFF656665),
                            fontSize: 9
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  menuSelected = 0;
                  _tabControllerFilter.index = 0;
                  _tabController.index = 0;
                  _filter="ALL";
                  await getProduct();
                  _scrollController.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                  setState(() {

                  });
                },
              ),
            ),
            SizedBox(
              width: 65.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                      child: Container(
                        width: 33,
                        height: 24,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 1,
                              left: 1,
                              child: Icon(
                                Icons.call,
                                color: Colors.grey,
                                size: 20.0,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 1,
                              child: Icon(
                                Icons.message,
                                color: Colors.grey,
                                size: 14.0,
                              ),
                            )
                          ],
                        ),
                      ),

                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Contact Us",
                        style: TextStyle(
                            color: Color(0xFF656665),
                            fontSize: 9
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => ContactUsPage(),));
                },
              ),
            ),
            SizedBox(
               width: 70.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                      child: Icon(
                        Icons.home,
                        color: Colors.grey,
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Home Try-On",
                        style: TextStyle(
                            color: Color(0xFF656665),
                            fontSize: 9
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _group_onTap("Home Try-On", context);
                },
              ),
            ),
            SizedBox(
               width: 50.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(userID==""?
                        "Login":"Account",
                        style: TextStyle(
                            color: Color(0xFF656665),
                            fontSize: 9
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  if(userID=="")
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => LoginPage()),);
                    }
                   else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => ProfilePage()),);
                },
              ),
            ),
            SizedBox(
              width: 50.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.grey,
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "More",
                        style: TextStyle(
                            color: Color(0xFF656665),
                            fontSize: 9
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
          ],
        ),
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

