import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/style.dart';

class PaymentPage extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  final Address sAddress;
  final Address dAddress;
  PaymentPage({this.itemCount, this.totalAmount, this.sAddress, this.dAddress});
  @override
  _paymentPage createState() => _paymentPage();
}
class _paymentPage extends State<PaymentPage> {
  double sumValue = 0;
  int itemCount = 0;
  int id = 1;
  String radioItem = 'Master / VISA Card';
  List<RadioButtonListValue> fList = [
    RadioButtonListValue(
      index: 1,
      name: "Master / VISA Card",
    ),
    RadioButtonListValue(
      index: 2,
      name: "eNETS",
    ),
  ];

  void _handleRadioValueChange(RadioButtonListValue value) {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    sumValue = widget.totalAmount;
    itemCount = widget.itemCount;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Payment", style: TextStyle(color: title1Color),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: title1Color,),
              onPressed: () {
                Navigator.pop(context, false);
              }
          ),
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
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
                      Color(0xFFFFEBEE),
                      Color(0xFFFFFFE0),//0xFFEDE7F6
                    ],
                  ),
                ),

                /*
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
                */
              ),
              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: buttonColor,
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Amount Payable",
                                    style: TextStyle(
                                        color: buttonTextColor, fontSize: 17),),
                                )),),
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                      "$currencysymbol${formatterint.format(
                                          sumValue)}", style: TextStyle(
                                      color: buttonTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                                )),),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                      child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                children: [
                                  Container(
                                    color: buttonTextColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text("xCLusive Points", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                          SizedBox(height: 5,),
                                          Container(
//                                            color: Color(0xFFFAFAFA),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("You currently don't have any xCLusive ponts", style: TextStyle(color: lightTextColor),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        ),
                                        Container(
                                          child: Column(
                                            children:
                                            fList.map((data) => Padding(
                                              padding: const EdgeInsets.only(left: 8.0, bottom: 3.0, right: 8.0),
                                              child: GestureDetector(
                                                onTap: (){
                                                    setState(() {
                                                      radioItem = data.name ;
                                                      id = data.index;
                                                      _handleRadioValueChange(data);
                                                    });
                                                  },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: titleContainerBgColor,
                                                    )
                                                  ),
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Radio(
                                                            value: data.index,
                                                            groupValue: id,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                radioItem = data.name ;
                                                                id = data.index;
                                                                _handleRadioValueChange(data);
                                                              });
                                                            },
                                                          ),
                                                          Text("${data.name}",),
                                                        ],
                                                      ),
                                                    ),
                                                ),
                                              ),
                                            )
                                            ).toList(),
                                          ),
                                        ),
                                        SizedBox(height: 8,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                ]
                            ),
                          )
                      )
                  )
                ],
              ),
            ],
          ),
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
                            color: buttonColor,
                            padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "Pay Now       ($currencysymbol${formatterint.format(
                                    sumValue)})",
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontSize: 15, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if(radioItem == 'Master / VISA Card'){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentDetailPage(itemCount: itemCount,totalAmount: sumValue,source: "card",sAddress: widget.sAddress, dAddress: widget.dAddress,)));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentDetailPage(itemCount: itemCount,totalAmount: sumValue,source: "eNETS",sAddress: widget.sAddress, dAddress: widget.dAddress,)));
                              }
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

class PaymentDetailPage extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  final String source;
  final Address sAddress;
  final Address dAddress;
  PaymentDetailPage({this.itemCount, this.totalAmount, this.source, this.sAddress, this.dAddress});
  @override
  _paymentDetailPage createState() => _paymentDetailPage();
}
class _paymentDetailPage extends State<PaymentDetailPage> {
  DataService dataService = DataService();
  OrderData param=new OrderData();

  var sX = 0.0;
  var sY = 0.0;
  var textVar = "";
  TextEditingController txtCardNo = TextEditingController();
  TextEditingController txtExpiry = TextEditingController();
  TextEditingController txtCVV = TextEditingController();
  TextEditingController txtNameoncard = TextEditingController();

  void UpdatePayment() async{
    param.eMail = userID;
    param.totalAmount = widget.totalAmount;
    param.discount = 0;
    param.netAmount = widget.totalAmount;
    param.deliveryMode = "H";
    param.shippingAddress = widget.sAddress;
    param.billingAddress = widget.dAddress;
    param.dstoreCode = null;
    param.payMode1 = "VISA / MASTER";
    param.payMode1_Amt = widget.totalAmount;
    param.payMode1_Ref = "435435676756765";
    param.payMode2 = null;
    param.payMode2_Amt = 0;
    param.payMode2_Ref = null;
    param.payMode3 = null;
    param.payMode3_Amt = 0;
    param.payMode3_Ref = null;
    param.mode = "I";
    var result = await dataService.UpdateOrder(param);
    if(result.status == 1){
      await Dialogs.AlertMessage(context, "Order Completed");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          MasterScreen(currentIndex: 0, key: null,)), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Details',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Payment Details", style: TextStyle(
              color: title1Color),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: title1Color,),
              onPressed: () {
                Navigator.pop(context, false);
              }
          ),
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
                widget.source == "card" ? Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                child: Stack(
                                  children: <Widget>[
                                    ConstrainedBox(
                                      child: Image.asset("assets/cardTemplet.png", fit: BoxFit.fitWidth,),
                                      constraints: BoxConstraints.expand(),
                                    ),
                                    Container(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: sX, sigmaY: sY),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100.withOpacity(0.2),
                                          ),
                                          child: Center(child: Text(textVar)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
                              TextField(
                                controller: txtCardNo,
                                autocorrect: true,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  isDense: true,
//                                      hintText: 'Full Name',
                                  labelText: "Card Numher",
//                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 20, right: 20),
                                ),),
                              SizedBox(height: 15,),
                              TextField(
                                controller: txtExpiry,
                                autocorrect: true,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  isDense: true,
                                      hintText: 'Expiry',
                                  labelText: "MM/YY",
//                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 20, right: 20),
                                ),),
                              SizedBox(height: 15,),
                              TextField(
                                controller: txtCVV,
                                autocorrect: true,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  isDense: true,
//                                      hintText: 'Full Name',
                                  labelText: "CVV",
//                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 20, right: 20),
                                ),),
                              SizedBox(height: 15,),
                              TextField(
                                controller: txtNameoncard,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
//                                      hintText: 'Full Name',
                                  labelText: "Name on card",
//                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 20, right: 20),
                                ),),
                              SizedBox(height: 15,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Container(),
              ]
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            color: buttonColor,
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "Pay Now       ($currencysymbol${formatterint.format(
                                    widget.totalAmount)})",
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontSize: 15, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              UpdatePayment();
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