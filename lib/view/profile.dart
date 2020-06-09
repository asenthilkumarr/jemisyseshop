import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/cart.dart';
import 'package:jemisyseshop/view/registration.dart';
import '../style.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:core';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePage createState() => _ProfilePage();
}
class _ProfilePage extends State<ProfilePage>{
  String PasswordEnter = "N";
  String txtPassword = "";
  bool _isRow = true;
  TextEditingController txtuserid = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  final GlobalKey<State> _keyLoaderLogin = new GlobalKey<State>();
  DataService dataService = DataService();

  String ShowRetypePassword() {
    if (PasswordEnter == "Y") {
      return 'Y';
    }
    else
      return 'N';
  }

  Future<String> checkLogin() async {
    String res = "Failed";
    //SharedPreferences prefs =  await SharedPreferences.getInstance();

    if (txtuserid.text != null && txtuserid.text != '' &&
        txtpassword.text != null && txtpassword.text != '') {
      Dialogs.showLoadingDialog(context, _keyLoaderLogin); //invoking go

      Customer param = Customer();
      param.eMail = txtuserid.text.trim();
      param.password = txtpassword.text.trim();

      var dt = await dataService.GetCustomer(param);
      Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      if (dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
        Navigator.pop(context, dt.eMail);
        res = 'OK';
      }
      else {
        Dialogs.AlertMessage(context,
            dt.returnStatus);

      }
    }
    return res;
  }


  @override
  void initState() {

    super.initState();
    ShowRetypePassword();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: brightness1,
          primaryColor: Color(0xFFFF8752),
          accentColor: accent1Color,
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
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
            title: Text('My Account',style: GoogleFonts.lato(color: Colors.white,fontWeight:FontWeight.bold )),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() {
                Navigator.pop(context,false);
              },
            ),
            actions: <Widget>[

            ],
            backgroundColor: Color(0xFFFF8752),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //Spacer(),
//                      Spacer(),
                    Container(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0)
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 50.0,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ]),
                            //height: 200,
                            child: Container(
                              margin: EdgeInsets.only(left: 15.0, top: 15.0,right: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 6.0,
                                      offset: Offset(1.0, 3.0),
                                    ),
                                  ]),
                              child:  Container(
                                color: Colors.white,
                                //padding: const EdgeInsets.fromLTRB(15.0,10,15,10),//I used some padding without fixed width and height
                                // Image(image: AssetImage("assets/logo3.png"),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0,0.0,3.0,0.0),
                                            child: Icon(
                                              Icons.person_pin,
                                              color:buttonColor,
                                              size: 100.0,
                                            ),

                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0,0.0,3.0,0.0),
                                            child: Text('  $userID' ,
                                                style: GoogleFonts.lato(color: Colors.green, fontWeight: FontWeight.bold,fontSize: 14)
                                              //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                            ),

                                          ),
                                        ],
                                      ),
                                     // Spacer(),
                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child:ListTile(
                                                  dense: true,
                                                  title: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        Text('Hi,  $userName' ,
                                                            style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14)
                                                          //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),
                                                       ]),
                                                  onTap: () { /* react to the tile being tapped */ }
                                              )
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child:ListTile(
                                                  leading: const Icon(Icons.shopping_cart),
                                                  trailing: const Icon(Icons.arrow_forward),
                                                dense: true,
                                                  title: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('My Orders' ,
                                                            style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14)
                                                          //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),
                                                      ]),
                                                  onTap: () {
                                                    //Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => CartPage()),);
                                                  }
                                              )
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child:ListTile(
                                                  leading: const Icon(Icons.home),
                                                  trailing: const Icon(Icons.arrow_forward),
                                                  dense: true,
                                                  title: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('My Home Try-on' ,
                                                            style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14)
                                                          //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),
                                                      ]),
                                                  onTap: () { /* react to the tile being tapped */ }
                                              )
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child:ListTile(
                                                  leading: const Icon(Icons.favorite_border),
                                                  dense: true,
                                                  trailing: const Icon(Icons.arrow_forward),
                                                  title: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('My Wishlist' ,
                                                            style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14)
                                                          //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),
                                                      ]),
                                                  onTap: () { /* react to the tile being tapped */ }
                                              )
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(height: 60,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(30.0),
                                                side: BorderSide(color:Color(0xFF88A9BB)),
                                              ),
                                              color: buttonColor,
                                              textColor: Colors.white,
                                              padding: EdgeInsets.all(13.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text('Logout',style: GoogleFonts.lato(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold )),
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context,false);
                                                userID="";
                                                userName ="";
                                                isLogin=false;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                       ],
                                  ),
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}