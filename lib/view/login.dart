import 'dart:convert';
//import 'dart:convert' as JSON;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
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

  Map userProfile;
  final FacebookLogin _facebookLogin = FacebookLogin();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount _currentUser;
  String _contactText;

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }
  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }
  Future<void> _handleSignIn() async {
    try {
//      _handleSignOut();
      await _googleSignIn.signIn();
      setState(() {

      });
      if(_googleSignIn.currentUser != null){
        Customer param = Customer();
        param.eMail = _googleSignIn.currentUser.email;

        Dialogs.showLoadingDialog(context, _keyLoaderLogin); //invoking go
        var dt = await dataService.getCustomer(param);
        if (dt != null && dt.returnStatus != null && dt.returnStatus == 'OK') {
          userID = dt.eMail.toString();
          userName = dt.firstName.toString().toUpperCase();
          isLogin = true;
          var cartdt = await dataService.getCart(userID, "S");
          cartCount = cartdt.length;
          widget.masterScreenFormKey?.currentState?.reset();

          Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
              .pop(); //close the dialoge
          Navigator.pop(context, dt.eMail);
        }
        else if(dt == null){
          Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
              .pop(); //close the dialoge
          _UpdateCustomer();
//          objcf.showInfoFlushbar(context, "eMail does not exists. Want to register?", 'Failed to login!');
        }
        else {
          Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
              .pop(); //close the dialoge
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Registration()),);
        }
      }
    } catch (error) {
      print(error);
    }
  }
  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<Null> _login() async {
    final FacebookLoginResult result =
    await _facebookLogin.logIn(["email"]);
    print("-----------------------------AAAAAAAAAAAAA-------------------------");
    print(result.status);
    print("-----------------------------AAAAAAAAAAAAA-------------------------");
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
//        _showMessage('''
//         Logged in!
//
//         Token: ${accessToken.token}
//         User id: ${accessToken.userId}
//         Expires: ${accessToken.expires}
//         Permissions: ${accessToken.permissions}
//         Declined permissions: ${accessToken.declinedPermissions}
//         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() => isLogin = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => isLogin = false );
        break;
    }
  }
  /*
  _loginWithFB() async{
    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          isLogin = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => isLogin = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => isLogin = false );
        break;
    }
  }
*/
  Future<String> _UpdateCustomer() async {
    String res = "Faild";
    if (_googleSignIn.currentUser != null) {
      Customer param = Customer();
      param.eMail = _googleSignIn.currentUser.email;
      param.firstName = _googleSignIn.currentUser.displayName.toUpperCase();
      param.lastName = "";
      param.dOB = "";
      param.mode = "I";

      var dt = await dataService.updateCustomer(param);

      if (dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
        userName = dt.firstName.toString().toUpperCase();
        isLogin = true;

        if (isBackendJEMiSys == "Y") {
          await dataService.updateMember("I", param);
        }
        customerdata = param;
        Navigator.pop(context, false);
        res = 'OK';
      }
      else {
        userID = "";
        isLogin = false;
      }
    }
    //SharedPreferences prefs =  await SharedPreferences.getInstance();

    return res;
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetContact,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

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

  Future<String> checkLogin(String tuserID, String tpassword, bool isSocialAurth) async {
    Commonfn objcf = new Commonfn();
    String res = "Failed";
    FocusScope.of(context).requestFocus(FocusNode());
    //SharedPreferences prefs =  await SharedPreferences.getInstance();
    if (Checknull() != "") {
      objcf.showInfoFlushbar(context, Checknull(), 'Failed to login!');
      userID = "";
      isLogin = false;
    }
    else if (tuserID != null && tuserID != '' &&
        tpassword != null && tpassword != '') {
      Customer param = Customer();
      param.eMail = tuserID.trim();
      param.password = tpassword.trim();

      Dialogs.showLoadingDialog(context, _keyLoaderLogin); //invoking go
      var dt = await dataService.getCustomer(param);
      if (dt != null && dt.returnStatus != null && dt.returnStatus == 'OK') {
        userID = dt.eMail.toString();
//        password = txtpassword.text.trim();
        userName = dt.firstName.toString().toUpperCase();
        isLogin = true;
        var cartdt = await dataService.getCart(userID, "S");
        cartCount = cartdt.length;
        widget.masterScreenFormKey?.currentState?.reset();
        if(!isSocialAurth)
          Commonfn.saveUser(tuserID, tpassword, true);

        Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        Navigator.pop(context, dt.eMail);
        res = 'OK';
      }
      else if(dt == null){
        Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        objcf.showInfoFlushbar(context, "eMail does not exists. Want to register?", 'Failed to login!');
      }
      else {
        Navigator.of(_keyLoaderLogin.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        objcf.showInfoFlushbar(context, dt.returnStatus, 'Failed to login!');
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
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
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
            title: Text('Login',style: TextStyle(color: Colors.white,)),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() => Navigator.pop(context, false),
            ),
            actions: <Widget>[

            ],
            backgroundColor: Color(0xFFFF8752),
            centerTitle: true,
          ),
          /*
            body: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: _buildBody(),
            )
            */
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
                                constraints: BoxConstraints(minWidth: 250, maxWidth: 350),
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
                                                checkLogin(txtuserid.text, txtpassword.text, true);
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
                                            child: FacebookSignInButton(onPressed: _login,
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                              text: 'Facebook',
                                            ),
                                          ),
                                          SizedBox(width: 3,),
                                          Expanded(
                                            child: GoogleSignInButton(onPressed: _handleSignIn, darkMode: true,
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
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
}