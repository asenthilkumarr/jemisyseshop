import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/cart.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/productDetails.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class OrderPage extends StatefulWidget{
  final List<Cart> itemlist;
  final GlobalKey<FormState> masterScreenFormKey;
  final String source;
  OrderPage({this.itemlist, this.masterScreenFormKey, this.source});

  @override
  _orderPage createState() => _orderPage();
}
class _orderPage extends State<OrderPage> {
  DataService dataService = DataService();
  Commonfn cfobj = Commonfn();
  List<Cart> cartlist = new List<Cart>();
  double sumValue = 0;
  double shippingCharge = 0;
  double shippingInsurance = 0;
  int itemCount = 0;
  List<String> sizelist = ['15', '18', '20'];

  void loadDefault() async {
    cartlist = widget.itemlist;
    sumValue = 0;
    itemCount = 0;
    for (var i in cartlist) {
      sumValue += i.totalPrice;
      itemCount++;
    }
    setState(() {

    });
  }
  Widget CartList(Cart dt, int index) {
    bool isSizevlid = false;
    for (var a in sizelist) {
      if (dt.jewelSize != null && dt.jewelSize == a) {
        isSizevlid = true;
        break;
      }
    }
    if (isSizevlid == false)
      sizelist.add(dt.jewelSize);
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    var shipday = new DateTime(now.year, now.month, now.day + dt.shippingDays);
    String formattedDate = formatter.format(shipday);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 15.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        _product_onTap(dt, context);
                      },
                      child: Image(
                        image: CachedNetworkImageProvider(
                          dt.imageFileName,
                        ),
                        fit: BoxFit.fitWidth,
                        width: 100,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$currencysymbol${formatterint.format(
                          dt.totalPrice)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Text(dt.description,
                        style: TextStyle(color: Color(0xFF7A7E7A)),),
                      SizedBox(height: 10,),
                      dt.itemCode.toString() != "" ? Text(
                        "SKU : ${dt.designCode} - ${dt.itemCode.toString()}",
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF979B97)),)
                          : Text("SKU : ${dt.designCode}",
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF979B97)),),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text("Size :"),
                          Text(dt.jewelSize)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text("Ships By:"),
                          Text(formattedDate, style: TextStyle(
                              fontWeight: FontWeight.normal),)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _product_onTap(Cart selItem, BuildContext context) async {
    List<Product> item = [];
    if (selItem.itemCode != "")
      item = await getProductDetail("FROMCART", selItem.itemCode, 0);
    else
      item =
      await getProductDetail("FROMCART", selItem.designCode, selItem.version);
    if (item.length > 0) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            ProductDetailPage(product: item[0],
              title: item[0].itemCode,
              masterScreenFormKey: widget.masterScreenFormKey,
              source: "Cart",),)
      );
    }
  }
  Future<List<Product>> getProductDetail(String productType, String designCode,
      int version) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.designCode = designCode;
    param.version = version;
    param.where = "";
    var dt = await dataService.getProductDetails(param);
    return dt;
  }
  static const snackBarDuration = Duration(seconds: 3);
  DateTime backButtonPressTime;
  Future<bool> onWillPop() async {
    if (homeScreen == 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              MasterScreen(currentIndex: 0, key: null,)), (
          Route<dynamic> route) => false);
    }
    else if (homeScreen == 2) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              MasterPage2(currentIndex: 0, key: null,)), (
          Route<dynamic> route) => false);
    }
    return false;
  }

  void initState(){
    super.initState();
    loadDefault();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    screenWidth = screenSize.width;
    if(kIsWeb){
      screenWidth =  cfobj.ScreenWidth(screenSize.width);
    }

    return MaterialApp(
      title: 'Order',
      theme: MasterScreen.themeData(context),
      home: WillPopScope(
        onWillPop: () => onWillPop(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.source == "HT" ? "Home Try-On" : "Order Summary",
              style: TextStyle(color: Colors.white),),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                onPressed: () {
                  if (homeScreen == 1) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) =>
                            MasterScreen(currentIndex: 0, key: null,)), (
                        Route<dynamic> route) => false);
                  }
                  else if (homeScreen == 2) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) =>
                            MasterPage2(currentIndex: 0, key: null,)), (
                        Route<dynamic> route) => false);
                  }
                }
            ),
            backgroundColor: primary1Color,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(-0.4, -0.8),
                          stops: [0.0, 0.5, 0.5, 1],
                          colors: [
                            Color(0xfffff7f3), //red
                            Color(0xffffffff), //red
                            Color(0xffffffff), //orange
                            Color(0xffffffff), //orange
                          ],
                          tileMode: TileMode.repeated
                      ),

                    ),
                  ),
                  Row(
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children : [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: listLabelbgColor,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(5),

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.max,

                                            children: [
                                              Wrap(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 25.0,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(fontSize: 18, color: Colors.green),
                                                      children: [
                                                        TextSpan(
                                                          text: widget.source == "IP" ? " Thank you, your payment updated successfully."
                                                              : widget.source == "HT" ? " Thank you, your request has been placed."
                                                              : " Thank you, your order updated successfully.",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Text("An email confirmation has been send to you."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: 0.0,
                                          child: GestureDetector(
                                            onTap: () async {
                                              if(homeScreen == 1) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MasterScreen(
                                                              currentIndex: 0,
                                                              key: null,)), (Route<dynamic> route) => false);
                                              }
                                              if(homeScreen == 2) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MasterPage2(
                                                              currentIndex: 0,
                                                              key: null,)), (Route<dynamic> route) => false);
                                              }
//                                            Navigator.of(context).pop();
                                            },
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 12.0,
                                                  backgroundColor: primary1Color,
                                                  child: Icon(
                                                    Icons.close, color: Colors.white, size: 20,),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ]
                                  ),
                                  widget.source != "IP" ? Column(
                                    children: [
                                      for(var i = 0; i < cartlist.length; i++)
                                        CartList(cartlist[i], i),
                                      sumValue != 0 ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0, top: 30.0, bottom: 30),
                                          child: Column(
                                            children: [
                                              Text("Summary", style: TextStyle(fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),),
                                              SizedBox(height: 15,),
                                              Row(
//                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Expanded(
                                                      child: Text("Sub Total")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          "$currencysymbol${formatterint
                                                              .format(sumValue)}",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold),)),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text("Shipping Charge")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: shippingCharge != 0 ? Text(
                                                            "$currencysymbol${formatterint
                                                                .format(shippingCharge)}")
                                                            : Text("Free")),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text("Shipping Insurance")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: shippingInsurance != 0 ? Text(
                                                            "$currencysymbol${formatterint
                                                                .format(shippingInsurance)}")
                                                            : Text("Free")),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text("Grand Total")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                            "$currencysymbol${formatterint
                                                                .format(sumValue)}",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold))),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 25,),
                                            ],
                                          ),
                                        ),
                                      ) : Container(),
                                    ],
                                  ) : Container(),

                                ],
                              ),
                            ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: webRightContainerColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}