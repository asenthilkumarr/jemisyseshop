import 'dart:async';
//import 'dart:html';
import 'dart:ui';

//import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/order.dart';
import 'package:jemisyseshop/view/voucherList.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentPage extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  final Address sAddress;
  final Address dAddress;
  final List<Cart> itemList;
  final String source;
  final OrderOutstanding outstandingitem;
  final String dstoreCode;
  final GlobalKey<FormState> masterScreenFormKey;
  PaymentPage({this.itemCount, this.totalAmount, this.sAddress, this.dAddress, this.itemList, this.source, this.outstandingitem, this.dstoreCode,
  this.masterScreenFormKey});
  @override
  _paymentPage createState() => _paymentPage();
}
class _paymentPage extends State<PaymentPage> {
  DataService dataService = DataService();
  final GlobalKey _keyLoader = new GlobalKey();
  final GlobalKey _keyLoader2 = new GlobalKey();

  double sumValue = 0.0;
  double voucherRedeemamount = 0,totalAmount = 0;
  int itemCount = 0;
  double totaldollortoRedeem = 0;
  double redeemValue = 0;
  int id = 1, vouchercnt = 0;
  String radioItem = 'Master / VISA Card', paymode_Points="", paymode_Voucher="";
  OrderData param=new OrderData();

  List<Voucher> redeemVouchers = [];
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
  FocusNode _focusNode;
  TextEditingController txtPointsvalue = TextEditingController();

  void _handleRadioValueChange(RadioButtonListValue value) {
    setState(() {
    });
  }
  void loadDefault() async{
    sumValue = widget.totalAmount;
    itemCount = widget.itemCount;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        txtPointsvalue.clear();
        sumValue = widget.totalAmount - voucherRedeemamount;
        setState(() {

        });
      }

    });

    await getCustomer();
    var voucherlist = await _fetchVoucherList();
    vouchercnt = voucherlist.length;

    var dt = await dataService.getSetting();
    if (dt.length > 0) {
      paymode_Points = dt[0].paymode_Points;
      paymode_Voucher = dt[0].paymode_Voucher;
    }

    setState(() {

    });
  }
  void getCustomer() async{
    var dt = await dataService.getPoints(userID);
    if(dt.dollortoRedeem != null){
      totaldollortoRedeem = double.parse(formatterint.format(dt.dollortoRedeem).toString());
//      totaldollortoRedeem=305;
    }
    setState(() {

    });
  }
  void checkPointsValue(double iValue){
    if(totaldollortoRedeem < iValue){
      txtPointsvalue.text = "0";
      redeemValue = 0;
    }
    else{
      sumValue = widget.totalAmount-iValue - voucherRedeemamount;
      redeemValue = iValue;
    }
  }
  void applyVoucher(List<Voucher> getV){
    voucherRedeemamount = 0;
    if(getV != null && getV.length>0){
      redeemVouchers = getV;
      for(int i=0;i<getV.length;i++){
        voucherRedeemamount += getV[i].voucherValue;
      }
    }
    sumValue = widget.totalAmount - redeemValue - voucherRedeemamount;
    setState(() {

    });
  }
  Future<List<Voucher>> _fetchVoucherList() async {
    var dt = await dataService.getVouchers(userID);
    return dt;
  }
  void UpdatePayment(String payMode) async{
    String voucherNo = "";
    double voucherAmount = 0;
    Dialogs.showLoadingDialog(context, _keyLoader2);
    if (widget.itemList != null) {
      for (var i = 0; i < widget.itemList.length; i++) {
        totalAmount += widget.itemList[i].totalPrice;
      }
    }
    if(redeemVouchers.length>0){
      for(int i=0;i<redeemVouchers.length;i++){
        if(voucherNo!= "") voucherNo += ";";
        voucherAmount += redeemVouchers[i].voucherValue;
        voucherNo += redeemVouchers[i].refNo;
      }
    }
    var dt = await dataService.getSetting();
    if (dt.length > 0) {
      paymode_Points = dt[0].paymode_Points;
      paymode_Voucher = dt[0].paymode_Voucher;
    }
    Navigator.of(
        _keyLoader2.currentContext, rootNavigator: true)
        .pop(); //close the dialoge
    if(widget.source==null){
      Paymentfn objcf = new Paymentfn();
      param.eMail = userID;
      param.totalAmount = totalAmount;
      param.discount = 0;
      param.netAmount = totalAmount;
      param.deliveryMode = "S";
      param.shippingAddress = widget.sAddress;
      param.billingAddress = widget.dAddress;
      param.dstoreCode = widget.dstoreCode;
      param.payMode1 = null;
      param.payMode1_Amt = 0;
      param.payMode1_Ref = null;
      param.payMode2 = redeemValue != 0 ? paymode_Points : null;
      param.payMode2_Amt = redeemValue;
      param.payMode2_Ref = null;
      param.payMode3 = voucherAmount> 0 ? paymode_Voucher : null;
      param.payMode3_Amt = voucherAmount;
      param.payMode3_Ref = voucherNo;
      param.mode = "I";
      objcf.updateOrder(param, widget.itemList, null, context, _keyLoader);
    }
  }
  @override
  void initState() {
    super.initState();

    loadDefault();
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
                                          widget.totalAmount)}", style: TextStyle(
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, bottom: 3.0, right: 8.0),
                                    child: Container(
                                      color: buttonTextColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: vouchercnt == 0 ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text("$appTitle Vouchers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                            SizedBox(height: 5,),
                                            Container(
//                                            color: Color(0xFFFAFAFA),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("You currently don't have any xCLusive Vouchers", style: TextStyle(color: lightTextColor),),
                                              ),
                                            ),
                                          ],
                                        )
                                        : InkWell(
                                          onTap: () async{
                                            List<Voucher> getV = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => VoucherList()));
                                            applyVoucher(getV);
                                          },
                                          child: Row(
                                            children: [
                                              Flexible(
                                              flex: 5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text("$appTitle Vouchers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                                    SizedBox(height: 5,),
                                                    Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text("You currently have xCLusive Vouchers", style: TextStyle(color: lightTextColor),),
                                                      ),
                                                    ),
                                                    voucherRedeemamount > 0 ? SizedBox(height: 5,)  : Container(),
                                                    voucherRedeemamount > 0 ? Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("Voucher Amount: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                                        Text('$currencysymbol${formatterint.format(voucherRedeemamount)}'),
                                                      ],
                                                    ) : Container(),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Icon(Icons.keyboard_arrow_right, size: 45, color: Color(0xFF7DB553),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Visibility(
                                    visible: !kIsWeb ? false : true,
                                    child:Padding(
                                      padding: const EdgeInsets.only(left: 8.0, bottom: 3.0, right: 8.0),
                                      child: Container(
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
                                                        radioItem = data.name;
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
                                    ),
                                  ),

                                  //SizedBox(height: 8,),
                                  widget.source != "IP" ? Padding(
                                    padding: const EdgeInsets.only(left: 8.0, bottom: 3.0, right: 8.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text("Loyalty Points", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Text("Available points \$ value"),
                                                Spacer(),
                                                Text(formatterint.format(totaldollortoRedeem).toString())
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Text("Redeem points \$ value"),
                                                Spacer(),
                                                SizedBox(
                                                  width: 100,
                                                  height: 40,
                                                  child: TextField(
                                                    focusNode: _focusNode,
                                                    controller: txtPointsvalue,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
//                                                      labelText: 'Password',
                                                    contentPadding: EdgeInsets.only(bottom: 3),
                                                    ),
                                                    textAlign: TextAlign.end,
                                                    onChanged: (text){
                                                      if(text == null || text == "") text = "0";
                                                      checkPointsValue(double.parse(text));
                                                      setState(() {

                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(),
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
                              if(paymentGateway != "") {
                                if (!kIsWeb) {
                                  if (radioItem == 'Master / VISA Card') {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentDetailPage(
                                              redeemVoucher: redeemVouchers,
                                              itemCount: itemCount,
                                              totalAmount: sumValue,
                                              redeemAmount: redeemValue,
                                              payMode: "VISA / MASTER",
                                              sAddress: widget.sAddress,
                                              dAddress: widget.dAddress,
                                              itemList: widget.itemList,
                                              source: widget.source,
                                              outstandingitem: widget
                                                  .outstandingitem,
                                              dstoreCode: widget.dstoreCode,)));
                                  }
                                  else {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentDetailPage(
                                              redeemVoucher: redeemVouchers,
                                              itemCount: itemCount,
                                              totalAmount: sumValue,
                                              redeemAmount: redeemValue,
                                              payMode: "NETS",
                                              sAddress: widget.sAddress,
                                              dAddress: widget.dAddress,
                                              itemList: widget.itemList,
                                              source: widget.source,
                                              outstandingitem: widget
                                                  .outstandingitem,
                                              dstoreCode: widget.dstoreCode,)));
                                  }
                                }
                                else {
                                  if (radioItem == 'Master / VISA Card') {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentDetailPage2(
                                              redeemVoucher: redeemVouchers,
                                              itemCount: itemCount,
                                              totalAmount: sumValue,
                                              redeemAmount: redeemValue,
                                              payMode: "VISA / MASTER",
                                              sAddress: widget.sAddress,
                                              dAddress: widget.dAddress,
                                              itemList: widget.itemList,
                                              source: widget.source,
                                              outstandingitem: widget
                                                  .outstandingitem,
                                              dstoreCode: widget.dstoreCode,)));
                                  }
                                  else {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentDetailPage2(
                                              redeemVoucher: redeemVouchers,
                                              itemCount: itemCount,
                                              totalAmount: sumValue,
                                              redeemAmount: redeemValue,
                                              payMode: "NETS",
                                              sAddress: widget.sAddress,
                                              dAddress: widget.dAddress,
                                              itemList: widget.itemList,
                                              source: widget.source,
                                              outstandingitem: widget
                                                  .outstandingitem,
                                              dstoreCode: widget.dstoreCode,)));
                                  }
                                }
                              }
                              else{
                                UpdatePayment("");
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
  final double redeemAmount;
  final String payMode;
  final Address sAddress;
  final Address dAddress;
  final List<Cart> itemList;
  final String source;
  final List<Voucher> redeemVoucher;
  final OrderOutstanding outstandingitem;
  final String dstoreCode;
  PaymentDetailPage({this.itemCount, this.totalAmount, this.redeemAmount, this.payMode, this.sAddress, this.dAddress, this.itemList, this.source, this.outstandingitem, this.dstoreCode,
  this.redeemVoucher});
  @override
  _paymentDetailPage createState() => _paymentDetailPage();
}
class _paymentDetailPage extends State<PaymentDetailPage> {
  DataService dataService = DataService();

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey _keyLoader2 = new GlobalKey();
  final GlobalKey<State> keyview = new GlobalKey<State>();
  double totalAmount = 0;
  OrderData param=new OrderData();
  PaymentLog pLog = new PaymentLog();
  String srcUrl = "", pNo = "", paymode_CC = "", paymode_Nets = "", paymode_Points="", paymode_Voucher="";

  bool isOrderCreated = false, _isLoadingPage;

  Future<void> loadDefault() async {
    // Dialogs.showLoadingDialog(context, _keyLoader2);
    if (widget.itemList != null) {
      for (var i = 0; i < widget.itemList.length; i++) {
        totalAmount += widget.itemList[i].totalPrice;
      }
    }
    var dt = await dataService.getSetting();
    if (dt.length > 0) {
      paymode_CC = dt[0].paymode_CC;
      paymode_Nets = dt[0].paymode_Nets;
      paymode_Points = dt[0].paymode_Points;
      paymode_Voucher = dt[0].paymode_Voucher;
    }
    pNo = await dataService.getPaymentNextNo();
    // Navigator.of(
    //     _keyLoader2.currentContext, rootNavigator: true)
    //     .pop(); //close the dialoge
    srcUrl = paymenturl + "?paymentMode=VM&orderID="+pNo+"&payType=S&amount="+widget.totalAmount.toString()+"&currency="+currencyCode;
    setState(() {

    });
  }
  void UpdatePayment(String payMode) async{
    isOrderCreated = true;
    String voucherNo = "";
    double voucherAmount = 0;
    if(widget.redeemVoucher.length>0){
      for(int i=0;i<widget.redeemVoucher.length;i++){
        if(voucherNo!= "") voucherNo += ";";
        voucherAmount += widget.redeemVoucher[i].voucherValue;
        voucherNo += widget.redeemVoucher[i].refNo;
      }
    }
    if(widget.source==null){
      Paymentfn objcf = new Paymentfn();
      param.eMail = userID;
      param.totalAmount = totalAmount;
      param.discount = 0;
      param.netAmount = totalAmount;
      param.deliveryMode = "S";
      param.shippingAddress = widget.sAddress;
      param.billingAddress = widget.dAddress;
      param.dstoreCode = widget.dstoreCode;
      param.payMode1 = paymode_CC;
      param.payMode1_Amt = widget.totalAmount;
      param.payMode1_Ref = pNo;
      param.payMode2 = widget.redeemAmount != 0 ? paymode_Points : null;
      param.payMode2_Amt = widget.redeemAmount;
      param.payMode2_Ref = null;
      param.payMode3 = voucherAmount> 0 ? paymode_Voucher : null;
      param.payMode3_Amt = voucherAmount;
      param.payMode3_Ref = voucherNo;
      param.mode = "I";
      objcf.updateOrder(param, widget.itemList, null, context, _keyLoader);
    }
    else if(widget.source == "IP"){
      Paymentfn objpf = new Paymentfn();
      OrderUpdateParam param = new OrderUpdateParam();
      param.storeCode = widget.outstandingitem.storeCode;
      param.refNo = widget.outstandingitem.refNo;
      param.docType = widget.outstandingitem.docType;
      param.amount = widget.totalAmount;
      param.payMode = paymode_CC;
      param.reff = pNo;
      var result = await dataService.updateOrderOutstanding(param);
      if(result.status == 1){
        await objpf.sendmail(widget.outstandingitem.storeCode, widget.outstandingitem.refNo, widget.outstandingitem.docType, context);

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            OrderPage(source: "IP",)), (Route<dynamic> route) => false);
      }
    }
  }

  @override
  void initState(){
    super.initState();
    loadDefault();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
          title: 'Payment',
          theme: MasterScreen.themeData(context),
          home: Scaffold(
            appBar: AppBar(
              title: Text("Payment", style: TextStyle(color: title1Color),),
              backgroundColor: primary1Color,
              centerTitle: true,
            ),
/*
               body: EasyWebView(
                 key: keyview,
              src: srcUrl,
              isHtml: false, // Use Html syntax
              isMarkdown: false, // Use markdown syntax
              // width: 100,
              // height: 100,
              onLoaded: () {
                //print(keyview.currentContext.widget);
                final EasyWebView box = keyview.currentWidget;
                print("==========AAAAAAAAA----------------BBBBBBBBB-------------------");
                print(box.src);
                print("-------------------------------------------------------------------------------------");
              },
            ),
*/
            body: srcUrl != "" && srcUrl != paymenturl ? WebView(
              initialUrl: srcUrl,

              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(paymentBackurl)) {
                  Navigator.pop(context);
                }
                else if (request.url.startsWith(paymentSuccessurl)) {
                  print(request.url);
                }
//                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
//                print('Page started loading: $url');
              },
              onPageFinished: (String url) async {
//                print('Page finished loading: $url');
                print("----------------------------------------------------------------------1A-------------"+url);
                print(paymentSuccessurl);
                if(!url.startsWith(paymenturl)){
                  setState(() {
                    _isLoadingPage = false;
                  });
                }
                else if(url.startsWith(paymentSuccessurl)){
                  print("----------------------------------------------------------------------1A-------------"+url);
                  String qryString = url.split('?')[1];
                  if(qryString!= null){
                    String tID = qryString.split('=')[1];
                    if(tID != null && tID != ""){
                      pLog = await dataService.getPaymentLog(tID);
                      if(pLog.response_code == "0" && isOrderCreated == false){
                        isOrderCreated = true;
                        print("----------------------------------------------------------------------1A-------------");
                        UpdatePayment("VISA MASTER");
                      }
                    }
                  }

//                  Navigator.pop(context);
                }
              },
              gestureNavigationEnabled: true,
            )
            : Container(),
//            Stack(
//              children: [

//                _isLoadingPage
//                    ? Container(
//                  alignment: FractionalOffset.center,
//                  child: CircularProgressIndicator(),
//                )
//                    : Container(
//                  color: Colors.transparent,
//                ),
//              ],
//
//            ),
          ),
        )
    );

  }
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

class PaymentDetailPage2 extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  final double redeemAmount;
  final String payMode;
  final Address sAddress;
  final Address dAddress;
  final List<Cart> itemList;
  final String source;
  final OrderOutstanding outstandingitem;
  final List<Voucher> redeemVoucher;
  final String dstoreCode;
  PaymentDetailPage2({this.itemCount, this.totalAmount, this.redeemAmount, this.payMode, this.sAddress, this.dAddress, this.itemList, this.source, this.outstandingitem, this.dstoreCode, this.redeemVoucher});

  @override
  _paymentDetailPage2 createState() => _paymentDetailPage2();
}
class _paymentDetailPage2 extends State<PaymentDetailPage2> {
  DataService dataService = DataService();
  OrderData param=new OrderData();
  final _keyLoader = new GlobalKey<FormState>();

  var sX = 0.0;
  var sY = 0.0;
  var textVar = "";
  bool isOrderCreated;
  String srcUrl = "", pNo = "", paymode_CC = "", paymode_Nets = "", paymode_Points="", paymode_Voucher="";
  double totalAmount = 0;
  TextEditingController txtCardNo = TextEditingController();
  TextEditingController txtExpiry = TextEditingController();
  TextEditingController txtCVV = TextEditingController();
  TextEditingController txtNameoncard = TextEditingController();

  void loadDefault() async {
    totalAmount = 0;
    if (widget.itemList != null) {
      for (var i = 0; i < widget.itemList.length; i++) {
        totalAmount += widget.itemList[i].totalPrice;
      }
    }
    var dt = await dataService.getSetting();
    if (dt.length > 0) {
      paymode_CC = dt[0].paymode_CC;
      paymode_Nets = dt[0].paymode_Nets;
      paymode_Points = dt[0].paymode_Points;
      paymode_Voucher = dt[0].paymode_Voucher;
    }
    pNo = await dataService.getPaymentNextNo();
    srcUrl =
        paymenturl + "?paymentMode=VM&orderID=" + pNo + "&payType=S&amount=" +
            widget.totalAmount.toString() + "&currency=" + currencyCode;
    setState(() {

    });
  }
  void UpdatePayment(String payMode) async{
    isOrderCreated = true;
    String voucherNo = "";
    double voucherAmount = 0;
    if(widget.redeemVoucher.length>0){
      for(int i=0;i<widget.redeemVoucher.length;i++){
        if(voucherNo!= "") voucherNo += ";";
        voucherAmount += widget.redeemVoucher[i].voucherValue;
        voucherNo += widget.redeemVoucher[i].refNo;
      }
    }
    if(widget.source==null){
      Paymentfn objcf = new Paymentfn();
      param.eMail = userID;
      param.totalAmount = totalAmount;
      param.discount = 0;
      param.netAmount = totalAmount;
      param.deliveryMode = "S";
      param.shippingAddress = widget.sAddress;
      param.billingAddress = widget.dAddress;
      param.dstoreCode = widget.dstoreCode;
      param.payMode1 = paymode_CC;
      param.payMode1_Amt = widget.totalAmount;
      param.payMode1_Ref = pNo;
      param.payMode2 = widget.redeemAmount != 0 ? paymode_Points : null;
      param.payMode2_Amt = widget.redeemAmount;
      param.payMode2_Ref = null;
      param.payMode3 = voucherAmount> 0 ? paymode_Voucher : null;
      param.payMode3_Amt = voucherAmount;
      param.payMode3_Ref = voucherNo;
      param.mode = "I";
      objcf.updateOrder(param, widget.itemList, null, context, _keyLoader);
    }
    else if(widget.source == "IP"){
      Paymentfn objpf = new Paymentfn();
      OrderUpdateParam param = new OrderUpdateParam();
      param.storeCode = widget.outstandingitem.storeCode;
      param.refNo = widget.outstandingitem.refNo;
      param.docType = widget.outstandingitem.docType;
      param.amount = widget.totalAmount;
      param.payMode = paymode_CC;
      param.reff = pNo;
      Dialogs.showLoadingDialog(context, _keyLoader);
      var result = await dataService.updateOrderOutstanding(param);
      if(result.status == 1){
        await objpf.sendmail(widget.outstandingitem.storeCode, widget.outstandingitem.refNo, widget.outstandingitem.docType, context);
        Navigator.of(
            _keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            OrderPage(source: "IP",)), (Route<dynamic> route) => false);
      }
      Navigator.of(
          _keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
    }
  }

  void UpdatePayment2() async{
    if(widget.source==null){
      Paymentfn objcf = new Paymentfn();
      param.eMail = userID;
      param.totalAmount = totalAmount;
      param.discount = 0;
      param.netAmount = totalAmount;
      param.deliveryMode = "S";
      param.shippingAddress = widget.sAddress;
      param.billingAddress = widget.dAddress;
      param.dstoreCode = widget.dstoreCode;
      param.payMode1 = widget.payMode;
      param.payMode1_Amt = widget.totalAmount;
      param.payMode1_Ref = "435435676756765";
      param.payMode2 = widget.redeemAmount != 0 ? 'REDEEM POINTS' : null;
      param.payMode2_Amt = widget.redeemAmount;
      param.payMode2_Ref = null;
      param.payMode3 = null;
      param.payMode3_Amt = 0;
      param.payMode3_Ref = null;
      param.mode = "I";
      objcf.updateOrder(param, widget.itemList, null, context, _keyLoader);
    }
    else if(widget.source == "IP"){
      Paymentfn objpf = new Paymentfn();
      OrderUpdateParam param = new OrderUpdateParam();
      param.storeCode = widget.outstandingitem.storeCode;
      param.refNo = widget.outstandingitem.refNo;
      param.docType = widget.outstandingitem.docType;
      param.amount = widget.totalAmount;
      param.payMode = widget.payMode;
      param.reff = "435435676756765";
      var result = await dataService.updateOrderOutstanding(param);
      if(result.status == 1){
        await objpf.sendmail(widget.outstandingitem.storeCode, widget.outstandingitem.refNo, widget.outstandingitem.docType, context);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            OrderPage(source: "IP",)), (Route<dynamic> route) => false);
      }
    }
  }
  void initState(){
    super.initState();
    loadDefault();
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
                widget.payMode == "VISA / MASTER" ? Column(
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
                                      child: Image.asset("assets/cardTemplet.png", fit: BoxFit.fitHeight,),
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
                              Container(
                                constraints: BoxConstraints(minWidth: 250, maxWidth: 350),
                                child: Column(
                                  children: [
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
                              )
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
                              print("----------Print Click Payment-------------");
                              UpdatePayment("VISA MASTER");
                              print("----------Print End Payment-------------");
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

