import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/view/cart.dart';
import 'package:jemisyseshop/view/login.dart';

import '../style.dart';
import 'goldRate.dart';

Widget titleBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, GlobalKey _keyGoldRate, GlobalKey<State> _formKeyReset, Color _bgColor, Color _fontColor) {
  GoldRateWedgit objGoldRate = new GoldRateWedgit();
  return Container(
    color: _bgColor,
    child: Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.white,),
                iconSize: 25,

                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: CompanyLogo(_bgColor, _fontColor),
            ),
            Spacer(),
            Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 40,
                          child: IconButton(
                            key: _keyGoldRate,
                            icon: new Image.asset('assets/goldRate.png', height: 25,),
                            iconSize: 30,

                            onPressed: () {
                              objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate);
                            },
                          )),
                      Center(
                        child: SizedBox(
                          width: 40,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Stack(
                                  children: <Widget>[
                                    //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                                    IconButton(
                                      icon: new Image.asset(
                                        'assets/shopping_cart.png',
                                        height: 25,),
//                                     icon: Icon(Icons.cur, color: Colors.white,),
                                      iconSize: 25,
                                      onPressed: () {
                                        if(isLogin == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CartPage(pSource: "S",)),);
                                        }
                                        else{
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(masterScreenFormKey: _formKeyReset,)),);
                                        }
                                      },),
                                    new Positioned( // draw a red marble
                                      top: 5.0,
                                      right: 10.0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle
                                        ),
                                        key: _formKeyReset,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: new Text(
                                            cartCount.toString(),
                                            style: new TextStyle(
                                              color: Colors.red,
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                              )),
                        ),
                      ),
                    ],
                  ),
                )
            )


          ],
        ),

      ],
    ),

  );
}
Widget titleBar2(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, GlobalKey _keyGoldRate, GlobalKey<State> _formKeyReset, Color _fontColor) {
  GoldRateWedgit objGoldRate = new GoldRateWedgit();
  return Container(
    //color: primary1Color2,
    child: Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.menu, color: _fontColor,),
                iconSize: 25,

                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: CompanyLogo(homeTitleColor, _fontColor),
            ),
            Spacer(),
            Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 40,
                          child: IconButton(
                            key: _keyGoldRate,
                            icon: new Image.asset('assets/goldRate.png', height: 25,),
                            iconSize: 30,

                            onPressed: () {
                              objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate);
                            },
                          )),
                      Center(
                        child: SizedBox(
                          width: 40,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Stack(
                                  children: <Widget>[
                                    //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                                    IconButton(
                                      icon: Icon(Icons.shopping_basket, color: _fontColor,),
                                      // icon: new Image.asset(
                                      //   'assets/shopping_cart.png',
                                      //   height: 25,),
//                                     icon: Icon(Icons.cur, color: Colors.white,),
                                      iconSize: 25,
                                      onPressed: () {
                                        if(isLogin == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CartPage(pSource: "S",)),);
                                        }
                                        else{
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(masterScreenFormKey: _formKeyReset,)),);
                                        }
                                      },),
                                    new Positioned( // draw a red marble
                                      top: 5.0,
                                      right: 10.0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle
                                        ),
                                        key: _formKeyReset,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: new Text(
                                            cartCount.toString(),
                                            style: new TextStyle(
                                              color: Colors.red,
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                              )),
                        ),
                      ),
                    ],
                  ),
                )
            )


          ],
        ),

      ],
    ),

  );
}

Widget titleBar9(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, GlobalKey _keyGoldRate) {
  GoldRateWedgit objGoldRate = new GoldRateWedgit();
  return Container(
    color: primary1Color,
    child: Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                iconSize: 25,

                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: CompanyLogo(primary1Color, Colors.white),
            ),
            Spacer(),
            Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 40,
                          child: IconButton(
                            key: _keyGoldRate,
                            icon: new Image.asset('assets/goldRate.png', height: 25,),
                            iconSize: 30,

                            onPressed: () {
                              objGoldRate.showGoldRate(context, hideTitleMessage, _keyGoldRate);
                            },
                          )),
                      Center(
                        child: SizedBox(
                          width: 40,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Stack(
                                  children: <Widget>[
                                    //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                                    IconButton(
                                      icon: new Image.asset(
                                        'assets/shopping_cart.png',
                                        height: 25,),
//                                     icon: Icon(Icons.cur, color: Colors.white,),
                                      iconSize: 25,
                                      onPressed: () {},),
                                    new Positioned( // draw a red marble
                                      top: 5.0,
                                      right: 10.0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: new Text(
                                            '5',
                                            style: new TextStyle(
                                              color: Colors.red,
                                              fontSize: 9,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                              )),
                        ),
                      ),
                    ],
                  ),
                )
            )


          ],
        ),

      ],
    ),

  );
}
Widget Customtitle(BuildContext context, String title) {
  return Container(
      color: primary1Color,
      child: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right:30.0),
                  child: Text(title, style: titleTextStyle,),
                ),
              ),
              Spacer()
            ],
          ),

        ],
      ),

    );
}
Widget Customtitle2(BuildContext context, String title, GlobalKey stickyKey) {
  return Container(
    key: stickyKey,
    color: primary1Color,
    child: Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                iconSize: 25,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right:30.0),
                child: Text(title, style: titleTextStyle,),
              ),
            ),
            Spacer()
          ],
        ),

      ],
    ),

  );
}

Widget CompanyLogo(Color _bgcolor, Color _fontColor) {
  return new Container(
    color: _bgcolor,
    child: Center(
      child: Text(appTitle,
        style: GoogleFonts.oswald(
          textStyle: TextStyle(color: _fontColor, fontSize: 31, letterSpacing: 1.5),
        ),
        //style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.normal,)
      ),
    ),
//      child: SizedBox(
//        height: 30,
//        child: new Image.network(
//          'http://42.61.99.57/JEMiSyseShopImage/Banner3.png',
//          //"http://42.61.99.57/JEMiSyseShopImage/logo.png",
//          fit: BoxFit.fitHeight,
//        ),
//      ),
  );
}
