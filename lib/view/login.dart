import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/registration.dart';
import '../style.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:core';

class LoginPage extends StatefulWidget{
  @override
  _LoginPage createState() => _LoginPage();
}
class _LoginPage extends State<LoginPage>{
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
        userName = dt.firstName.toString().toUpperCase();
        isLogin=true ;
        Navigator.pop(context, dt.eMail);
        res = 'OK';
      }
      else {
//        Dialogs.AlertMessage(context,
//            dt.returnStatus);
        showInfoFlushbar(context,dt.returnStatus);

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
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: Body1Style,
          ),
        ),

        home: Scaffold(
          appBar: AppBar(
            title: Text('Login',style: GoogleFonts.lato(color: Colors.white,fontWeight:FontWeight.bold )),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() => Navigator.pop(context, false),
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
                              margin: EdgeInsets.only(left: 20.0, top: 15.0,right: 20.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      //color: Colors.grey,
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
                                              Icons.supervised_user_circle,
                                              color:buttonColor,
                                              size: 70.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Spacer(),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child: TextField(
                                                controller: txtuserid,
                                                autocorrect: true,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText: 'Email',
                                                  labelText: "Email",
                                                  prefixIcon: Icon(Icons.mail_outline),
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  filled: true,
                                                  fillColor:  Colors.white70,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                                    borderSide: BorderSide(color: listLabelbgColor, width: 1),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                                  ),
                                                ),)
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 13,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child: TextField(
                                                controller: txtpassword,
                                                autocorrect: true,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText: 'Password',
                                                  labelText: "Password",
                                                  prefixIcon: Icon(Icons.lock),
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  filled: true,
                                                  fillColor:  Colors.white70,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    borderSide: BorderSide(color: listLabelbgColor, width: 1),
                                                  ),
                                                ),  obscureText: true,
                                                onChanged: (text) {
                                                  txtPassword="";
                                                  if (text.length>0)
                                                  {
                                                    PasswordEnter="Y";
                                                    txtPassword=text.trim();
                                                  }
                                                  else
                                                    PasswordEnter="N";
                                                  setState(() {
                                                  });
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                                  Text('Log on',style: GoogleFonts.lato(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold )),
                                                ],
                                              ),
                                              onPressed: () {
                                                checkLogin();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Divider(
                                                    color: Colors.black
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Text('or Sign in with',style: GoogleFonts.lato(color: Colors.black, fontSize: 12 )),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Divider(
                                                    color: Colors.black
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: FacebookSignInButton(onPressed: () {},
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: "Roboto",color: Colors.white),
                                              text: 'Facebook',
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Expanded(
                                            child: GoogleSignInButton(onPressed: () {}, darkMode: true,
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: "Roboto",color: Colors.white),
                                              text: 'Google',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text("Don't have an account?",
                                                  style: GoogleFonts.lato(fontSize: 14,color: Colors.blueGrey,fontWeight:FontWeight.bold),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                        child: Text("  Register",
                                                          style: GoogleFonts.lato(fontSize: 15,color: Colors.green,fontWeight:FontWeight.bold,),),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Registration()),);
                                                          // do what you need to do when "Click here" gets clicked
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[

                                                Column(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                        child: Text("Forgot Password?",
                                                          style: GoogleFonts.lato(fontSize: 14,color: Colors.blue,fontWeight:FontWeight.bold,),),
                                                        onTap: () {
//                                                          Navigator.push(
//                                                            context,
//                                                            MaterialPageRoute(
//                                                                builder: (context) => Registration()),);
                                                          // do what you need to do when "Click here" gets clicked
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

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
  void showInfoFlushbar(BuildContext context, String msg) {
    Flushbar(
      title: 'Failed to login',
      message: '$msg',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}