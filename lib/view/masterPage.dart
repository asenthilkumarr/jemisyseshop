import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/utilities/videoCall.dart';
import 'package:jemisyseshop/view/cart.dart';
import 'package:jemisyseshop/view/contactUs.dart';
import 'package:jemisyseshop/view/filter.dart';
import 'package:jemisyseshop/view/login.dart';
import 'package:jemisyseshop/view/productDetails.dart';
import 'package:jemisyseshop/view/productList.dart';
import 'package:jemisyseshop/view/profile.dart';
import 'package:jemisyseshop/view/voucherDetail.dart';
import 'package:jemisyseshop/widget/cartNotification.dart';
import 'package:jemisyseshop/widget/goldRate.dart';
import 'package:jemisyseshop/widget/productGridWidget.dart';
import 'package:jemisyseshop/widget/scrollingText.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jemisyseshop/utilities/notificationHelper.dart';

import 'Message.dart';

class MasterScreen extends StatelessWidget {

  // This widget is the root of your application.
  final int currentIndex;
  MasterScreen({Key key, this.currentIndex}) : super(key: key);
  static ThemeData themeData(BuildContext context){
    return ThemeData(
      brightness: brightness1,
      primaryColor: primary1Color,
      accentColor: accent1Color,
      textTheme: fontName.toUpperCase() == "LATO" ? GoogleFonts.latoTextTheme(
        Theme
            .of(context)
            .textTheme,
      ) : fontName.toUpperCase() == "POPPINS" ? GoogleFonts.poppinsTextTheme(
        Theme
            .of(context)
            .textTheme,
      ) : fontName.toUpperCase() == "ROBOTO" ? GoogleFonts.robotoTextTheme(
        Theme
            .of(context)
            .textTheme,
      ) : TextTheme(),
      primaryTextTheme:fontName.toUpperCase() == "LOTO" ? GoogleFonts.latoTextTheme(
        Theme
            .of(context)
            .textTheme,
      ) : fontName.toUpperCase() == "POPPINS" ?  GoogleFonts.poppinsTextTheme(
        Theme
            .of(context)
            .textTheme,
      ) : fontName.toUpperCase() == "ROBOTO" ?  GoogleFonts.robotoTextTheme(
        Theme
            .of(context)
            .textTheme,
      ) : TextTheme(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: themeData(context),
      home: MasterPage(currentIndex: currentIndex,key: null,),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MasterPage extends StatefulWidget{
  static const String route = '/';
  final int currentIndex;
  MasterPage({Key key, this.currentIndex}) : super(key: key);

  @override
  _masterPage createState() => _masterPage();
}

class _masterPage extends State<MasterPage> with TickerProviderStateMixin {
  DataService dataService = DataService();
  Commonfn cfobj = Commonfn();
  GoldRateWedgit objGoldRate = new GoldRateWedgit();
  CartNotification objCartNote = new CartNotification();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _formKeyReset = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyGoldRate = GlobalKey();

  List<Group> groupdt = List<Group>();
  List<Product> productdt = List<Product>();
  List<Product> selProductlist = new List<Product>();
  List<Product> fselProductlist = new List<Product>();
  List<Product> topSellersProductlist = new List<Product>();
  List<Product> ftopSellersProductlist = new List<Product>();
  Group selDt = new Group();
  List<DefaultData> dDt = new List<DefaultData>();

  String _selgroup = 'RINGS';
  String _selCountry = 'SG';
  String _filter = "ALL",
      _filterType = "BYGROUP",
      _where;
  int _selectedCategoryIndex = 0;
  ScrollController _scrollController = new ScrollController();
  ItemScrollController _scrollControllerlist = ItemScrollController();
  ItemScrollController _scrollControllerCartlist = ItemScrollController();
  TabController _tabController;
  TabController _tabControllerFilter;

  //Country2 sCountry2;
  int menuSelected = 0;
  int submenuSelectedIndex = 0;
  bool showCartNotification = true;
  CarouselController buttonCarouselController = CarouselController();

  static const snackBarDuration = Duration(seconds: 3);
  DateTime backButtonPressTime;
  BuildContext dialogContext;

  Flushbar flush;
  bool _wasButtonClicked;

  static Future<dynamic> _scheduleNotification(Map<String, dynamic> message) async {
    final data = message['data'];

    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await initNotifications(flutterLocalNotificationsPlugin);
    requestIOSPermissions(flutterLocalNotificationsPlugin);

    DateTime scheduledTime = DateTime.parse(data['scheduledTime']);
    //var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var scheduledNotificationDateTime = new DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day,
        scheduledTime.hour, scheduledTime.minute);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "4",
      'Reminder notifications',
      'Remember about it',
      icon: 'app_icon',
      enableVibration: false,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        data['scheduledTitle'],
        data['scheduledBody'],
        scheduledNotificationDateTime,
        platformChannelSpecifics);

    return Future<void>.value();
  }

  void checkLogin() async {
    loginMethod = await Commonfn.getLoginMethod();
    Customer param = Customer();
    param.eMail = await Commonfn.getUserID();
    bool tisLogin=false;
    if(loginMethod == "L"){
      param.password = await Commonfn.getPassword();
      tisLogin = await Commonfn.getLoginStatus();
    }
    else if(loginMethod == "G" || loginMethod == "F"){
      tisLogin = true;
    }

    if (tisLogin != null && tisLogin == true) {
      var dt = await dataService.getCustomer(param);
      if (dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
//        password = await Commonfn.getPassword();
        userName = dt.firstName.toString().toUpperCase();
        isLogin = true;
        var cartdt = await dataService.getCart(userID, "S");
        cartCount = cartdt.length;
        if (cartdt.length > 0) LoadCart(cartdt);
        setState(() {

        });
      }
    }
  }
  List<Color> _colors = [webLeftContainerColor, Colors.white];
  List<double> _stops = [0.0, 0.7];
  void LoadCart(List<Cart> cartdt) {
    double itemWidth = 200;

    if (cartdt.length > 1)
      itemWidth = (screenWidth / 2) - 20;
    else
      itemWidth = screenWidth - 40;
    if (cartCount > 0) {
      showCartNotification = true;
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: MaterialLocalizations
              .of(context)
              .modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),

          pageBuilder: (context,
              Animation animation,
              Animation secondaryAnimation) {
//                dialogContext context;
            return Material(
              type: MaterialType.transparency,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
//                      color: Colors.transparent,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _colors,
                            stops: _stops,
                          )
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 250, maxWidth: screenWidth),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          //width: MediaQuery.of(context).size.width - 10,
                          height: 310,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Hello ${customerdata.firstName}",
                                        style: TextStyle(fontSize: 16,
                                            fontStyle: FontStyle.italic),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Your cart is waiting",
                                        style: TextStyle(fontSize: 18,
                                            color: Color(0xFF80CBC4)),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 170,
                                    child: ScrollablePositionedList.builder(
                                      itemScrollController: _scrollControllerCartlist,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cartdt.length,
                                      itemBuilder: (BuildContext context,
                                          int index) =>
                                          Container(
                                            width: itemWidth,
                                            child: Container(
                                              height: 150,
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          _sizedContainer(
                                                            Image(
                                                              image: CachedNetworkImageProvider(
                                                                cartdt[index]
                                                                    .imageFileName,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        width: (screenWidth /
                                                            1) - 50,
//                                            color: listLabelbgColor,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            SizedBox(height: 2,),
                                                            Text(
                                                                "$currencysymbol${formatterint
                                                                    .format(
                                                                    cartdt[index]
                                                                        .totalPrice)}",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                            Center(child: Text(
                                                              '${cartdt[index]
                                                                  .description}',
                                                              softWrap: true,)),
                                                            SizedBox(height: 2,),
                                                            //Spacer(),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 40,
                                    child: RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            10.0),
                                        side: BorderSide(color: Color(0xFF88A9BB)),
                                      ),
                                      color: Color(0xFF517295),
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0, 0, 50, 0),
                                      child: Text(
                                        "GO TO CART",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              CartPage(
                                                masterScreenFormKey: _formKeyReset,
                                                pSource: "S",),));
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8,)
                                ],
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
                                        child: Icon(
                                            Icons.close, color: Colors.white),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
//                      color: Colors.transparent,
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0, 1],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.white,
                            webRightContainerColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  Future<void> initPlatformState() async {
    String tudid = "";
    try {
      tudid = await FlutterUdid.udid;
      udid = tudid;
    } on PlatformException {
      tudid = 'Failed to get UDID.';
    }
  }

  Future<void> getDefault() async {
    await getDefaultData();
    setState(() {});

    if (titMessage == "") hideTitleMessage = true;
    if (hideGoldRate == false) {
      Timer(
        Duration(seconds: 1), showGoldRate,
      );
    }

    await getGroup();
    setState(() {});
    await getProduct();
    setState(() {});
    await getMostPopular();
    setState(() {});
    await checkLogin();
    if (!kIsWeb) {
      await initPlatformState();
      setState(() {});
    }
  }

  Future<List<DefaultData>> getDefaultData() async {
    DefaultDataParam param = new DefaultDataParam();
    param.docType = "BANNER";
    param.mode = "ACTIVE";
    var dt = await dataService.getDefaultData(param);
    dDt = dt;
    setState(() {

    });
    return dt;
  }

  Future<List<Group>> getGroup() async {
    var dt = await dataService.getGroup();
    groupdt = dt;
    if (dt.length > 0)
      _selgroup = dt[0].groupName;
    return dt;
  }

  Future<List<Product>> getProduct() async {
    ProductParam param = new ProductParam();
    param.productType = _selgroup;
    param.filterType = _filterType;
    param.filter = _filter;
    param.where = _where;

    var dt = await dataService.getProduct(param);
    productdt = dt;
    selProductlist = dt;
    fselProductlist = dt;

    return dt;
  }

  Future<List<Product>> getProductDetail(String productType, String designCode,
      int version) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.designCode = designCode;
    param.version = version;
    param.where = _where;
    var dt = await dataService.getProductDetails(param);
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
    var dt = await dataService.getProduct(param);
    topSellersProductlist = dt;
    ftopSellersProductlist = dt;
    return dt;
  }

  void getSelProduct() {
    var sitem = productdt.where((d) => d.groupName == _selgroup)
        .toList();
    selProductlist = new List<Product>();
    fselProductlist = new List<Product>();
    selProductlist = sitem;
    fselProductlist = sitem;
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, kIsWeb ? 55 : 80, 50, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('CURRENCY'), value: 'CURRENCY'),
        PopupMenuItem<String>(
            child: Row(
              children: [
//                Image.asset(
//                  sCountry.imageUrl, height: 20, fit: BoxFit.fitHeight,),
                SizedBox(width: 10,),
//                Text(sCountry.currency)
              ],
            ))
      ],
      elevation: 8.0,
    );
  }

  Future<void> _group_onTap(String productType, BuildContext context) async {
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    var productdetail = await getProductDetail(productType, "", 1);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
        .pop(); //close the dialoge
    if (productdetail.length > 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductListPage(productdt: productdetail, title: productType,),)
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

  void Filter_Click(String source) async {
    if (source == "HOME") {
      List<Product> gFilter = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => FilterPage(productdt: selProductlist,),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 300),
        ),
      );

      if (gFilter != null) {
        fselProductlist = new List<Product>();
        fselProductlist = gFilter;
        setState(() {

        });
      }
    }
    else {
      List<Product> gFilter = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>
              FilterPage(productdt: topSellersProductlist,),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 300),
        ),
      );

      if (gFilter != null) {
        ftopSellersProductlist = new List<Product>();
        ftopSellersProductlist = gFilter;
        setState(() {

        });
      }
    }
  }

  Widget BannerImage(BuildContext context) {

    double _height = 70;

    if (screenWidth > 1600)
      _height = 300;
    else if (screenWidth >= 1300)
      _height = 200;
    else if (screenWidth >= 1000)
      _height = 200;
    else if (screenWidth >= 700)
      _height = 200;
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
            aspectRatio: 16 / 9,
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
                    child: Image.network(item.imageFileName, fit: !kIsWeb ? BoxFit.cover : BoxFit.fill,
                      width: screenWidth - 30,
                    )
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
                          setState(() {});
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
//          IconButton(
//            icon: new Image.asset(sCountry.imageUrl),
//            iconSize: 20,
//            onPressed: () {
//              _showPopupMenu();
//            },
//          ),
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

  int GridItemCount(double tscreenwidth) {
    int itemCount = 0,
        a = 0;
    tscreenwidth = tscreenwidth - (tscreenwidth-screenWidth);
    if (tscreenwidth <= 550)
      itemCount = 2;
    else if (tscreenwidth <= 750)
      itemCount = 3;
    else if (tscreenwidth <= 850)
      itemCount = 4;
    else if (tscreenwidth <= 1050)
      itemCount = 5;
    else if (tscreenwidth <= 1200)
      itemCount = 6;
    else if (tscreenwidth <= 1450)
      itemCount = 7;
    else if (tscreenwidth <= 1600)
      itemCount = 8;
    else
      itemCount = 10;

    return itemCount;
  }

  Widget TopSellingListitem(DesignCode item) {

    int count = GridItemCount(screenWidth);
    return Container(
        width: screenWidth / count - 4,
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
                                  item.tagPrice > 0 && item.promotionPrice != 0
                                      ?
                                  Text(item.tagPrice > 0
                                      ? '$currencysymbol${formatterint.format(
                                      item.tagPrice)}'
                                      : '${formatter2dec.format(
                                      item.grossWeight)}g',
                                      style: TextStyle(
                                          decoration: TextDecoration
                                              .lineThrough))
                                      : Text(item.goldWeight2 > 0
                                      ? '${formatter2dec.format(
                                      item.goldWeight2)} -'
                                      : ''),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text(item.designCode),
                                  Spacer(),
                                  item.tagPrice > 0 && item.promotionPrice > 0 ?
                                  Text('$currencysymbol${formatterint.format(
                                      item.promotionPrice)}', style: TextStyle(
                                      fontWeight: FontWeight.bold))
                                      : Text(item.tagPrice > 0
                                      ? '$currencysymbol${formatterint.format(
                                      item.tagPrice)}'
                                      : 'Wt.: ${formatter2dec.format(
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
                                                fontSize: 13,
                                                color: Colors.white),
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

  Widget CategoryListitem(BuildContext context, Group dt, int index,
      int totindex) {
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
                          if (_selectedCategoryIndex < index)
                            nindex = index - 1;
                          else
                            nindex = index;

                          _scrollControllerlist.scrollTo(
                              index: nindex, duration: Duration(seconds: 1));
                        }
                        _selectedCategoryIndex = index;

                        setState(() {});
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
    int count = GridItemCount(screenWidth);
    return Container(
        width: screenWidth / count - 4,
        //color: Colors.grey,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFe2e8ec),//e2e8ec
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
                onTap: () {
                  _group_onTap(item.groupName, context);
                },
                child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 25.0, top: 10.0),
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
                                  left: 10.0,
                                  right: 10.0,
                                  top: 8.0,
                                  bottom: 8.0),
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
    return new TabBar(
      isScrollable: true,
      controller: _tabController,
      indicatorColor: listLabelbgColor,
      tabs: [
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
        if (index == 0) {
          _tabControllerFilter.index = 0;
          _filter = "ALL";
//          Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
          await getProduct();
//          Navigator.of(_keyLoader.currentContext, rootNavigator: true)\.pop(); //close the dialoge
        }

        setState(() {

        });
      },
    );
  }

  Widget subMenu() {
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
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
          ),
      ],
      labelPadding: EdgeInsets.only(left: 10, right: 10),
//      indicatorWeight: 1.0,
      onTap: (index) async {
        _filter = smitem[index];
//        Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
        await getProduct();
//        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop(); //close the dialoge
        setState(() {});
      },
    );
  }

  Widget mainContainer(int itemCount, double itemheight, double screenwidth) {
    if (menuSelected == 0) {
      return Flexible(
        child: Row(
//          mainAxisSize: MainAxisSize.max,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          mainAxisAlignment: MainAxisAlignment.center,
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
              //Flexible(
                child: homeWidget(itemCount, itemheight, screenwidth),
              ),
            ),
            Flexible(
              child: Container(
                color: webRightContainerColor,
              ),
            ),
          ],
        ),
      );
    }
    else if (menuSelected == 1) {
      return Flexible(
        child: Row(
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
                  child: categoryWidget(itemCount, itemheight, screenwidth)),
            ),
            Flexible(
              child: Container(
                color: webRightContainerColor,
              ),
            ),
          ],
        ),
      );
    }
    else if (menuSelected == 2) {
      return Flexible(
        child: Row(
          children: [
            kIsWeb ? Expanded(
              child: Container(
                color: webLeftContainerColor,
              ),
            ) : Container(),
            Container(
                constraints: BoxConstraints(minWidth: 250, maxWidth: screenWidth),
                child: topSellersWidget(itemCount, itemheight, screenwidth)),
            kIsWeb ? Expanded(
              child: Container(
                color: webRightContainerColor,
              ),
            ) : Container(),
          ],
        ),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 37, width: 35,
                        child: IconButton(
                            icon: new Image.asset(
                              'assets/filter_icon.png', height: 20,),
                            onPressed: () {
                              Filter_Click("HOME");
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
                for(var i in fselProductlist)
                  ProductGridWidgetHome(productType: "",
                    item: i,
                    masterScreenFormKey: _formKeyReset,),
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

  Widget topSellersWidget(int itemCount, double itemheight,
      double screenwidth) {
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 37, width: 35,
                        child: IconButton(
                            icon: new Image.asset(
                              'assets/filter_icon.png', height: 20,),
//                                                iconSize: 20,
                            onPressed: () {
                              Filter_Click("TOPSELLERS");
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
                for(var i in ftopSellersProductlist)
                  ProductGridWidgetHome(productType: "",
                    item: i,
                    masterScreenFormKey: _formKeyReset,),
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

  void showGoldRate() {
    Future.delayed(Duration.zero, () =>
        objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate));
  }

  void showInfoFlushbar(String msg) {
    Flushbar(
      margin: EdgeInsets.all(8),
      backgroundGradient: LinearGradient(
          colors: [Color(0xFF757575), Color(0xFF757575)]),
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: listbgColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)
      ],
      borderRadius: 8,
//      title: 'Failed to login!',
      message: '$msg',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.white,
      ),
      // leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 1),
    )
      ..show(context);
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      showInfoFlushbar("Press back again to exit");
      return false;
    }

    return true;
  }

  void firebaseMessagingConfigure() {
    var notification, notificationData;
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          notification = message['notification'];
          notificationData = message['data'] ?? message;
          String buttonTitle = "OK";
          if (notificationData['screen'] != null) {
            if (notificationData['screen'] == "videoCall")
              buttonTitle = "ACCEPT";
          }
          print('onMessage: $message');
          if (notificationData["isScheduled"] == "yes") {
            _scheduleNotification(message);
          }
          else {
            setState(() {
              flush = Flushbar<bool> (
                borderRadius: 15,
                title: notification['title'],
                message: notification['body'],
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                backgroundGradient: LinearGradient(colors: [Colors.teal, Colors.blueAccent],),
                backgroundColor: Colors.red,
                boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                isDismissible: false,
                //duration: Duration(seconds: 20 ),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                mainButton: FlatButton(
                  onPressed: () {
                    flush.dismiss(true);
                    if (notificationData['screen'] != null) {
                      _serialiseAndNavigate(message);
                    }
                  },
                  child: Text(
                    buttonTitle,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                showProgressIndicator: true,
                progressIndicatorBackgroundColor: Colors.blueGrey,
                titleText: Text(
                  notification['title'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.yellow, fontFamily: "ShadowsIntoLightTwo"),
                ),
                messageText: Text(
                  notification['body'],
                  style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
                ),
              )..show(context).then((result) {
                setState(() { // setState() is optional here
                  _wasButtonClicked = result;
                });
              });
            });
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
          _serialiseAndNavigate(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
          _serialiseAndNavigate(message);
        }
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'] ?? message;
    if (notificationData["isScheduled"] == "yes") {
      _scheduleNotification(message);
      Dialogs.AlertMessage(context, "Appointment confirmed and reminder added");
    }
    else if (notificationData['screen'] != null) {
      hideGoldRate = true;
      showCartNotification = false;
      // Navigate to the screen defined
      if (notificationData['screen'] == 'voucher') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VoucherDetailPage()),);
      }
      else if (notificationData['screen'] == 'videoCall') {
        onJoin(notificationData['channelName']);
      }
      // If there's no view it'll just open the app on the first view
    }
  }

  Future<void> onJoin(String channelName) async {
    await Commonfn.handleCameraAndMic();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: channelName,
          role: ClientRole.Broadcaster,
        ),),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      firebaseMessagingConfigure();
      var dt = dataService.FCM_RegisterToken("");
    }

    menuSelected = widget.currentIndex;

    _tabController = new TabController(vsync: this, length: hMenuCount,);
    _tabControllerFilter = new TabController(vsync: this, length: fMenuCount,);

    getDefault();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    screenWidth = screenSize.width;
    if(kIsWeb){
      screenWidth = cfobj.ScreenWidth(screenSize.width);
    }


    int itemCount = GridItemCount(screenWidth);
    double itemheight = GridItemHeight(screenSize.height, screenWidth);

    return MaterialApp(
      title: "Home",
      theme: MasterScreen.themeData(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        drawer: Container(
          width: 220,
            child: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin, masterScreenFormKey: _formKeyReset,)),
        body: SafeArea(
          child: WillPopScope(
              onWillPop: () => onWillPop(),
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      titMessage != "" ? titleMessage() : Container(),
                      titleBar(context, scaffoldKey, _keyGoldRate, _formKeyReset, primary1Color, Colors.white),

                      mainContainer(itemCount, itemheight, screenWidth),
                    ],
                  )

              )
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[
              SizedBox(
                width: 70.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
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
                          "Try @ Home",
                          style: TextStyle(
                              color: Color(0xFF656665),
                              fontSize: 8
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    _group_onTap("Home Try-On", context);
                  },
                ),
              ),
              SizedBox(
                width: 65.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
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
                              fontSize: 8
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
                width: 50.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                        child: Icon(
                          Icons.mail,
                          color: Colors.grey,
                          size: 24.0,
                        ),
                      ),
                      SizedBox(height: 0,),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "Inbox",
                          style: TextStyle(
                              color: Color(0xFF656665),
                              fontSize: 8
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (isLogin == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),);
                    }
                    else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagePage())
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: 50.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 24.0,
                        ),
                      ),
                      SizedBox(height: 0,),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(userID == "" ?
                        "Login" : "Account",
                          style: TextStyle(
                              color: Color(0xFF656665),
                              fontSize: 8
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    if (userID == "") {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(masterScreenFormKey: _formKeyReset,)),);
                      if (userID != null && userID != "") {
                        var cartdt = await dataService.getCart(userID, "S");
                        LoadCart(cartdt);
                      }
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
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
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
                              fontSize: 8
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
      ),
    );
  }
}

class MasterPage2 extends StatefulWidget{
  static const String route = '/';
  final int currentIndex;
  MasterPage2({Key key, this.currentIndex}) : super(key: key);
  @override
  _masterPage2 createState() => _masterPage2();
}
class _masterPage2 extends State<MasterPage2> with TickerProviderStateMixin {
  DataService dataService = DataService();
  Commonfn cfobj = Commonfn();
  GoldRateWedgit objGoldRate = new GoldRateWedgit();
  CartNotification objCartNote = new CartNotification();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _formKeyReset = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyGoldRate = GlobalKey();

  List<Group> groupdt = List<Group>();
  List<Product> productdt = List<Product>();
  List<Product> selProductlist = new List<Product>();
  List<Product> fselProductlist = new List<Product>();
  List<Product> topSellersProductlist = new List<Product>();
  List<Product> ftopSellersProductlist = new List<Product>();
  Group selDt = new Group();
  List<DefaultData> dDt = new List<DefaultData>();

  String _selgroup = 'RINGS';
  String _selCountry = 'SG';
  String _filter = "ALL",
      _filterType = "BYGROUP",
      _where;
  int _selectedCategoryIndex = 0;
  ScrollController _scrollController = new ScrollController();
  ItemScrollController _scrollControllerlist = ItemScrollController();
  ItemScrollController _scrollControllerCartlist = ItemScrollController();
  TabController _tabController;
  TabController _tabControllerFilter;

  int menuSelected = 0,
      _bannercurrent = 0;
  int submenuSelectedIndex = 0;
  bool showCartNotification = true;
  CarouselController buttonCarouselController = CarouselController();

  static const snackBarDuration = Duration(seconds: 3);
  DateTime backButtonPressTime;
  BuildContext dialogContext;

  Flushbar flush;
  bool _wasButtonClicked;
  final CarouselController _controller = CarouselController();
  Future<void> _launched;
  List<Color> _colors = [webLeftContainerColor, Colors.white];
  List<double> _stops = [0.0, 0.7];

  static Future<dynamic> _scheduleNotification(Map<String, dynamic> message) async {
    final data = message['data'];

    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await initNotifications(flutterLocalNotificationsPlugin);
    requestIOSPermissions(flutterLocalNotificationsPlugin);

    DateTime scheduledTime = DateTime.parse(data['scheduledTime']);
    //var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var scheduledNotificationDateTime = new DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day,
        scheduledTime.hour, scheduledTime.minute);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "4",
      'Reminder notifications',
      'Remember about it',
      icon: 'app_icon',
      enableVibration: false,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        data['scheduledTitle'],
        data['scheduledBody'],
        scheduledNotificationDateTime,
        platformChannelSpecifics);

    return Future<void>.value();
  }

  void checkLogin() async {
    loginMethod = await Commonfn.getLoginMethod();
    Customer param = Customer();
    param.eMail = await Commonfn.getUserID();
    bool tisLogin = false;
    if (loginMethod == "L") {
      param.password = await Commonfn.getPassword();
      tisLogin = await Commonfn.getLoginStatus();
    }
    else if (loginMethod == "G" || loginMethod == "F") {
      tisLogin = true;
    }

    if (tisLogin != null && tisLogin == true) {
      var dt = await dataService.getCustomer(param);
      if (dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
//        password = await Commonfn.getPassword();
        userName = dt.firstName.toString().toUpperCase();
        isLogin = true;
        var cartdt = await dataService.getCart(userID, "S");
        cartCount = cartdt.length;
        if (cartdt.length > 0) LoadCart(cartdt);
        setState(() {

        });
      }
    }
  }

  void LoadCart(List<Cart> cartdt) {
    double itemWidth = 200;

    if (cartdt.length > 1)
      itemWidth = (screenWidth / 2) - 20;
    else
      itemWidth = screenWidth - 40;
    if (cartCount > 0) {
      showCartNotification = true;
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: MaterialLocalizations
              .of(context)
              .modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),

          pageBuilder: (context,
              Animation animation,
              Animation secondaryAnimation) {
//                dialogContext context;
            return Material(
              type: MaterialType.transparency,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
//                      color: Colors.transparent,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _colors,
                            stops: _stops,
                          )
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minWidth: 250, maxWidth: screenWidth),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          //width: MediaQuery.of(context).size.width - 10,
                          height: 310,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Hello ${customerdata.firstName}",
                                        style: TextStyle(fontSize: 16,
                                            fontStyle: FontStyle.italic),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Your cart is waiting",
                                        style: TextStyle(fontSize: 18,
                                            color: Color(0xFF80CBC4)),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 170,
                                    child: ScrollablePositionedList.builder(
                                      itemScrollController: _scrollControllerCartlist,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cartdt.length,
                                      itemBuilder: (BuildContext context,
                                          int index) =>
                                          Container(
                                            width: itemWidth,
                                            child: Container(
                                              height: 150,
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          _sizedContainer(
                                                            Image(
                                                              image: CachedNetworkImageProvider(
                                                                cartdt[index]
                                                                    .imageFileName,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        width: (screenWidth /
                                                            1) - 50,
//                                            color: listLabelbgColor,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 2,),
                                                            Text(
                                                                "$currencysymbol${formatterint
                                                                    .format(
                                                                    cartdt[index]
                                                                        .totalPrice)}",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                            Center(child: Text(
                                                              '${cartdt[index]
                                                                  .description}',
                                                              softWrap: true,)),
                                                            SizedBox(
                                                              height: 2,),
                                                            //Spacer(),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 40,
                                    child: RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            10.0),
                                        side: BorderSide(
                                            color: Color(0xFF88A9BB)),
                                      ),
                                      color: Color(0xFF517295),
                                      padding: const EdgeInsets.fromLTRB(
                                          50.0, 0, 50, 0),
                                      child: Text(
                                        "GO TO CART",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                          builder: (context) =>
                                              CartPage(
                                                masterScreenFormKey: _formKeyReset,
                                                pSource: "S",),));
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8,)
                                ],
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
                                        child: Icon(
                                            Icons.close, color: Colors.white),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
//                      color: Colors.transparent,
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0, 1],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.white,
                            webRightContainerColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  Future<void> initPlatformState() async {
    String tudid = "";
    try {
      tudid = await FlutterUdid.udid;
      udid = tudid;
    } on PlatformException {
      tudid = 'Failed to get UDID.';
    }
  }

  Future<void> getDefault() async {
    await getDefaultData();
    setState(() {});

    if (titMessage == "") hideTitleMessage = true;
    if (hideGoldRate == false) {
      Timer(
        Duration(seconds: 1), showGoldRate,
      );
    }

    await getGroup();
    setState(() {});
    await getProduct();
    setState(() {});
    await getMostPopular();
    setState(() {});
    await checkLogin();
    if (!kIsWeb) {
      await initPlatformState();
      setState(() {});
    }
  }

  Future<List<DefaultData>> getDefaultData() async {
    DefaultDataParam param = new DefaultDataParam();
    param.docType = "BANNER";
    param.mode = "ACTIVE";
    var dt = await dataService.getDefaultData(param);
    dDt = dt;
    setState(() {

    });
    return dt;
  }

  Future<List<Group>> getGroup() async {
    var dt = await dataService.getGroup();
    groupdt = dt;
    if (dt.length > 0)
      _selgroup = dt[0].groupName;
    return dt;
  }

  Future<List<Product>> getProduct() async {
    ProductParam param = new ProductParam();
    param.productType = _selgroup;
    param.filterType = _filterType;
    param.filter = _filter;
    param.where = _where;

    var dt = await dataService.getProduct(param);
    productdt = dt;
    selProductlist = dt;
    fselProductlist = dt;

    return dt;
  }

  Future<List<Product>> getProductDetail(String productType, String designCode,
      int version) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.designCode = designCode;
    param.version = version;
    param.where = _where;
    var dt = await dataService.getProductDetails(param);
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
    var dt = await dataService.getProduct(param);
    topSellersProductlist = dt;
    ftopSellersProductlist = dt;
    return dt;
  }

  void getSelProduct() {
    var sitem = productdt.where((d) => d.groupName == _selgroup)
        .toList();
    selProductlist = new List<Product>();
    fselProductlist = new List<Product>();
    selProductlist = sitem;
    fselProductlist = sitem;
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, kIsWeb ? 55 : 80, 50, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('CURRENCY'), value: 'CURRENCY'),
        PopupMenuItem<String>(
            child: Row(
              children: [
//                Image.asset(
//                  sCountry.imageUrl, height: 20, fit: BoxFit.fitHeight,),
                SizedBox(width: 10,),
//                Text(sCountry.currency)
              ],
            ))
      ],
      elevation: 8.0,
    );
  }

  Future<void> _group_onTap(String productType, BuildContext context) async {
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    var productdetail = await getProductDetail(productType, "", 1);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
        .pop(); //close the dialoge
    if (productdetail.length > 1) {
      productlistParam arg = new productlistParam();
      arg.title = productType;
      arg.productdt = productdetail;
      // Navigator.pushNamed(context, ProductListPage2.route+"?category="+ productType, arguments: arg);//, arguments: arg
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductListPage(productdt: productdetail, title: productType,),)
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
  Future<void> getsSQLProducts(String sSQL, String productType, BuildContext context) async {
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    var productdetail = await dataService.getsSQLProduct(sSQL);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
        .pop(); //close the dialoge
    if (productdetail.length > 1) {
      // Navigator.pushNamed(context, ProductListPage2.route+"?category="+ productType);//, arguments: arg
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductListPage(productdt: productdetail, title: productType,),)
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

  void Filter_Click(String source) async {
    if (source == "HOME") {
      List<Product> gFilter = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => FilterPage(productdt: selProductlist,),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 300),
        ),
      );

      if (gFilter != null) {
        fselProductlist = new List<Product>();
        fselProductlist = gFilter;
        setState(() {

        });
      }
    }
    else {
      List<Product> gFilter = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>
              FilterPage(productdt: topSellersProductlist,),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 300),
        ),
      );

      if (gFilter != null) {
        ftopSellersProductlist = new List<Product>();
        ftopSellersProductlist = gFilter;
        setState(() {

        });
      }
    }
  }

  Widget BannerImage(BuildContext context) {
    double _height = 250;

    if (screenWidth > 1600)
      _height = 600;
    else if (screenWidth >= 1300)
      _height = 550;
    else if (screenWidth >= 1000)
      _height = 500;
    else if (screenWidth >= 700)
      _height = 300;
    else if (screenWidth >= 500)
      _height = 250;
    else if (screenWidth >= 400)
      _height = 250;
    if (dDt.length > 0) {
      return new Container(
        child: Column(
          children: [
            InkWell(
              onTap:() {
                getsSQLProducts(dDt[_bannercurrent].procedureName, dDt[_bannercurrent].title, context);
              },
              child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                          autoPlay: true,
                          height: _height,
                          aspectRatio: 1,
                          //16 / 9,
                          viewportFraction: 1,
                          //0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlayInterval: Duration(seconds: 8),
                          //autoPlayAnimationDuration: Duration(milliseconds: 0),
                          //autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
//            onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _bannercurrent = index;
                            });
                          },
                      ),
                      items: dDt.map((item) =>
                          Container(
                            child: Image.network(item.imageFileName2,
                              fit: !kIsWeb ? BoxFit.fill : BoxFit.fill,
                              //height: 170,
                              //width: screenWidth - 0,
                            ),
                          )
                      ).toList(),
                      carouselController: _controller,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _controller.nextPage(),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFc4cfd4),
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _controller.previousPage(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFc4cfd4),
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dDt.map((url) {
                int index = dDt.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _bannercurrent == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }
    else {
      return new Container(
      );
    }
  }

  Widget titleMessage(Color _bgColor, Color _fontColor) {
    return !hideTitleMessage ? Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Container(
          color: _bgColor,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, top: 8.0, bottom: 8.0, right: 5.0),
            child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 20,
                      padding: EdgeInsets.only(right: 20),
                      child: ScrollingText(text: titMessage,
                        textStyle: TextStyle(color: _fontColor),),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          hideTitleMessage = true;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.close, color: _fontColor, size: 18,),
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
//          IconButton(
//            icon: new Image.asset(sCountry.imageUrl),
//            iconSize: 20,
//            onPressed: () {
//              _showPopupMenu();
//            },
//          ),
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

  int GridItemCount(double tscreenwidth) {
    int itemCount = 1;
    tscreenwidth = tscreenwidth - (tscreenwidth - screenWidth);
    if (tscreenwidth <= 550)
      itemCount = 1;
    else if (tscreenwidth <= 800)
      itemCount = 2;
    else if (tscreenwidth <= 1050)
      itemCount = 3;
    else if (tscreenwidth <= 1150)
      itemCount = 4;
    else if (tscreenwidth <= 1300)
      itemCount = 5;
    else if (tscreenwidth <= 1450)
      itemCount = 6;
    else if (tscreenwidth <= 1600)
      itemCount = 7;
    else
      itemCount = 8;

    return itemCount;
  }

  Widget TopSellingListitem(DesignCode item) {
    int count = GridItemCount(screenWidth);
    return Container(
        width: screenWidth / count - 4,
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
                                  item.tagPrice > 0 && item.promotionPrice != 0
                                      ?
                                  Text(item.tagPrice > 0
                                      ? '$currencysymbol${formatterint.format(
                                      item.tagPrice)}'
                                      : '${formatter2dec.format(
                                      item.grossWeight)}g',
                                      style: TextStyle(
                                          decoration: TextDecoration
                                              .lineThrough))
                                      : Text(item.goldWeight2 > 0
                                      ? '${formatter2dec.format(
                                      item.goldWeight2)} -'
                                      : ''),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text(item.designCode),
                                  Spacer(),
                                  item.tagPrice > 0 && item.promotionPrice > 0 ?
                                  Text('$currencysymbol${formatterint.format(
                                      item.promotionPrice)}', style: TextStyle(
                                      fontWeight: FontWeight.bold))
                                      : Text(item.tagPrice > 0
                                      ? '$currencysymbol${formatterint.format(
                                      item.tagPrice)}'
                                      : 'Wt.: ${formatter2dec.format(
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
                                                fontSize: 13,
                                                color: Colors.white),
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

  Widget CategoryListitem(BuildContext context, Group dt, int index,
      int totindex) {
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
                          if (_selectedCategoryIndex < index)
                            nindex = index - 1;
                          else
                            nindex = index;

                          _scrollControllerlist.scrollTo(
                              index: nindex, duration: Duration(seconds: 1));
                        }
                        _selectedCategoryIndex = index;

                        setState(() {});
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
      //itemScrollController: _scrollControllerlist,
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) =>
          CategoryListitem(context, data[index], index, data.length),
    );
  }

  Widget CategoryGriditem(Group item) {
    // int count = GridItemCount(screenWidth);
    return Container(
      //width: screenWidth / count - 4,
      //color: Colors.grey,
        child: Container(
            child: GestureDetector(
                onTap: () {
                  _group_onTap(item.groupName, context);
                },
                child: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 05.0,
                                right: 05.0,
                                bottom: 00.0,
                                top: 05.0),
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: Image.network(item.imageFileName2,
                              ),
                              // child: Image(
                              //   image: CachedNetworkImageProvider(
                              //     item.imageFileName2,
                              //   ),
                              //   fit: BoxFit.fitWidth,
                              // ),
//                  child: Image.network(
//                    item.imageUrl, fit: BoxFit.fitHeight,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 05.0,
                                right: 05.0,
                                top: 0.0,
                                bottom: 0.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  05.0, 8.0, 05.0, 8.0),
                              alignment: FractionalOffset.bottomCenter,
                              //color: listbgColor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Spacer(),
                                      Text(item.groupName, style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Text("SHOW ALL " + item.groupName + " >>",
                                        style: TextStyle(fontSize: 12),),
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25,),
                        ],
                      ),

                    ]
                ))
        )
    );
  }
  Widget TopCategory(String tcategory) {
    int count = GridItemCount(screenWidth);
    return Container(
      //width: screenWidth / count - 4,
      //color: Colors.grey,
        child: Container(
            child: GestureDetector(
                onTap: () {
                  if(tcategory=="TOP SELLERS")
                    getsSQLProducts("EXEC app_GetProductDetails 'TOP SELLERS', '', '', '', 1, ''", "TOP SELLERS", context);
                  else if(tcategory=="NEW ARRIVAL")
                    getsSQLProducts("EXEC app_GetProductDetails 'NEW ARRIVAL', '', '', '', 1, ''", "NEW ARRIVAL", context);
                  else
                    getsSQLProducts("EXEC app_GetProductDetails 'SALE', '', '', '', 1, ''", "SALE", context);
                },
                child: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 05.0,
                                right: 05.0,
                                bottom: 00.0,
                                top: 05.0),
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: Image.network(tcategory=="TOP SELLERS" ? imageUrl + "TopSellers.jpg" :
                              tcategory=="NEW ARRIVAL" ? imageUrl + "NewArrival.jpg"
                                  : imageUrl + "Sale.jpg",
                              ),
                              // child: Image(
                              //   image: CachedNetworkImageProvider(
                              //     item.imageFileName2,
                              //   ),
                              //   fit: BoxFit.fitWidth,
                              // ),
//                  child: Image.network(
//                    item.imageUrl, fit: BoxFit.fitHeight,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 05.0,
                                right: 05.0,
                                top: 8.0,
                                bottom: 8.0),
                            child: Container(
                              alignment: FractionalOffset.bottomCenter,
                              //color: listbgColor,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(tcategory, style: TextStyle(color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("SHOW ALL"+ " >>",
                                        style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25,),
                        ],
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
    return new TabBar(
      isScrollable: true,
      controller: _tabController,
      indicatorColor: listLabelbgColor,
      tabs: [
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
        if (index == 0) {
          _tabControllerFilter.index = 0;
          _filter = "ALL";
//          Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
          await getProduct();
//          Navigator.of(_keyLoader.currentContext, rootNavigator: true)\.pop(); //close the dialoge
        }

        setState(() {

        });
      },
    );
  }

  Widget subMenu() {
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
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
          ),
      ],
      labelPadding: EdgeInsets.only(left: 10, right: 10),
//      indicatorWeight: 1.0,
      onTap: (index) async {
        _filter = smitem[index];
//        Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
        await getProduct();
//        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop(); //close the dialoge
        setState(() {});
      },
    );
  }
  Widget mainContainer(int itemCount, double itemheight, double screenwidth) {
    if (menuSelected == 0) {
      return Flexible(
        child: Row(
//          mainAxisSize: MainAxisSize.max,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                color: webLeftContainerColor,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(
                    minWidth: 250, maxWidth: screenWidth),
                //Flexible(
                child: homeWidget(itemCount, itemheight, screenwidth),
              ),
            ),
            Flexible(
              child: Container(
                color: webRightContainerColor,
              ),
            ),
          ],
        ),
      );
    }
    else if (menuSelected == 1) {
      return Flexible(
        child: Row(
          children: [
            Flexible(
              child: Container(
                color: webLeftContainerColor,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  constraints: BoxConstraints(
                      minWidth: 250, maxWidth: screenWidth),
                  child: categoryWidget(itemCount, itemheight, screenwidth)),
            ),
            Flexible(
              child: Container(
                color: webRightContainerColor,
              ),
            ),
          ],
        ),
      );
    }
    else if (menuSelected == 2) {
      return Flexible(
        child: Row(
          children: [
            kIsWeb ? Expanded(
              child: Container(
                color: webLeftContainerColor,
              ),
            ) : Container(),
            Container(
                constraints: BoxConstraints(
                    minWidth: 250, maxWidth: screenWidth),
                child: topSellersWidget(itemCount, itemheight, screenwidth)),
            kIsWeb ? Expanded(
              child: Container(
                color: webRightContainerColor,
              ),
            ) : Container(),
          ],
        ),
      );
    }
  }

  Widget homeWidget(int itemCount, double itemheight, double screenwidth) {
    int count = GridItemCount(screenWidth);
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          //Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 1.0),
              child: BannerImage(context),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10,),
          ),
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: count),
              delegate: SliverChildListDelegate(
                  [
                    for(var i in groupdt)
                      Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                          child: CategoryGriditem(i)),
                    TopCategory("NEW ARRIVAL"),
                    TopCategory("SALE"),
                    TopCategory("TOP SELLERS"),
                  ]
              )
          ),

          // SliverList(
          //     delegate: SliverChildListDelegate(
          //         [
          //           for(var i in groupdt)
          //             Container(
          //                 constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
          //                 child: CategoryGriditem(i)),
          //           TopCategory("NEW ARRIVAL"),
          //           TopCategory("SALE"),
          //           TopCategory("TOP SELLERS"),
          //         ]
          //     )
          // ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20,),
          ),
          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  color: Colors.blueGrey[100],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 10,),
                      Text("FOLLOW US ON"),
                      SizedBox(width: 10,),
                      InkWell(
                        child: Image(image: AssetImage("assets/facebook.png"),
                          height: 45,
                          fit: BoxFit.fitHeight,),
                        onTap: () {
                          _launchInBrowser("https://www.facebook.com/");
                        },
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        child: Image(image: AssetImage("assets/twitter.png"),
                          height: 45,
                          fit: BoxFit.fitHeight,),
                        onTap: () {
                          _launchInBrowser("https://twitter.com/");
                        },
                      ),
                      SizedBox(width: 10,),
                      InkWell(child: Image(
                        image: AssetImage("assets/linkedin.png"),
                        height: 45,
                        fit: BoxFit.fitHeight,),
                        onTap: () {
                          _launchInBrowser("https://www.linkedin.com/");
                        },
                      ),
                      SizedBox(width: 10,),
                      InkWell(child: Image(
                        image: AssetImage("assets/instagram.png"),
                        height: 45,
                        fit: BoxFit.fitHeight,),
                        onTap: () {
                          _launchInBrowser("https://www.instagram.com/");
                        },
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              )
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 40,),
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

  Widget topSellersWidget(int itemCount, double itemheight,
      double screenwidth) {
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 37, width: 35,
                        child: IconButton(
                            icon: new Image.asset(
                              'assets/filter_icon.png', height: 20,),
//                                                iconSize: 20,
                            onPressed: () {
                              Filter_Click("TOPSELLERS");
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
                for(var i in ftopSellersProductlist)
                  ProductGridWidgetHome(productType: "",
                    item: i,
                    masterScreenFormKey: _formKeyReset,),
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

  void showGoldRate() {
    Future.delayed(Duration.zero, () =>
        objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate));
  }

  void showInfoFlushbar(String msg) {
    Flushbar(
      margin: EdgeInsets.all(8),
      backgroundGradient: LinearGradient(
          colors: [Color(0xFF757575), Color(0xFF757575)]),
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: listbgColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)
      ],
      borderRadius: 8,
//      title: 'Failed to login!',
      message: '$msg',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.white,
      ),
      // leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 1),
    )
      ..show(context);
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      showInfoFlushbar("Press back again to exit");
      return false;
    }

    return true;
  }

  void firebaseMessagingConfigure() {
    var notification, notificationData;
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          notification = message['notification'];
          notificationData = message['data'] ?? message;
          String buttonTitle = "OK";
          if (notificationData['screen'] != null) {
            if (notificationData['screen'] == "videoCall")
              buttonTitle = "ACCEPT";
          }
          print('onMessage: $message');
          if (notificationData["isScheduled"] == "yes") {
            _scheduleNotification(message);
          }
          else {
            setState(() {
              flush = Flushbar<bool> (
                borderRadius: 15,
                title: notification['title'],
                message: notification['body'],
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                backgroundGradient: LinearGradient(colors: [Colors.teal, Colors.blueAccent],),
                backgroundColor: Colors.red,
                boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                isDismissible: false,
                //duration: Duration(seconds: 20 ),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                mainButton: FlatButton(
                  onPressed: () {
                    flush.dismiss(true);
                    if (notificationData['screen'] != null) {
                      _serialiseAndNavigate(message);
                    }
                  },
                  child: Text(
                    buttonTitle,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                showProgressIndicator: true,
                progressIndicatorBackgroundColor: Colors.blueGrey,
                titleText: Text(
                  notification['title'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.yellow, fontFamily: "ShadowsIntoLightTwo"),
                ),
                messageText: Text(
                  notification['body'],
                  style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
                ),
              )..show(context).then((result) {
                setState(() { // setState() is optional here
                  _wasButtonClicked = result;
                });
              });
            });
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
          _serialiseAndNavigate(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
          _serialiseAndNavigate(message);
        }
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'] ?? message;
    if (notificationData["isScheduled"] == "yes") {
      _scheduleNotification(message);
      Dialogs.AlertMessage(context, "Appointment confirmed and reminder added");
    }
    else if (notificationData['screen'] != null) {
      hideGoldRate = true;
      showCartNotification = false;
      // Navigate to the screen defined
      if (notificationData['screen'] == 'voucher') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VoucherDetailPage()),);
      }
      else if (notificationData['screen'] == 'videoCall') {
        onJoin(notificationData['channelName']);
      }
      // If there's no view it'll just open the app on the first view
    }
  }

  Future<void> onJoin(String channelName) async {
    await Commonfn.handleCameraAndMic();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: channelName,
          role: ClientRole.Broadcaster,
        ),),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      firebaseMessagingConfigure();
      var dt = dataService.FCM_RegisterToken("");
    }

    menuSelected = widget.currentIndex;

    _tabController = new TabController(vsync: this, length: hMenuCount,);
    _tabControllerFilter = new TabController(vsync: this, length: fMenuCount,);

    getDefault();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    screenWidth = screenSize.width;
    if (kIsWeb) {
      screenWidth = cfobj.ScreenWidth(screenSize.width);
    }

    int itemCount = GridItemCount(screenWidth);
    double itemheight = GridItemHeight(screenSize.height, screenWidth);

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: "Home",
    //   theme: MasterScreen.themeData(context),
    return Scaffold(
        key: scaffoldKey,
        drawer: Container(
            width: 220,
            child: MenuItemWedget(scaffoldKey: scaffoldKey,
              isLogin: isLogin,
              masterScreenFormKey: _formKeyReset,)),
        body: SafeArea(
          child: WillPopScope(
              onWillPop: () => onWillPop(),
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget> [
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors:  [primary1Color, Colors.white],
                                stops: [0.0, 0.8],
                              )),
                          child: Column(
                            children: [
                              titMessage != "" ? titleMessage(
                                  homeTitleColor, Colors.white) : Container(),
                              titleBar2(context, scaffoldKey, _keyGoldRate,
                                  _formKeyReset, primary1Color),
                            ],
                          )
                      ),
                      mainContainer(itemCount, itemheight, screenWidth),
                    ],
                  )

              )
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[
              SizedBox(
                width: 70.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
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
                          "Try @ Home",
                          style: TextStyle(
                              color: Color(0xFF656665),
                              fontSize: 8
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    _group_onTap("Home Try-On", context);
                  },
                ),
              ),
              SizedBox(
                width: 65.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
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
                              fontSize: 8
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
                width: 50.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                        child: Icon(
                          Icons.mail,
                          color: Colors.grey,
                          size: 24.0,
                        ),
                      ),
                      SizedBox(height: 0,),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "Inbox",
                          style: TextStyle(
                              color: Color(0xFF656665),
                              fontSize: 8
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (isLogin == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),);
                    }
                    else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagePage())
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: 50.0,
                child: FlatButton(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 24.0,
                        ),
                      ),
                      SizedBox(height: 0,),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(userID == "" ?
                        "Login" : "Account",
                          style: TextStyle(
                              color: Color(0xFF656665),
                              fontSize: 8
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    if (userID == "") {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(
                                  masterScreenFormKey: _formKeyReset,)),);
                      if (userID != null && userID != "") {
                        var cartdt = await dataService.getCart(userID, "S");
                        LoadCart(cartdt);
                      }
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
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
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
                              fontSize: 8
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
    //);
  }
}

