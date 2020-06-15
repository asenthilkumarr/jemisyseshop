import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/masterPage.dart';

import 'login.dart';

class CartPage extends StatefulWidget{
  final String pSource;
  final GlobalKey<FormState> masterScreenFormKey;

  CartPage({this.pSource, this.masterScreenFormKey});

  @override
  _cartPage createState() => _cartPage();
}
class _cartPage extends State<CartPage> {
  DataService dataService = DataService();
  final _keyLoader = new GlobalKey<FormState>();
  List<Cart> cartlist = new List<Cart>();
  String dropdownValue = '15';
  String txtTitle="";
  String source = "S";
  List<String> qtylist = ["1", "2", "3"];
  List<String> sizelist = ['15', '18', '20'];

  Future<List<Cart>> getDefaultData(String _source) async {
    cartlist = new List<Cart>();
    var dt = await dataService.GetCart(userID, _source);
    cartlist = dt;
    if(widget.pSource=="S"){
      cartCount = dt.length;
      widget.masterScreenFormKey?.currentState?.reset();
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
    param.itemCode = dt2.itemCode;
    param.onlineName = dt2.onlineName;
    param.description = dt2.description;
    param.qty = 0;
//    param.jewelSize = "";
    param.unitPrice = dt2.unitPrice;
    param.totalPrice = dt2.totalPrice;
    param.shippingDays = 0;
    param.isSizeCanChange = true;
    param.orderType = dt2.orderType;
    lparam.add(param);
    var dt = await dataService.UpdateCart("U", lparam);
    await getDefaultData(source);

  }

  void AddtoWishlist(Cart sItem, String oType) async{
    if(isLogin == true){
      List<Cart> lparam = [];
      Cart param = new Cart();
      param.eMail = userID;
      param.recordNo = 0;
      param.designCode = sItem.designCode;
      param.itemCode = sItem.itemCode;
      param.onlineName = sItem.onlineName;
      param.description = sItem.description;
      param.qty = 1;
      param.jewelSize = sItem.jewelSize;
      param.unitPrice = sItem.unitPrice;
      param.totalPrice = sItem.totalPrice;
      param.shippingDays = 7;
      param.isSizeCanChange = true;
      param.orderType = oType;
      lparam.add(param);

      var dt = await dataService.UpdateCart("I", lparam);


    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()),);
    }
  }

  Widget CartList(Cart dt, int index) {
    bool isSizevlid = false;
    for(var a in sizelist){
      if(dt.jewelSize != null && dt.jewelSize == a){
        isSizevlid = true;
        break;
      }
    }
    if(isSizevlid == false)
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
                    child: Image(
                      image: CachedNetworkImageProvider(
                        dt.imageFileName,
                      ),
                      fit: BoxFit.fitWidth,
                      width: 100,
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
                          dt.isSizeCanChange == true ? Row(
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
                              : Container(),
//                      DropdownButton(),
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
                        await DeleteCart(dt, index);
                        await AddtoWishlist(dt, "W");
                        Navigator.of(
                            _keyLoader.currentContext, rootNavigator: true)
                            .pop(); //close the dialoge

                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(pSource: "W",
                                    masterScreenFormKey: widget
                                        .masterScreenFormKey,)),);
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
          ],
        ),
      ),
    );
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

    return MaterialApp(
      title:  'Cart',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(txtTitle, style: TextStyle(color: Colors.white),),
              ],
            ),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() {
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
            backgroundColor: Color(0xFFFF8752),
            centerTitle: true,
          ),
          body: SafeArea(
              child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0, 1],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Color(0xFFF0F1EE),
                            Color(0xFFF0F1EE),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: cartlist.length,
                      itemBuilder: (BuildContext context, int index) =>
                          CartList(cartlist[index], index),
                    )
/*
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //Customtitle(context, "Cart"),

                        /*
                              FutureBuilder<List<Cart>>(
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
                              */
                            ]
                        ),
                      ),
                    ),
                    */
                  ]
              )
          ),
        bottomNavigationBar: BottomAppBar(

      child: Container(
      height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left:1.0, right: 1.0),
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height:50,
                    child: RaisedButton(
                      color: Color(0xFF517295),
                      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "PLACE ORDER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {

                      },
                    ),
                  ),
                ),
              ]
          ),
        ),
      )
    ),
      ),
    );
  }
}
