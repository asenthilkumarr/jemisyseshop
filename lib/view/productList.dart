import 'dart:async';
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
import 'package:jemisyseshop/view/filter.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
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
  ScrollController _scrollController = new ScrollController();
  RangeValues values = RangeValues(1,100);
  String filterSelect ="Metal Type";
  List<String> _metal;
  List<String> _brand;
  List<double> _price;
  List<double> _weight;
  int totItem = 0;
  bool totisVisable = true;

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
  void Filter_Click() {
    FilterValue result = new FilterValue();
    FilterSelValue item;
    List<FilterSelValue> items = List<FilterSelValue>();

    result.minprice = _price[0];
    result.maxprice = _price[1];
    result.minweight = _weight[0];
    result.maxweight = _weight[1];

    for(var i in _metal){
      if(i!=""){
        item = new FilterSelValue(isChecked: false, value: i);
        items.add(item);
      }

    }
    result.metal = items;

    items = List<FilterSelValue>();
    for(var i in _brand){
      if(i!=""){
        item = new FilterSelValue(isChecked: false, value: i);
        items.add(item);
      }
    }
    result.brand = items;

//    Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) =>
//              FilterPage(fValue: result,),)
//    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => FilterPage(fValue: result,),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
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
  Widget filterWidget2(double _min, double _max){
    return SafeArea(
      child: Container(
        color: Colors.grey,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        child: Text("Metal Type"),
                        onPressed: (){
                          filterSelect ="Metal Type";
                          setState(() { });
                        },
                      ),
                      FlatButton(
                        child: Text("Brand            "),
                        onPressed: (){
                          filterSelect ="Brand";
                          setState(() { });
                        },
                      ),
                      FlatButton(
                        child: Text("Price Range"),
                        onPressed: (){
                          filterSelect ="Price";
                          setState(() { });
                        },
                      ),
                      FlatButton(
                        child: Text("Weight Range"),
                        onPressed: (){
                          filterSelect ="Weight";
                          setState(() { });
                        },
                      ),
                    ]
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  filterSelect == "Metal Type" ? Container() :
                  filterSelect == "Brand" ? Container() :
                  filterSelect == "Price" ? Container(
                    width: double.infinity,
                    child: RangeSlider(
                      min: 1,
                      max: 100,
                      values: values,
                      divisions: 10,
                      onChanged: (value) {
                        print("Start: ${value.start}, End: ${value.end}");
                        setState(() {
                          values = value;
                        });
                      },
                    ),
                  ) :
                  filterSelect == "Weight" ? Container(
                    height: 20,
                  ) :
                  Container(),
                ],
              ),
            )
          ],

        ),
      ),
    );
  }

  @override
  void initState() {
    getProductDetail();
    _metal = getFilterMetalType();
    _brand = getFilterBrands();
    _price=  getFilterPricerange();
    _weight = getFilterWeightrange();

    totItem = widget.productdt.length;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _hideNotification();
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
                                color: Color(0xFFF2F1EB),
//                                border: Border.all(
//                                    width: 0.0
//                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15.0) //         <--- border radius here
                                ),
                              ),
//                            color: Colors.grey,
                              height: 50,
                                width: 100,
                                child: Center(child: Text("${totItem} items",)))),
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