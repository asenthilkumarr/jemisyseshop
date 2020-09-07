import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';

class VoucherDetailPage extends StatefulWidget {
  @override
  _VoucherDetailPageState createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  ScrollController _scrollController2 = new ScrollController();
  Commonfn cfobj = Commonfn();
  List<Voucher> itemDt = [];
  DataService dataService = new DataService();

  final dateformat = DateFormat('yyyy/MM/dd');
  final fdatetime = new DateFormat('dd-MM-yyyy');

  Widget tradeIcon(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              text: '${data.voucherName}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: '${data.voucherType}' == 'WV' ? Colors.green : '${data.voucherType}' == 'GV' ? Colors.blueAccent : Colors.redAccent, fontSize: 25),
            ),
          )
      ),
    );
  }

  Widget tradeNameSymbol(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '${data.voucherNo}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
          children: <TextSpan>[
            TextSpan(
                text: '\n${fdatetime.format(DateTime.parse(data.expiryDate))}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget tradeStatus(data) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                text: '${data.status}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
              )
          )
      ),
    );
  }

  Widget tradeAmount(data) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: '${data.voucherNo}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n31-12-2020',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tradeWeight(data) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '\n$currencysymbol${formatter2dec.format(data.voucherValue)}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Voucher>> _fetchVoucherList() async {
    itemDt = new List<Voucher>();
    var dt = await dataService.getVouchers(userID);
    setState(() {
      itemDt = dt;
    });
    return dt;
  }

  @override
  void initState() {
    _fetchVoucherList();
    super.initState();
    _scrollController2 = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final screenSize = MediaQuery
        .of(context)
        .size;
    screenWidth = screenSize.width;
    if(kIsWeb){
      screenWidth =  cfobj.ScreenWidth(screenSize.width);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Voucher Details',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
        ),
        backgroundColor: Color(0xFFFF8752),
      ),
      //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
      body: Row(
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController2,
                        scrollDirection: Axis.vertical,
                        itemCount: itemDt.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 140,
                            width: double.maxFinite,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  /*border: Border(
                                    top: BorderSide(
                                        width: 2.0, color: itemDt[index].buySell == 'B' ? Colors.green : Colors.red),
                                  ),*/
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(left: 0, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      tradeIcon(itemDt[index]),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      //tradeNameSymbol(itemDt[index]),
                                                      Spacer(),
                                                      tradeStatus(itemDt[index]),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      //changeIcon(itemDt[index]),
                                                      //SizedBox(
                                                      //   width: 20,
                                                      //)
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      tradeAmount(itemDt[index]),
                                                      Spacer(),
                                                      tradeWeight(itemDt[index])
                                                    ],
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          );
                        }),
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
      /*bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              //width: 50.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0),
                      child: Icon(
                        Icons.filter,
                        color: Color(0xFFFF8752),
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Filter",
                        style: TextStyle(
                            color: Color(0xFFFF8752),
                            fontSize: 12
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {

                },
              ),
            ),
            SizedBox(
              width: 165.0,
            ),
            SizedBox(
              //width: 60.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0),
                      child: Icon(
                        Icons.refresh,
                        color:Color(0xFFFF8752),
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Refresh",
                        style: TextStyle(
                            color: Color(0xFFFF8752),
                            fontSize: 12
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                },
              ),
            ),
          ],
        ),
      ),*/
    );
  }
}
