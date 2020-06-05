import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/filter.dart';
import 'package:jemisyseshop/widget/productGridWidget.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class ProductListPage extends StatefulWidget{
  final List<Product> productdt;
  final String title;
  ProductListPage({this.productdt, this.title});
  @override
  _productListPage createState() => _productListPage();
}
class _productListPage extends State<ProductListPage> {
  DataService dataService = DataService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyGoldRate = GlobalKey();
  String designCode = "Design";
  List<Product> productdt = new List<Product>();
  List<Product> fproductdt = new List<Product>();
  ScrollController _scrollController = new ScrollController();
  RangeValues values = RangeValues(1,100);
  String filterSelect ="Metal Type";
  int totItem = 0;
  bool totisVisable = true;

  double GridItemHeight(double screenHeight, double screenWidth) {
    double itemHeight = 0.55;
    itemHeight = 1;
    if (!kIsWeb) {
      if (screenHeight > screenWidth)
        itemHeight = 0.370;
      else
        itemHeight = 0.40;
    }
    else {
      if (screenHeight > screenWidth)
        itemHeight = 0.85;
      else {
        if (screenWidth < 800)
          itemHeight = 0.65;
        if (screenWidth < 950)
          itemHeight = 0.75;
        if (screenWidth < 1050)
          itemHeight = 0.60;
        else
          itemHeight = 0.45;
      }
    }
    return itemHeight;
  }
  int GridItemCount(double screenwidth) {
    int itemCount = 0;
    if (!kIsWeb) {
      if (screenwidth <= 550)
        itemCount = 2;
      else if (screenwidth <= 750)
        itemCount = 3;
    }
    else {
      if (screenwidth <= 550)
        itemCount = 2;
      else if (screenwidth <= 950)
        itemCount = 3;
      else if (screenwidth <= 1100)
        itemCount = 4;
      else if (screenwidth <= 1250)
        itemCount = 5;
      else if (screenwidth <= 1400)
        itemCount = 6;
      else
        itemCount = 8;
    }

    return itemCount;
  }
  void Filter_Click() async {

    List<Product> gFilter = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => FilterPage(productdt: productdt,),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );

    if (gFilter != null) {
      fproductdt = gFilter;
      totItem = fproductdt.length;
      totisVisable = true;
      _hideNotification();
      setState(() {

      });
    }
  }
  Widget homeWidget(double screenHeight, double screenWidth) {
    double itemHeight = GridItemHeight(screenHeight, screenWidth);
    int itemCount = GridItemCount(screenWidth);

    return Flexible(
        child: Container(
            child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[

                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: itemCount,
                      childAspectRatio: 0.6, // itemHeight - 0.25,
                    ),
                    delegate: SliverChildListDelegate(
                      [
                        for(var i in fproductdt)
                          ProductGridWidget(item: i,),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                    ),
                  )
                ]
            )
        )
    );
  }
  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        totisVisable = true;
        _hideNotification();
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        totisVisable = true;
        _hideNotification();
      });
    }
  }
  _hideNotification() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        totisVisable = false;
      });
    });
  }

  @override
  void initState() {
    productdt = widget.productdt;
    fproductdt = widget.productdt;
    //getProductDetail();


    designCode = widget.productdt[0].designCode;
    totItem = widget.productdt.length;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _hideNotification();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Product Details', theme:
    ThemeData(
      textTheme: GoogleFonts.latoTextTheme(
        Theme
            .of(context)
            .textTheme,
      ),
    ),
      home: Scaffold(
        key: scaffoldKey,
//      appBar: pageAppBar(),
//        drawer: filterWidget(),
//        drawer: filterWidget2(1,100),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                        children: [
                          Customtitle(context, widget.title),
                          Container(
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Filter_Click();
                                      //scaffoldKey.currentState.openDrawer();
                                    },
                                    child: Container(
//                              color: listLabelbgColor,
                                      decoration: BoxDecoration(
                                        color: listLabelbgColor,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0, right:6.0),
                                            child: Image(image: AssetImage("assets/filter_icon.png"),width: 16, height: 16,),
                                          ),
                                          Text('FILTER', style: TextStyle(color: Colors.white),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
//                              color: listLabelbgColor,
                                      decoration: BoxDecoration(
                                        color: listLabelbgColor,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Spacer(),
                                          Transform.rotate(
                                              angle: 90 * pi / 180,
                                              child: Icon(Icons.swap_horiz, color: Colors.white,)),Text('SORT', style: TextStyle(color: Colors.white),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          homeWidget(screenSize.height, screenSize.width),

                        ]
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top:50.0),
                        child: Visibility(
                            visible: totisVisable,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF64645A),
//                                border: Border.all(
//                                    width: 0.0
//                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15.0) //         <--- border radius here
                                ),
                              ),
//                            color: Colors.grey,
                              height: 40,
                                width: 110,
                                child: Center(child: Text("${totItem} items",style: TextStyle(color: Colors.white),)))),
                      ),
                    ),
                  ]
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
      ),
    );
  }
}

class Entry {
  const Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}