import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';

class VoucherList extends StatefulWidget {
  @override
  _voucherList createState() => new _voucherList();
}
//State is information of the application that can change over time or when some actions are taken.
class _voucherList extends State<VoucherList>{
  DataService dataService = new DataService();
  List<Voucher> itemDt = [];
  List<Voucher> selectedVoucher = [];
  double totalVAmount = 0;
  ScrollController _scrollController = new ScrollController();

  void loadDefault() async{
    await _fetchVoucherList();
    setState(() {

    });
  }
  Future<List<Voucher>> _fetchVoucherList() async {
    itemDt = new List<Voucher>();
    var dt = await dataService.getVouchers(userID);
    itemDt = dt;
    return dt;
  }
  ListView VoucherlistView(List<Voucher> data) {
    return
      new ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
//            Container(),
            Doclist(data[index], index),
      );
  }
  Widget Doclist(Voucher Dt, int index){
    var formatter = new DateFormat('dd-MM-yyyy');
    return  new Card(
      elevation:8,
      // margin: EdgeInsets.all(7.0),
      margin: EdgeInsets. fromLTRB(8.0,3.0,7.0,4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      'Voucher No:   ${Dt.refNo} ',
                      style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold)
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${Dt.remarks} ',
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFF979B97)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Total Amount: $currencysymbol${formatterint.format(
                      Dt.voucherValue)}",
                      style: TextStyle(
                        fontSize: 14,)),

                ]),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                child:CircleAvatar(
                  child: Center(
                    child: ClipOval(
                      child: IconButton(icon: Icon(Icons.check,size: 25,
                        color: Colors.white ,),
                          onPressed: () async{
                        itemDt[index].isSelected = !itemDt[index].isSelected;
                        await CalculateAmount();
                        setState(() {

                        });
                          }),
                    ),
                  ),
                  radius: 20,
                  backgroundColor: Dt.isSelected == false ? Color(0xFFFB7269) : Color(0xFF619051),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
  void CalculateAmount() {
    totalVAmount = 0;
    selectedVoucher = new List<Voucher>();
    for (int i = 0; i < itemDt.length; i++) {
      if (itemDt[i].isSelected){
        selectedVoucher.add(itemDt[i]);
        totalVAmount += itemDt[i].voucherValue;
      }
    }
  }
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadDefault();
  }
  @override
  Widget build(BuildContext context) {
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
        ),
        body: itemDt == null || itemDt.length == 0 ? Container(
          color: Colors.white,
        ) :
      Container(
        constraints: BoxConstraints(minWidth: 250, maxHeight: 500),
        padding: const EdgeInsets.fromLTRB(10,8,10,5),
        child:  VoucherlistView(itemDt)
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
                                "Apply       ($currencysymbol${formatterint.format(
                                    totalVAmount)})",
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontSize: 15, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context, selectedVoucher);
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