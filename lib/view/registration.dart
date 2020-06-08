import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../style.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
class Registration extends StatefulWidget{
  @override
  _Registration createState() => _Registration();
}
class _Registration extends State<Registration>{
  String _picked = "Two";
  bool _isRow = true;
  String PasswordEnter = "N";
  String txtPassword = "";


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
            title: Text('Register',style: GoogleFonts.lato(color: Colors.white,fontWeight:FontWeight.bold )),
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
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
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
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
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
                                // controller: inputtextFielduserID,
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
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
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
                                // controller: inputtextFielduserID,
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
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:Color(0xFF88A9BB), width: 1),
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
                                    // controller: inputtextFielduserID,
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
                                        borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                      ),
                                    ),  obscureText: true,
                                    onChanged: (text) {
                                      setState(() {
                                      });
                                      if (text==txtPassword)
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
                                // controller: inputtextFielduserID,
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
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
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
                            child: Text('I\' am',style: GoogleFonts.lato(color: Colors.black, fontSize: 14)),
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
                                              setState(() => this._isRow = value);
                                            }),
                                        Text('Male',style: GoogleFonts.lato(color: Colors.black, fontSize: 15)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio<bool>(
                                            value: false,
                                            groupValue: this._isRow,
                                            onChanged: (bool value) {
                                              setState(() => this._isRow = value);
                                            }),
                                        Text('Female',style: GoogleFonts.lato(color: Colors.black, fontSize: 15)),
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
                                // controller: inputtextFielduserID,
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
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Color(0xFF88A9BB), width: 1),
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
                              color: Color(0xFF88A9BB),
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Register',style: GoogleFonts.lato(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold )),
                                ],
                              ),
                              onPressed: () {
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
                                  style: GoogleFonts.lato(fontSize: 14,color: Colors.blueGrey,fontWeight:FontWeight.bold),
                                ),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
                                        child: Text("  Login",
                                          style: GoogleFonts.lato(fontSize: 15,color: Colors.green,fontWeight:FontWeight.bold,),),
                                        onTap: () {
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
                                  style: GoogleFonts.lato(fontSize: 9),
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
                                  style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 9),),// You can add a Icon instead of text also, like below.
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
                                  style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 9),),// You can add a Icon instead of text also, like below.
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
                                  style: GoogleFonts.lato(fontSize: 10),),// You can add a Icon instead of text also, like below.
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
                                  style: GoogleFonts.lato(fontSize: 10),),// You can add a Icon instead of text also, like below.
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
}