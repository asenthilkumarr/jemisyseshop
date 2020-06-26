import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import '../style.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'login.dart';

class Registration extends StatefulWidget{
  @override
  _Registration createState() => _Registration();
}
class _Registration extends State<Registration>{
  String _picked = "Two";
  bool _isRow = true;
  String PasswordEnter = "N";
  String strPassword = "";
  DataService dataService = DataService();

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtMobileNumber = TextEditingController();
  TextEditingController txtGender = TextEditingController();
  TextEditingController txtRefferdEmail = TextEditingController();
  TextEditingController txtReenterPassword = TextEditingController();

  String Checknull() {
    if(txtFirstName.text == null || txtFirstName.text == '')  {
      return 'First Name cannot be blank. Please check.';
    }
    if  (txtEmail.text == null || txtEmail.text == '') {
      return 'Email cannot be blank. Please check.';
    }
    else{
      bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(txtEmail.text);
      if(!emailValid){
        return "Please check your email";
      }
    }
    if  (txtPassword.text == null || txtPassword.text == '') {
      return 'Password cannot be blank. Please check.';
    }

    if(txtMobileNumber.text == null || txtMobileNumber.text == '')  {
      return 'Mobile Number cannot be blank. Please check.';
    }

    if  (txtPassword.text != txtReenterPassword.text) {
      return 'Retype password should be same as password. Please check.';
    }
    return '';
  }

  Future<String> _UpdateCustomer() async {
    String res = "Faild";

    if (Checknull() != null && Checknull() != "") {
      showInfoFlushbar(context, Checknull());
      userID = "";
      isLogin = false;
    }
    else if (txtEmail.text != null && txtEmail.text != '' &&
        txtPassword.text != null && txtPassword.text != '') {
      Customer param = Customer();
      param.eMail = txtEmail.text.trim();
      param.referralEmail = txtRefferdEmail.text.trim();
      param.password = txtPassword.text.trim();
      param.firstName = txtFirstName.text.trim().toUpperCase();
      param.lastName = txtLastName.text.trim().toUpperCase();
      param.gender = _isRow == true ? "M" : "F";
      param.dOB = "";
      param.mobileNumber = txtMobileNumber.text.trim();
      param.mode = "I";

      var dt = await dataService.updateCustomer(param);

      if (dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
        userName = dt.firstName.toString().toUpperCase();
        isLogin = true;

        if (isBackendJEMiSys == "Y") {
          await dataService.updateMember("I", param);
        }
        Navigator.pop(context, false);
        res = 'OK';
      }
      else {
        showInfoFlushbar(context, dt.returnStatus);
        userID = "";
        isLogin = false;
      }
    }
    //SharedPreferences prefs =  await SharedPreferences.getInstance();

    return res;
  }

  String ShowRetypePassword() {
    if (PasswordEnter == "Y") {
      return 'Y';
    }
    else
      return 'N';
  }

  @override
  void initState() {

    super.initState();
    ShowRetypePassword();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Register",
        theme: MasterScreen.themeData(context),

        home: Scaffold(
          appBar: AppBar(
            title: Text('Register',style: TextStyle(color: Colors.white,)),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() {
                Navigator.pop(context, false);
              }
            ),
            actions: <Widget>[

            ],
            backgroundColor: Color(0xFFFF8752),
            centerTitle: true,
          ),
          body:
          SingleChildScrollView(
              child:Container(
                color: Colors.transparent,
                padding: const EdgeInsets.fromLTRB(12.0,5,12,10),//I used some padding without fixed width and height
                // Image(image: AssetImage("assets/logo3.png"),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtFirstName,
                                textCapitalization: TextCapitalization.characters,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'First Name',
                                  labelText: "First Name",
                                  prefixIcon: Icon(Icons.person),
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
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtLastName,
                                textCapitalization: TextCapitalization.characters,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Last Name',
                                  labelText: "Last Name",
                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                  ),
                                ),)
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtEmail,
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
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtPassword,
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
                                    borderSide: BorderSide(color: listLabelbgColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: listLabelbgColor, width: 1),
                                  ),
                                ),  obscureText: true,
                                onChanged: (text) {
                                  strPassword="";
                                  if (text.length>0)
                                  {
                                    PasswordEnter="Y";
                                    strPassword=text.trim();
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
                      ShowRetypePassword()=='Y'?
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,10,0,0),
                        child: Container(
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: TextField(
                                    controller: txtReenterPassword,
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Retype Password',
                                      labelText: "Retype Password",
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
                                        borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                      ),
                                    ),  obscureText: true,
                                    onChanged: (text) {
                                      setState(() {
                                      });
                                      if (text==strPassword)
                                      {
                                        PasswordEnter="N";
                                      }
                                      else
                                        PasswordEnter="Y";
                                    },)
                              ),
                            ],
                          ),
                        ),
                      ):Container(height: 0,),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtMobileNumber,
                                keyboardType: TextInputType.phone,
                                //maxLength: 15,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Mobile Number',
                                  labelText: "Mobile Number",
                                  prefixIcon: Icon(Icons.call),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  listLabelbgColor, width: 1),
                                  ),
                                ),)
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text('I\' am',style: TextStyle(color: Colors.black, fontSize: 14)),
                          ),
                          Expanded(
                            child:  Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio<bool>(
                                            value: true,
                                            groupValue: this._isRow,
                                            onChanged: (bool value) {

                                              setState(() {this._isRow = value;} );
                                            }),
                                        Text('Male',style: TextStyle(color: Colors.black, fontSize: 15)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio<bool>(
                                            value: false,
                                            groupValue: this._isRow,
                                            onChanged: (bool value) {

                                              setState((){this._isRow = value ;} );
                                            }),
                                        Text('Female',style: TextStyle(color: Colors.black, fontSize: 15)),
                                      ],

                                    ),

                                  ],

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                                controller: txtRefferdEmail,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Referred Email',
                                  labelText: "Referred Email",
                                  prefixIcon: Icon(Icons.mail_outline),
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
                                ),)
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(4.0),
                                side: BorderSide(color:Color(0xFF88A9BB)),
                              ),
                              color: buttonColor,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Register',style: TextStyle(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold )),
                                ],
                              ),
                              onPressed: () {
                                _UpdateCustomer();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
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
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: FacebookSignInButton(onPressed: () {},
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: "Roboto",color: Colors.white),
                              text: 'Facebook',
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: GoogleSignInButton(onPressed: () {}, darkMode: true,
                              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: "Roboto",color: Colors.white),
                              text: 'Google',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text("Already have an account?",
                                  style: TextStyle(fontSize: 14,color: Colors.blueGrey,fontWeight:FontWeight.bold),
                                ),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
                                        child: Text("  Login",
                                          style: TextStyle(fontSize: 15,color: Colors.green,fontWeight:FontWeight.bold,),),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage()),);
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
                      SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Here\'s Why you should REGISTER NOW!",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child:  new Container(
                              color: Colors.transparent,
                              //width: 50.0,
                              //height: 50.0,
                              padding: const EdgeInsets.all(0.0),//I used some padding without fixed width and height
                              //child: new Text('', style: new TextStyle(color: Colors.white, fontSize: 50.0)),// You can add a Icon instead of text also, like below.
                              child: new Icon(Icons.favorite, size: 27.0, color: Colors.blueGrey),
                            ),//
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:  new Container(
                              //width: 50.0,
                              //height: 50.0,
                              padding: const EdgeInsets.all(0.0),//I used some padding without fixed width and height

                              //child: new Text('', style: new TextStyle(color: Colors.white, fontSize: 50.0)),// You can add a Icon instead of text also, like below.
                              child: new Icon(Icons.local_offer, size: 27.0, color: Colors.blueGrey),
                            ),//
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:  Center(
                              child: new Container(
                                //width: 50.0,
                                //height: 50.0,
                                padding: const EdgeInsets.all(0.0),//I used some padding without fixed width and height
                                child: new Text('Make a Wishlist',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 9),),// You can add a Icon instead of text also, like below.
                              ),
                            ),//
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:  Center(
                              child: Container(
                                //width: 50.0,
                                //height: 50.0,
                                padding: const EdgeInsets.all(0.0),//I used some padding without fixed width and height
                                child: new Text('Be an Insider',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 9),),// You can add a Icon instead of text also, like below.
                              ),
                            ),////
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:  Center(
                              child: Container(
                                //width: 50.0,
                                //height: 50.0,
                                padding: const EdgeInsets.all(0.0),//I used some padding without fixed width and height
                                child: new Text('Of the designs you love!',
                                  style: TextStyle(fontSize: 10),),// You can add a Icon instead of text also, like below.
                              ),
                            ),//
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:  Center(
                              child: Container(
                                //width: 50.0,
                                //height: 50.0,
                                padding: const EdgeInsets.all(0.0),//I used some padding without fixed width and height
                                child: new Text('Launches, offers and more!',
                                  style: TextStyle(fontSize: 10),),// You can add a Icon instead of text also, like below.
                              ),
                            ),//
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        )
    );
  }
  void showInfoFlushbar(BuildContext context, String msg) {
    Flushbar(
      margin: EdgeInsets.all(8),
      backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.teal]),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      borderRadius: 8,
      title: 'Failed to Register!',
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