import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';

class MyTransactionPage extends StatefulWidget{
  @override
  _myTransactionPage createState() => _myTransactionPage();
}
class _myTransactionPage extends State<MyTransactionPage> {
  DataService dataService = DataService();
  List<OrderH> orderH = new List<OrderH>();
  List<OrderD> orderD = new List<OrderD>();
  void loadDefault() async{
    OrderGetParam param = new OrderGetParam();
    param.eMail = userID;
    param.orderType = "S";
    orderH = await dataService.getOrderH(param);
    orderD = await dataService.getOrderD(param);

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
                  Flexible(
                    child: SingleChildScrollView(
                      child: orderD.length>0 ? Column(
                        children: [
                          for(var i = 0;i<orderD.length;i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(

                                      children: [
                                        Image.network(orderD[i].imagefileName, height: 100, width: 100, fit: BoxFit.fitHeight,),
                                        SizedBox(width: 10,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(formatter2dec.format(orderD[i].totalPrice), style: TextStyle(fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            Text(orderD[i].onlineName!="" ? orderD[i].onlineName : orderD[i].description,),

                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5,)
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ) : Container(),
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
}