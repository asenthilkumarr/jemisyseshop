import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/appointment.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/productDetails.dart';
import 'package:jemisyseshop/view/address.dart';
import 'login.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CartPage extends StatefulWidget{
  final String pSource;
  final GlobalKey<FormState> masterScreenFormKey;

  CartPage({this.pSource, this.masterScreenFormKey});

  @override
  _cartPage createState() => _cartPage();
}
class _cartPage extends State<CartPage> {
  DataService dataService = DataService();
  Commonfn cfobj = Commonfn();
  final _keyLoader = new GlobalKey<FormState>();
  List<Cart> cartlist = new List<Cart>();
  String dropdownValue = '15';
  String txtTitle = "";
  String source = "S";
  List<String> qtylist = ["1", "2", "3"];
  List<String> sizelist = ['15', '18', '20'];
  double sumValue = 0;
  double shippingCharge = 0;
  double shippingInsurance = 0;
  int itemCount = 0;

  Future<List<Cart>> getDefaultData(String _source) async {
    cartlist = new List<Cart>();
    var dt = await dataService.getCart(userID, _source);
    cartlist = dt;
    if (widget.pSource == "S") {
      cartCount = dt.length;
      widget.masterScreenFormKey?.currentState?.reset();
    }
    sumValue = 0;
    itemCount = 0;
    for (var i in dt) {
      sumValue += i.totalPrice;
      itemCount++;
    }
    setState(() {

    });
    return dt;
  }

  void DeleteCart(Cart dt2, int index) async {
    List<Cart> lparam = [];
    Cart param = new Cart();
    param.eMail = userID;
    param.recordNo = dt2.recordNo;
    param.designCode = dt2.designCode;
    param.version = dt2.version;
    param.itemCode = dt2.itemCode;
    param.onlineName = dt2.onlineName;
    param.description = dt2.description;
    param.qty = 0;
    param.jewelSize = dt2.jewelSize;
    param.unitPrice = dt2.unitPrice;
    param.totalPrice = dt2.totalPrice;
    param.shippingDays = 0;
    param.isSizeCanChange = dt2.isSizeCanChange;
    param.orderType = dt2.orderType;
    lparam.add(param);
    var dt = await dataService.updateCart("U", lparam);
    await getDefaultData(source);
  }

  void AddtoWishlist(Cart sItem, String oType, String mode) async {
    if (isLogin == true) {
      List<Cart> lparam = [];

      Cart param = new Cart();
      param.eMail = userID;
      param.recordNo = sItem.recordNo;
      param.designCode = sItem.designCode;
      param.version = sItem.version;
      param.itemCode = sItem.itemCode;
      param.onlineName = sItem.onlineName;
      param.description = sItem.description;
      param.qty = sItem.qty;
      param.jewelSize = sItem.jewelSize;
      param.unitPrice = sItem.unitPrice;
      param.totalPrice = sItem.totalPrice;
      param.shippingDays = 7;
      param.isSizeCanChange = sItem.isSizeCanChange;
      param.orderType = oType;
      lparam.add(param);

      var dt = await dataService.updateCart(mode, lparam);
      await getDefaultData(source);
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()),);
    }
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
                          /*
                          Row(
                            children: [
                              Text("Qty :"),
                              SizedBox(height: 20,
                                child: DropdownButton<String>(
                                  value: cartlist[index].qty.toString(),
                                  //icon: Icon(Icons.arrow_drop_down),
                                  icon: ImageIcon(new AssetImage(
                                      "assets/dropdownicon.png")),
                                  iconSize: 12,
                                  //elevation: 16,
                                  //style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 0,
                                    //color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      cartlist[index].qty = int.parse(newValue);
                                    });
                                  },
                                  items: qtylist
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, right: 8),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(width: 20,),
                          */
                          dt.isSizeCanChange == true && dt.itemCode == "" ? Row(
                            children: [
                              Text("Size :"),
                              SizedBox(height: 20,
                                child: DropdownButton<String>(
                                  value: cartlist[index].jewelSize,
                                  icon: ImageIcon(new AssetImage(
                                      "assets/dropdownicon.png")),
                                  iconSize: 12,
                                  elevation: 16,
                                  //style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 0,
                                    //color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      cartlist[index].jewelSize = newValue;
                                    });
                                  },
                                  items: sizelist
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, right: 8.0),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            ],
                          )
                              : dt.isSizeCanChange == true && dt.itemCode != ""
                              ? Row(
                            children: [
                              Text("Size :"),
                              Text(dt.jewelSize)
                            ],
                          )
                              : Container(),
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
            Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () async {
                    if (source == "S") {
                      var result = await Dialogs.ConfirmDialogWithCancel(
                          context, "Confirm Remove",
                          "Are you sure you want to remove this jewellery?",
                          "Remove", "Move to Wishlist");
                      if (result == "Remove") {
                        Dialogs.showLoadingDialog(
                            context, _keyLoader); //invoking go
                        await DeleteCart(dt, index);
                        Navigator.of(
                            _keyLoader.currentContext, rootNavigator: true)
                            .pop(); //close the dialoge
                      }
                      if (result == "Move to Wishlist") {
                        Dialogs.showLoadingDialog(
                            context, _keyLoader); //invoking go
//                        await DeleteCart(dt, index);
                        await AddtoWishlist(dt, "W", "S2W");
                        Navigator.of(
                            _keyLoader.currentContext, rootNavigator: true)
                            .pop(); //close the dialoge
//
//                        Navigator.pop(context);
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  CartPage(pSource: "W",
//                                    masterScreenFormKey: widget
//                                        .masterScreenFormKey,)),);
                      }
                      else {

                      }
                    }
                    else {
                      var result = await Dialogs.ConfirmDialog(
                          context, "Confirm Remove",
                          "Are you sure you want to remove this jewellery?",
                          "Remove", "Cancel");
                      if (result == false) {
                        Dialogs.showLoadingDialog(
                            context, _keyLoader); //invoking go
                        await DeleteCart(dt, index);
                        Navigator.of(
                            _keyLoader.currentContext, rootNavigator: true)
                            .pop(); //close the dialoge
                      }
                    }

                    //Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Color(0xFF525A4D),
                        child: Icon(
                          Icons.close, color: Colors.white, size: 20,),
                      ),
                    ),
                  ),
                )),
            source == "W" ? Positioned(
                right: 0.0,
                bottom: 0.0,
                child: GestureDetector(
                  onTap: () async {
                    var result = await Dialogs.ConfirmDialog(
                        context, "Confirm move to cart",
                        "Are you sure you want to move this jewellery to cart?",
                        "Move", "Cancel");
                    if (result == false) {
                      Dialogs.showLoadingDialog(
                          context, _keyLoader); //invoking go
                      await AddtoWishlist(dt, "S", "W2S");
                      Navigator.of(
                          _keyLoader.currentContext, rootNavigator: true)
                          .pop(); //close the dialoge
                    }

                    //Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: primary1Color,
                        child: Icon(
                          Icons.shopping_cart, color: Colors.white, size: 20,),
                      ),
                    ),
                  ),
                ))
                : Container(),
          ],
        ),
      ),
    );
  }

  void proceedToOrder() async {
    if (source == "S" && itemCount > 0) {
      var status = await dataService.getCheckStockOnline(customerdata.eMail, source);
      if (status.status == 1 && status.returnStatus == "OK") {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                AddressPage(itemCount: itemCount,
                  totalAmount: sumValue, itemList: cartlist,masterScreenFormKey: widget.masterScreenFormKey,)));
      }
      else {
        await Dialogs.AlertMessage(context, status.returnStatus);
      }
    }
    else if (source == "H" && itemCount > 0) {
      var status = await dataService.getCheckStockOnline(customerdata.eMail, source);
      if (status.status == 1 && status.returnStatus == "OK") {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                Appointment(itemCount: itemCount,
                  totalAmount: sumValue, itemList: cartlist,)));
      }
      else {
        await Dialogs.AlertMessage(context, status.returnStatus);
      }
    }
    else if (itemCount == 0) {
      await Dialogs.AlertMessage(
          context, "Cart cannot be blank, please check.");
    }
  }

  @override
  void initState() {
    super.initState();
    source = widget.pSource;
    getDefaultData(source);
    if (widget.pSource == "S") {
      txtTitle = "Cart";
    }
    else if (widget.pSource == "W") {
      txtTitle = "Wishlist";
    }
    else if (widget.pSource == "H") {
      txtTitle = "Home Try-On";
    }
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

    return MaterialApp(
      title: 'Cart',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text(txtTitle, style: TextStyle(color: Colors.white),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
//                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//                    MasterScreen()), (Route<dynamic> route) => false);
                Navigator.pop(context, false);
              }
          ),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.home,color: Colors.white,),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
//            ],
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
        body: SafeArea(
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
                          constraints: BoxConstraints(
                              minWidth: 250, maxWidth: screenWidth),
                          child: Column(
                            children: [
                              Container(
                                color: Color(0xFF517295),
                                height: 45,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0,
                                      0.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text("Items ($itemCount)",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17),),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                  "$currencysymbol${formatterint
                                                      .format(
                                                      sumValue)}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight
                                                          .bold)),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for(var i = 0; i < cartlist.length; i++)
                                        CartList(cartlist[i], i),
                                      sumValue != 0 ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 30.0,
                                              bottom: 30),
                                          child: Column(
                                            children: [
                                              Text("Summary",
                                                style: TextStyle(fontSize: 20.0,
                                                    fontWeight: FontWeight
                                                        .bold),),
                                              SizedBox(height: 15,),
                                              Row(
//                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Expanded(
                                                      child: Text("Sub Total")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "$currencysymbol${formatterint
                                                              .format(
                                                              sumValue)}",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold),)),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "Shipping Charge")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: shippingCharge !=
                                                            0
                                                            ? Text(
                                                            "$currencysymbol${formatterint
                                                                .format(
                                                                shippingCharge)}")
                                                            : Text("Free")),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "Shipping Insurance")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: shippingInsurance !=
                                                            0
                                                            ? Text(
                                                            "$currencysymbol${formatterint
                                                                .format(
                                                                shippingInsurance)}")
                                                            : Text("Free")),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "Grand Total")),
                                                  Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                            "$currencysymbol${formatterint
                                                                .format(
                                                                sumValue)}",
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
                                  ),

                                ),
                              ),
                            ],

                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: webRightContainerColor,
                        ),
                      ),
                    ],
                  ),
                ]
            )
        ),
        bottomNavigationBar: source != "W" ? BottomAppBar(
            child: Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          color: webLeftContainerColor,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 250, maxWidth: screenWidth),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: RaisedButton(
                                color: Color(0xFF517295),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    source == "S"
                                        ? "PLACE ORDER"
                                        : "Make an appointment",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15, fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  proceedToOrder();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: webRightContainerColor,
                        ),
                      ),
                    ]
                ),
              ),
            )
        )
            : Container(height: 1,),
      ),
    );
  }
}
