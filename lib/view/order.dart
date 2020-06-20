import 'package:flutter/material.dart';
import 'package:jemisyseshop/view/masterPage.dart';

class OrderPage extends StatefulWidget{
  @override
  _orderPage createState() => _orderPage();
}
class _orderPage extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Order", style: TextStyle(color: Colors.white),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context, false);
              }
          ),
          backgroundColor: Color(0xFFFF8752),
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
            ],
          ),
        ),
      ),
    );
  }
}