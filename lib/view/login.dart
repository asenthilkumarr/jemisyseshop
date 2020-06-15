import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:core';

class LoginPage extends StatefulWidget{
  final GlobalKey<FormState> masterScreenFormKey;
  LoginPage({this.masterScreenFormKey});

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

  String Checknull() {

    if  (txtuserid.text == null || txtuserid.text == '') {
      return 'Please enter your Email.';
    }
    if  (txtpassword.text == null || txtpassword.text == '') {
      return 'Please enter your password.';
    }

    return '';
  }

  Future<String> checkLogin() async {
    String res = "Failed";
    //SharedPreferences prefs =  await SharedPreferences.getInstance();
    if(Checknull()!="")
    {
      showInfoFlushbar(context, Checknull());
      userID="";
      isLogin=false;
    }
    else
    if (txtuserid.text != null && txtuserid.text != '' &&
        txtpassword.text != null && txtpassword.text != '') {
      Dialogs.showLoadingDialog(context, _keyLoaderLogin); //invoking go

      Customer param = Customer();
      param.eMail = txtuserid.text.trim();
      param.password = txtpassword.text.trim();

      var dt = await dataService.GetCustomer(param);

      if (dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
        userName = dt.firstName.toString().toUpperCase();
        isLogin=true ;
        var cartdt = await dataService.GetCart(userID, "S");
        cartCount = cartdt.length;
        widget.masterScreenFormKey?.currentState?.reset();
        Commonfn.saveUser(txtuserid.text, txtpassword.text, true);
        Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true).pop(); //close the dialoge

        Navigator.pop(context, dt.eMail);
        res = 'OK';
      }
      else {
//        Dialogs.AlertMessage(context,
//            dt.returnStatus);
        showInfoFlushbar(context,dt.returnStatus);
        Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true).pop(); //close the dialoge

      }
    }
    return res;

  }
  void loadDefault() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(await prefs.getString('userID') != null){
      txtuserid.text = await Commonfn.getUserID();
    }
  }

  @override
  void initState() {

    super.initState();
    ShowRetypePassword();
    loadDefault();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Login",
        theme: MasterScreen.themeData(context),

        home: Scaffold(
          appBar: AppBar(
            title: Text('Login',style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold )),
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
                                                  Text('Log on',style: TextStyle(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold )),
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
                                                Text('or Sign in with',style: TextStyle(color: Colors.black, fontSize: 12 )),
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
                                                  style: TextStyle(fontSize: 14,color: Colors.blueGrey,fontWeight:FontWeight.bold),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                        child: Text("  Register",
                                                          style: TextStyle(fontSize: 15,color: Colors.green,fontWeight:FontWeight.bold,),),
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
                                                          style: TextStyle(fontSize: 14,color: Colors.blue,fontWeight:FontWeight.bold,),),
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
      margin: EdgeInsets.all(8),
      backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.teal]),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      borderRadius: 8,
      title: 'Failed to login!',
      message: '$msg',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
     // leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}