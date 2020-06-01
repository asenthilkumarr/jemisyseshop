import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import 'package:jemisyseshop/widget/productGridWidget.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
//import 'package:collection/collection.dart';

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
  ScrollController _scrollController = new ScrollController();

  Future<List<Product>> getProductDetail() async {
//    ProductParam param = new ProductParam();
//    param.designCode = productdt.designCode;
//    param.version = widget.version;
//    param.where = _where;
//    var dt = await dataService.GetProductDetails(param);
    designCode = widget.productdt[0].designCode;
    productdt = widget.productdt;
    setState(() {

    });
    return productdt;
  }

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
  List<String> getFilterBrands(){
    var col0 = widget.productdt.map<String>((row) => row.brand).toList(growable: false);
    var brand = col0.toSet().toList();
    print("Brand: ${brand.length}");
    return brand;
  }
  List<String> getFilterMetalType(){
    var col0 = widget.productdt.map<String>((row) => row.metalType).toList(growable: false);
    var metalType = col0.toSet().toList();
    print("Brand: ${metalType.length}");
    return metalType;
  }
  List<double> getFilterPricerange(){
    var col0 = widget.productdt.map<double>((row) => row.listingPrice).toList(growable: false);
    var listingprice = col0.toSet().toList();
    var minval = listingprice.reduce(min);
    var maxval = listingprice.reduce(max);
    List<double> reslut = List<double>();
    reslut.add(minval);
    reslut.add(maxval);
    print("Max : $maxval Min : $minval");
    return reslut;
  }
  List<double> getFilterWeightrange(){
    var col0 = widget.productdt.map<double>((row) => row.goldWeight).toList(growable: false);
    var goldWeight = col0.toSet().toList();
    var minval = goldWeight.reduce(min);
    var maxval = goldWeight.reduce(max);
    List<double> reslut = List<double>();
    reslut.add(minval);
    reslut.add(maxval);
    print("Maxwt : $maxval Minwt : $minval");
    return reslut;
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
                        for(var i in productdt)
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

  Widget filterWidget(){
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFe2e8ec),
                    width: 1,
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        child: Text("Metal Type"),
                      ),
                      FlatButton(
                        child: Text("Brand            "),
                      ),
                      FlatButton(
                        child: Text("Price Range"),
                      ),
                      FlatButton(
                        child: Text("Weight Range"),
                      ),
                    ]
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            )
          ],

        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    getProductDetail();
    getFilterBrands();
    getFilterMetalType();
    getFilterPricerange();
    getFilterWeightrange();
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
        drawer: filterWidget(),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                child: Column(
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
                                onTap: (){
                                  scaffoldKey.currentState.openDrawer();
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