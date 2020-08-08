import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MyTransactionPage extends StatefulWidget{
  @override
  _myTransactionPage createState() => _myTransactionPage();
}
class _myTransactionPage extends State<MyTransactionPage> {
  DataService dataService = DataService();
  Commonfn cfobj = Commonfn();
  List<OrderH> orderH = new List<OrderH>();
  List<OrderD> orderD = new List<OrderD>();

  final formatdate = DateFormat('dd-MM-yyyy');
  final formatdatewithTime = DateFormat('dd-MM-yyyy hh:mm a');
  final Color textColor = Color(0xFF6F6F6F);
  void loadDefault() async{
    OrderGetParam param = new OrderGetParam();
    param.eMail = userID;
    param.orderType = "S";
    orderH = await dataService.getOrderH(param);
    orderD = await dataService.getOrderD(param);
    setState(() {

    });
  }

  Future<List<OrderD>> getOrderD(String orderNo) async{
    List<OrderD> data = orderD.where((e) => e.orderNo == orderNo).toList();
    return data;
  }
  void updateVisablity(String orderNo, bool isVisable){
//    bool isVisable = true;
    for(var i=0; i<orderD.length; i++){
      if(orderD[i].orderNo == orderNo){
        orderD[i].isVisible = isVisable;
//        isVisable = false;
      }
    }

    setState(() {

    });
  }
  @override
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
      title: 'My Transaction',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Transaction', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
//              scaffoldKey.currentState.openDrawer();
            },
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
                          child: ListView(
                            children: [
                              orderH != null && orderH.length>0 ? Column(
                                children: [
                                  for(var i = 0;i<orderH.length;i++)
                                    Padding(
                                      padding: const EdgeInsets.only(left:0.0, right: 0.0, top: 4.0, bottom: 10),
                                      child: Card(
                                        elevation: 15,
                                        margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 1.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            FutureBuilder<List<OrderD>>(
                                              future: getOrderD(orderH[i].orderNo),
                                              // ignore: missing_return
                                              builder: (context, snapshot){
                                                if(snapshot.hasData) {
                                                  return Container(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Container(
                                                          color: listbgColor,
                                                          child: Padding(
                                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(orderH[i].orderNo, style: TextStyle(fontWeight: FontWeight.bold),),
                                                                  Spacer(),
                                                                  orderH[i].invoiceNo != null && orderH[i].invoiceNo != '' ? Text("INVOICING DONE", style: TextStyle(color: Colors.redAccent),)
                                                                      : orderH[i].shipRefNo != null && orderH[i].invoiceNo != '' ? Text("SHIPPING DONE", style: TextStyle(color: Colors.redAccent),)
                                                                      : Text("ORDER TAKEN", style: TextStyle(color: Colors.redAccent),),
//                                                              Text(formatdate.format(orderH[i].orderDate)),
                                                                ],
                                                              )),
                                                        ),
                                                        Padding(
                                                            padding: const EdgeInsets.fromLTRB(0.0,0.0, 0.0, 0.0),
                                                            child: Column(
                                                                children: [
                                                                  SizedBox(height: 5,),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          width: 1,
                                                                          color: listLabelbgColor,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    ),
                                                                    padding: EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 120,
                                                                              child:                     Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                children: [
                                                                                  Text('Order Date:', style: TextStyle(color: textColor), textAlign: TextAlign.end),
                                                                                  SizedBox(height: 4,),
                                                                                  Text('Invoice No:', style: TextStyle(color: textColor), textAlign: TextAlign.end,),
                                                                                  SizedBox(height: 4,),
                                                                                  Text('Invoice Date:', style: TextStyle(color: textColor), textAlign: TextAlign.end),
                                                                                  SizedBox(height: 4,),
                                                                                  Text('Shipping Ref:', style: TextStyle(color: textColor), textAlign: TextAlign.end),
                                                                                  SizedBox(height: 4,),
                                                                                  Text('Shipping Date:', style: TextStyle(color: textColor), textAlign: TextAlign.end),
                                                                                  SizedBox(height: 4,),
                                                                                  Text('Shipping By:', style: TextStyle(color: textColor), textAlign: TextAlign.end),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 5,),
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child:                     Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                children: [
                                                                                  Text('${formatdatewithTime.format(orderH[i].orderDate)}', style: TextStyle(color: textColor)),
                                                                                  SizedBox(height: 4,),
                                                                                  Text(orderH[i].invoiceNo != "" && orderH[i].invoiceNo != null ? '${orderH[i].invoiceNo}' : '', style: TextStyle(color: textColor)),
                                                                                  SizedBox(height: 4,),
                                                                                  Text(orderH[i].invoiceDate != "" && orderH[i].invoiceDate != null ? '${formatdate.format(orderH[i].invoiceDate)}' : '', style: TextStyle(color: textColor)),
                                                                                  SizedBox(height: 4,),
                                                                                  Text(orderH[i].shipRefNo != "" && orderH[i].shipRefNo != null ? '${orderH[i].shipRefNo}' : '', style: TextStyle(color: textColor)),
                                                                                  SizedBox(height: 4,),
                                                                                  Text(orderH[i].shipDate != "" && orderH[i].shipDate != null ? '${formatdate.format(orderH[i].shipDate)}' : '', style: TextStyle(color: textColor)),
                                                                                  SizedBox(height: 4,),
                                                                                  Text(orderH[i].shipBy != "" && orderH[i].shipBy != null ? '${orderH[i].shipBy}' : '', style: TextStyle(color: textColor)),
                                                                                ],
                                                                              ),

                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                      ]
                                                            )
                                                        ),
                                                        snapshot.data.length>0 && orderH[i].isVisiblemore ? Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            InkWell(
                                                              onTap: (){
                                                                updateVisablity(orderH[i].orderNo, true);
                                                                orderH[i].isVisiblemore = false;
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets.only(right: 15),
                                                                child: Text('Show Items >>', style: TextStyle(decoration: TextDecoration.underline),),
                                                              ),
//                                                          child: Text('View ${snapshot.data.length-0} more product'),
                                                            ),
                                                          ],
                                                        )
                                                            : Container(),
                                                        for(var j = 0; j < snapshot.data.length; j++)
                                                          Visibility(
                                                            visible: j>=0 ? snapshot.data[j].isVisible : true,
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                SizedBox(height: 15,),
                                                                Row(
                                                                  children: [
                                                                    Image.network(snapshot.data[j].imagefileName, height: 60,
                                                                      width: 60,
                                                                      fit: BoxFit.fitHeight,),
                                                                    SizedBox(width: 10,),
                                                                    Column(
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        Align(
                                                                          alignment: Alignment.topLeft,
                                                                          child: Text(snapshot.data[j].onlineName != "" ? snapshot.data[j].onlineName
                                                                              : snapshot.data[j].description, style: TextStyle(color: textColor),),
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment.centerRight,
                                                                          child: Container(
                                                                            constraints: BoxConstraints(minWidth: 250, maxWidth: 400),
                                                                            child: Text('$currencysymbol${formatterint.format(
                                                                                snapshot.data[j].totalPrice)}',
                                                                              textAlign: TextAlign.end, style: TextStyle(color: textColor),),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 15,),
                                                              ],
                                                            ),
                                                          ),
                                                        !orderH[i].isVisiblemore ? Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            InkWell(
                                                              onTap: (){
                                                                updateVisablity(orderH[i].orderNo, false);
                                                                orderH[i].isVisiblemore = true;
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets.only(right: 15),
                                                                child: Text('<< Hide Items', style: TextStyle(decoration: TextDecoration.underline),),
                                                              ),
//                                                          child: Text('View ${snapshot.data.length-0} more product'),
                                                            ),
                                                          ],
                                                        )
                                                            : Container(),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                          color: Color(0xFFECF9E7),
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                                            child: Row(
                                                              children: [
                                                                Text('${snapshot.data.length} items'),
                                                                Spacer(),
                                                                Text('Order Total: $currencysymbol${formatterint.format(orderH[i].netAmount)}'),
                                                              ],
                                                            ),),
                                                        ),
                                                        Visibility(
                                                          visible: !orderH[i].isVisiblemore,
                                                          child: SizedBox(height: 5,),
                                                        ),
                                                        Visibility(
                                                          visible: !orderH[i].isVisiblemore,
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    width: 1,
                                                                    color: listLabelbgColor,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(10)
                                                              ),
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text('Delivery Address',),
                                                                        Text('${orderH[i].dcustomerTitle} ${orderH[i].dcustomerName}', style: TextStyle(color: textColor),),
                                                                        Text('${orderH[i].dAddress1}', softWrap: true, style: TextStyle(color: textColor),),
                                                                        Text('${orderH[i].dAddress2}', softWrap: true, style: TextStyle(color: textColor),),
                                                                      ],
                                                                    )
                                                                  ]
                                                              )
                                                          ),
                                                        ),
                                                        //SizedBox(height: 5,),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                else if (snapshot.hasError) {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ) : Container(),
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
      ),
    );
  }
}