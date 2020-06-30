import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/payment.dart';
import '../style.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'login.dart';

class OutstandingPayment extends StatefulWidget{
  final OrderOutstanding outstanding;
  OutstandingPayment({this.outstanding});

  @override
  _OutstandingPayment createState() => _OutstandingPayment();
}
class _OutstandingPayment extends State<OutstandingPayment>{
  DataService dataService = DataService();
  OrderOutstanding dt = new OrderOutstanding();
  String _picked = "Two";
  bool _isRow = true;
  String PasswordEnter = "N";
  String strPassword = "";

  TextEditingController txtAmount = TextEditingController();

  Future<bool> Checknull() async {
  bool chkNull= false;
    if  (txtAmount.text == null || txtAmount.text == "") {
      chkNull = true;
      //return 'Amount cannot be blank. Please check.';
    }
    return chkNull;
  }

  void checkAmount(double amount){
    if(dt.totalAmount - dt.receivedAmount > amount){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              PaymentPage(totalAmount: amount, source: "OP",outstandingitem: widget.outstanding,)));
    }
  }

  @override
  void initState() {

    super.initState();
    dt = widget.outstanding;
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy');

    return MaterialApp(
        title: "Outstanding Payment",
        theme: MasterScreen.themeData(context),

        home: Scaffold(
          appBar: AppBar(
            title: Text('Outstanding Payment',style: TextStyle(color: Colors.white,)),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
                onPressed:() {
                  Navigator.pop(context, false);
                }
            ),
            actions: <Widget>[

            ],
            backgroundColor: Color(0xFFFF8752),
            centerTitle: true,
          ),
          body:
          SingleChildScrollView(
              child:Container(
                color: Colors.transparent,
                padding: const EdgeInsets.fromLTRB(12.0,5,12,10),//I used some padding without fixed width and height
                // Image(image: AssetImage("assets/logo3.png"),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12,),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: titleContainerBgColor,
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      //contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                                      //title: Text('${Dt.storeCode} ${Dt.docNo}  ${Dt.docType } '),
                                      title: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                                '${dt.storeCode}  ${dt.refNo}',
                                                style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '${formatter.format(dt.tranDate)} ',
                                              style: TextStyle(
                                                  fontSize: 12, color: Color(0xFF979B97)),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '${dt.name}',
                                              style: TextStyle(
                                                  fontSize: 12, color: Color(0xFF979B97)),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text("Total Amount: $currencysymbol${formatterint.format(
                                                dt.totalAmount)}",
                                                style: TextStyle(
                                                  fontSize: 14,)),
                                            SizedBox(height: 8,),
                                            Text("Received Amount: $currencysymbol${formatterint.format(
                                                dt.receivedAmount)}",
                                                style: TextStyle(
                                                  fontSize: 14,)),
                                            SizedBox(height: 8,),
                                            Text("Balance Amount: $currencysymbol${formatterint.format(
                                                dt.totalAmount-dt.receivedAmount)}",
                                                style: TextStyle(fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            SizedBox(height: 8,),

                                            dt.nextpaymentDate!=null?
                                            Text(
                                              'Next Due Date: ${formatter.format(dt.nextpaymentDate)}  ',
                                              style: TextStyle(
                                                  fontSize: 12, color: Color(0xFF979B97)),
                                            ):Text(
                                              'Next Due Date: ',
                                              style: TextStyle(
                                                  fontSize: 12, color: Color(0xFF979B97)),
                                            ),
                                            SizedBox(height: 12,),
                                          ]),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtAmount,
                                keyboardType: TextInputType.number,
                                //maxLength: 15,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Enter Amount to Pay',
                                  labelText: "Enter Amount to Pay",
                                  prefixIcon: Icon(Icons.attach_money),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                  ),
                                ),)
                          ),
                        ],
                      ),
                      SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0),
                                side: BorderSide(color:Color(0xFF88A9BB)),
                              ),
                              color: buttonColor,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Continue',style: TextStyle(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold )),
                                ],
                              ),
                              onPressed: () async {
                                var chknull = await Checknull();
                                if(!chknull){
                                  checkAmount(double.parse(txtAmount.text));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12,),
                    ],
                  ),
                ),
              )),
        )
    );
  }
  void showInfoFlushbar(BuildContext context, String msg) {
    Flushbar(
      margin: EdgeInsets.all(8),
      backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.teal]),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      borderRadius: 8,
      title: 'Failed to Register!',
      message: '$msg',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      // leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}