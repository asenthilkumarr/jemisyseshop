import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class CartPage extends StatefulWidget{
  @override
  _cartPage createState() => _cartPage();
}
class _cartPage extends State<CartPage> {
  DataService dataService = DataService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Cart> cartlist = new List<Cart>();
  String dropdownValue = '15';

  Future<List<Cart>> getDefaultData() async {
    var dt = await dataService.GetCart("senthil@jemisys.com");
    cartlist = dt;
    setState(() {

    });
    return dt;
  }
void DeleteCart(Cart dt2, int index) async {
  List<Cart> lparam = [];
  Cart param = new Cart();
  param.eMail = 'senthil@jemisys.com';
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
  Dialogs.showLoadingDialog(context, _keyLoader);//invoking go
  var dt = await dataService.UpdateCart("U", lparam);
  getDefaultData();
  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
}
  Widget CartList(Cart dt, int index){

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
                    padding: const EdgeInsets.only(left:0.0, right: 10.0),
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
                      Text("$currencysymbol${formatterint.format(dt.totalPrice)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 6,),
                      Text(dt.description),
                      SizedBox(height: 6,),
                      dt.itemCode.toString() != "" ? Text("SKU : ${dt.designCode} - ${dt.itemCode.toString()}")
                          : Text("SKU : ${dt.designCode}"),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text("Qty :"),
                              SizedBox(height: 20,
                                child: DropdownButton<String>(
                                  value: cartlist[index].qty.toString(),
                                  //icon: Icon(Icons.arrow_drop_down),
                                  icon: ImageIcon(new AssetImage("assets/dropdownicon.png")),
                                  iconSize: 12,
                                  //elevation: 16,
                                  //style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 0,
                                    //color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      cartlist[index].qty =int.parse(newValue);
                                    });
                                  },
                                  items: <String>['1', '2', '3']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:0.0, right: 8),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(width: 5,),
                          Row(
                            children: [
                              Text("Size :"),
                              SizedBox(height: 20,
                                child: DropdownButton<String>(
                                  value: cartlist[index].jewelSize,
                                  icon: ImageIcon(new AssetImage("assets/dropdownicon.png")),
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
                                  items: <String>['15', '18', '20']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:0.0, right: 8.0),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            ],
                          ),
//                      DropdownButton(),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Text("Ships By:"),
                          Text("Tommorrow", style: TextStyle(fontWeight: FontWeight.bold),)
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
                  onTap: () {
                    DeleteCart(dt, index);
                    //Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Color(0xFF525A4D),
                        child: Icon(Icons.close, color: Colors.white, size: 20,),
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
    getDefaultData();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Cart',
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
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text('Cart', style: TextStyle(color: Colors.white),),
              ],
            ),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() => Navigator.pop(context, false),
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
