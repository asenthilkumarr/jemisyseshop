import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/filter.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/widget/productGridWidget.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class ProductListPage extends StatefulWidget{
  final List<Product> productdt;
  final String title;
  final String fsource;
  final String filterType;
  final GlobalKey<FormState> masterScreenFormKey;

  ProductListPage({this.productdt, this.title, this.masterScreenFormKey, this.fsource, this.filterType});
  @override
  _productListPage createState() => _productListPage();
}
class _productListPage extends State<ProductListPage> {
  DataService dataService = DataService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  GlobalKey _keyGoldRate = GlobalKey();
  String designCode = "Design";
  List<Product> productdt = new List<Product>();
  List<Product> fproductdt = new List<Product>();
  List<Group> groupdt = new List<Group>();
  ScrollController _scrollController = new ScrollController();
  RangeValues values = RangeValues(1,100);
  String filterSelect ="Metal Type";
  int _selectedGroupIndex = 0;
  int totItem = 0;
  bool totisVisable = true;
  String _filterType = "", _selgroup = "";
  ItemScrollController _scrollControllerlist = ItemScrollController();

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
  void sortData(String field) {
    if (field == "listingPriceLH")
      fproductdt.sort((a, b) => a.onlinePrice.compareTo(b.onlinePrice));
    if (field == "listingPriceHL"){
      fproductdt.sort((a, b) => b.onlinePrice.compareTo(a.onlinePrice));
    }

    if (field == "goldWeightLH")
      fproductdt.sort((a, b) => a.goldWeight.compareTo(b.goldWeight));
    if (field == "goldWeightHL"){
      fproductdt.sort((a, b) => b.goldWeight.compareTo(a.goldWeight));
    }

    setState(() {

    });
    Navigator.of(_formKey.currentContext, rootNavigator: true)
        .pop(); //close the dialoge
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
  void sort_Click(){
    showDialog(
        context: context,
        builder: (BuildContext context)
    {
      return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close, color: Colors.white,),
                    backgroundColor: primary1Color,
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child:Text("SORT BY"),
                        ),
                        Divider(height: 5,
                        color: listLabelbgColor,),
                        Material(
//                          color: source == "groupName" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              sortData("listingPriceLH");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Price - Low to High",),
                                  )),
                            ),
                          ),
                        ),
//                        Divider(),
                        Material(
//                          color: source == "groupName" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              sortData("listingPriceHL");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Price - High to Low",),
                                  )),
                            ),
                          ),
                        ),
                        Material(
//                          color: source == "groupName" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              sortData("goldWeightLH");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Weight - Low to High",),
                                  )),
                            ),
                          ),
                        ),
                        Material(
//                          color: source == "groupName" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              sortData("goldWeightHL");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Weight - High to Low",),
                                  )),
                            ),
                          ),
                        ),
                        /*
                        Align(
                          alignment: Alignment.center,
                          child: RawMaterialButton(
//                          fillColor: listLabelbgColor,
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0, right: 20.0),
                              child: Text("Price Low to High"),
                            ),
                            onPressed: (){
                              sortData("listingPriceLH");
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: RawMaterialButton(
//                          fillColor: listLabelbgColor,
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0, right: 20.0),
                              child: Text("Price High to Low"),
                            ),
                            onPressed: (){
                              sortData("listingPriceHL");
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RawMaterialButton(
//                          fillColor: listLabelbgColor,
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0, right: 20.0),
                              child: Text("Weight High to Low"),
                            ),
                            onPressed: (){
                              sortData("goldWeightHL");
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RawMaterialButton(
//                          fillColor: listLabelbgColor,
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0, right: 20.0),
                              child: Text("Weight Low to High"),
                            ),
                            onPressed: (){
                              sortData("goldWeightLH");
                            },
                          ),
                        ),
*/
                      ]
                  )
              ),
            ],
          )
      );
    }
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
                        for(var i in fproductdt)
                          ProductGridWidget(item: i, masterScreenFormKey: widget.masterScreenFormKey,),
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
  Future<List<Product>> getProductDetail(String productType, String filterType) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.filterType = filterType;
    param.version = 1;

//    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    var dt = await dataService.getProductDetails(param);
//    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//        .pop(); //close the dialoge
    return dt;
  }
  Future<List<Group>> getGroup() async {
    var dt = await dataService.getGroup();
    dt.removeWhere((e) => e.groupName == "WATCHES");
    groupdt = dt;
    if (dt.length > 0)
      _selgroup = dt[0].groupName;
    return dt;
  }

  void loadDefault() async{
    if(widget.fsource == "MENU"){
      if(widget.filterType == "WATCHONLY"){
        productdt = await getProductDetail("WATCHES", widget.filterType);
      }
      else {
        await getGroup();
        productdt = await getProductDetail(_selgroup, widget.filterType);
      }
      fproductdt = productdt;
    }
    else{
      productdt = widget.productdt;
      fproductdt = widget.productdt;
      designCode = productdt[0].designCode;
    }
    totItem = productdt.length;
    _hideNotification();
    setState(() {

    });

  }
  void grouponTap() async{
    productdt = await getProductDetail(_selgroup, _filterType);
    fproductdt = productdt;
    totItem = productdt.length;
    totisVisable = true;
    _hideNotification();
    setState(() {

    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _filterType = widget.filterType;
    loadDefault();
    super.initState();
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: Center(child: child),
    );
  }
  Widget groupListView(List<Group> data) {
    return new ScrollablePositionedList.builder(
      itemScrollController: _scrollControllerlist,
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) =>
          groupListitem(context, data[index], index, data.length),
    );
  }
  Widget groupListitem(BuildContext context, Group dt, int index,
      int totindex) {
    int nindex = index;

    if (dt.groupName != null) {
      return Container(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 3.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      _selgroup = dt.groupName;
                      if (index < totindex - 1 && index > 1) {
                        if (_selectedGroupIndex < index)
                          nindex = index - 1;
                        else
                          nindex = index;

                        _scrollControllerlist.scrollTo(
                            index: nindex, duration: Duration(seconds: 1));
                      }
                      _selectedGroupIndex = index;
                      grouponTap();
                    },
                    child: Container(
//                      height: 80,
                      decoration: BoxDecoration(
                        gradient: SweepGradient(
                          colors: [Colors.blue, Colors.green, Colors.yellow, Colors.red, Colors.blue],
                          stops: [0.0, 0.25, 0.5, 0.75, 1],
                        ),
                        shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(3),
                      child: CircleAvatar(

                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            dt.imageFileName,
                          ),
                          radius: 35,
                        ),
                        radius: 45,
                      ),
                    ),
                      /*
                    child: Container(
                        decoration: new BoxDecoration(
                          color: buttonColor, // border color
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2.0), // borde width
                        child: Container(
                          decoration: new BoxDecoration(
                            color: const Color(0xFFFFFFFF), // border color
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(13.0), // borde width
                          child: Image(
                            height: 65,
                            width: 65,
                            image: CachedNetworkImageProvider(
                              dt.imageFileName,
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
*/
                  )
                ],
              ),
              Spacer(),
              Container(
//                  color: listLabelbgColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${dt.groupName}',
//                        style: TextStyle(color: Colors.white),
                    ),
                    //Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return new Text('ERROR');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Product List',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white),),
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, false),
          ),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.home,color: Colors.white,),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//          ],
          backgroundColor: Color(0xFFFF8752),
          centerTitle: true,
        ),
//        drawer: filterWidget(),
//        drawer: filterWidget2(1,100),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                        children: [
                          //Customtitle(context, widget.title),
                          groupdt != null && groupdt.length > 0 ? Container(
                            height: 133,
                              child: groupListView(groupdt))
                              : Container(),
                          groupdt != null && groupdt.length > 0 ? SizedBox(height: 5,) : Container(),
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
                                    onTap: () {
                                      sort_Click();
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
                          productdt.length>0 ? homeWidget(screenSize.height, screenSize.width)
                          : Container(),

                        ]
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0),
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