import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/view/outstandingPayment.dart';
import '../style.dart';
import 'masterPage.dart';

class OrderOutstandingList extends StatefulWidget {
  @override
  _State createState() => new _State();
}
//State is information of the application that can change over time or when some actions are taken.
class _State extends State<OrderOutstandingList>{
  ScrollController _scrollController2 = new ScrollController();
  DataService obj = new DataService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<OrderOutstanding> itemDt = [];
  double sumValue = 0;
  double shippingCharge = 0;
  double shippingInsurance = 0;
  int itemCount = 0;
  final format = DateFormat('yyyy/MM/dd');
  final fdatetime = new DateFormat('dd-MM-yyyy hh:mm aa');
  final fdate = new DateFormat('dd-MM-yyyy');
  bool _isOnTop = true;
  DataService dataService = DataService();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  _scrollToTop() {
    _scrollController2.animateTo(_scrollController2.position.minScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }


  Future<List<OrderOutstanding>> _fetchOrderList() async {
    //Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    itemDt = new List<OrderOutstanding>();
    var dt = await dataService.GetOrderOutstanding('ramesh@jemisys.com');
    itemDt = dt;
    return dt;
  }

  ListView Orderlist(List<OrderOutstanding> data) {
    return
      new ListView.builder(
        controller: _scrollController2,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            Doclist(data[index]),
      );
  }

  Widget Doclist(OrderOutstanding Dt){
    var formatter = new DateFormat('dd-MM-yyyy');
    return  new Card(
      elevation:8,
      // margin: EdgeInsets.all(7.0),
      margin: EdgeInsets. fromLTRB(8.0,3.0,7.0,4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Colors.white,

      child: new Container(
        padding: EdgeInsets.fromLTRB(0,2,0,0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              //contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
              leading:
              Padding(
                padding: const EdgeInsets.fromLTRB(0,50,0,0),
                child: Icon(Icons.arrow_right, color: Color.fromARGB(255, 255, 51, 9), size: 40),
              ),
              //title: Text('${Dt.storeCode} ${Dt.docNo}  ${Dt.docType } '),
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        '${Dt.storeCode}   ${Dt.refNo} ',
                        style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${formatter.format(Dt.tranDate)} ',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF979B97)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${Dt.name} ',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF979B97)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Total Amount: $currencysymbol${formatterint.format(
                        Dt.totalAmount)}",
                        style: TextStyle(
                          fontSize: 14,)),
                    SizedBox(height: 8,),
                    Text("Received Amount: $currencysymbol${formatterint.format(
                        Dt.receivedAmount)}",
                        style: TextStyle(
                          fontSize: 14,)),
                    SizedBox(height: 8,),
                    Text("Balance Amount: $currencysymbol${formatterint.format(
                        Dt.totalAmount - Dt.receivedAmount)}",
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),

                    Dt.nextpaymentDate!=null?
                    Text(
                      'Next Due Date: ${formatter.format(Dt.nextpaymentDate)}  ',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF979B97)),
                    ):Text(
                      'Next Due Date: ',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF979B97)),
                    ),
                  ]),

              trailing: Container(
                child:CircleAvatar(
                  child: Center(
                    child: ClipOval(
                      child: IconButton(icon: Icon(Icons.attach_money,size: 35,
                        color: Colors.yellowAccent ,),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OutstandingPayment(outstanding: Dt,)),);  // do what you need to do when "Click here" gets clicked

                          }),
                    ),
                  ),
                  radius: 25,
                  backgroundColor: listLabelbgColor ,
                ),

              ),
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController2 = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double screenhight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: MasterScreen.themeData(context),
      home:  Scaffold(
        appBar: AppBar(
          title: Text('Outstanding Orders', style: TextStyle(color: Colors.white),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context, false);
              }
          ),

          backgroundColor: Color(0xFFFF8752),
          centerTitle: true,
        ),     body:
      Container(
        padding: const EdgeInsets.fromLTRB(10,8,10,5),
        child:  FutureBuilder<List<OrderOutstanding>>(
          future: _fetchOrderList(),
          builder: (context, snapshot) {
            if (itemDt.length > 0) {
              List<OrderOutstanding> data = itemDt;
              return Orderlist(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
              //return Text("No Record found");
            }
            //return Container();
            return Text("No Record found!");
          },
        ),
      ),

      ),
    );

  }
}

