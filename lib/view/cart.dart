import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class CartPage extends StatefulWidget{
  @override
  _cartPage createState() => _cartPage();
}
class _cartPage extends State<CartPage> {
  List<Cart> cartlist = new List<Cart>();
  Widget CartList(Cart dt){
    return Card(
      child: Stack(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text("$currencysymbol${formatterint.format(dt.totalPrice)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold)),
                  Text(dt.onlineName),
                  Text("SKU : ${dt.designCode}" + dt.itemCode != "" ? " - ${dt.itemCode}" : ""),
                  Row(
                    children: [
                      Text("Qty: "),
//                      DropdownButton(),
                      Text("Size: "),
//                      DropdownButton(),
                    ],
                  ),
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
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home,color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
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
                            primary1Color,
                            Colors.white
                          ],
                        ),
                      ),
                    ),

                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //Customtitle(context, "Cart"),

                            ]
                        ),
                      ),
                    ),
                  ]
              )
          )
      ),
    );
  }
}
