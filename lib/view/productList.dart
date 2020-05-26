import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import 'package:jemisyseshop/widget/productGridWidget.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class ProductListPage extends StatefulWidget{
  final List<Product> productdt;
  ProductListPage({this.productdt});
  @override
  _productListPage createState() => _productListPage();
}
class _productListPage extends State<ProductListPage> {
  DataService dataService = DataService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyGoldRate = GlobalKey();
  String designCode = "Design";
  List<Product> productdt=new List<Product>();
  ScrollController _scrollController = new ScrollController();

  Future<List<Product>> getProductDetail() async {
//    ProductParam param = new ProductParam();
//    param.designCode = productdt.designCode;
//    param.version = widget.version;
//    param.where = _where;
//    var dt = await dataService.GetProductDetails(param);
    designCode = widget.productdt[0].designCode;
    productdt=widget.productdt;
    setState(() {

    });
    return productdt;
  }

  double GridItemHeight(double screenHeight, double screenWidth) {
    double itemHeight = 0.55;
    itemHeight = 1;
    if(!kIsWeb){
      if(screenHeight>screenWidth)
        itemHeight = 0.370;
      else
        itemHeight = 0.40;
    }
    else{
      if(screenHeight>screenWidth)
        itemHeight = 0.85;
      else{
        if(screenWidth<800)
          itemHeight = 0.65;
        if(screenWidth<950)
          itemHeight = 0.75;
        if(screenWidth<1050)
          itemHeight = 0.60;
        else
          itemHeight = 0.45;
      }
    }
    return itemHeight;
  }
  int GridItemCount(double screenwidth) {
    int itemCount = 0;
    if(!kIsWeb){
      if (screenwidth <= 550)
        itemCount = 2;
      else if (screenwidth <= 750)
        itemCount = 3;
    }
    else{
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
                      childAspectRatio: 0.6,// itemHeight - 0.25,
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

  @override
  void initState() {
    super.initState();
    getProductDetail();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
        title: 'Product Details',
        home: Scaffold(
            key: scaffoldKey,
//      appBar: pageAppBar(),
            drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
            body: SafeArea(
                child: Container(
                    color: Colors.white,
                    child: Column(
                        children: [
                          Customtitle(context, designCode),
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