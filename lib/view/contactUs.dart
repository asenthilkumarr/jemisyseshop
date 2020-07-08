import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget{
  @override
  _contactUsPage createState() => _contactUsPage();
}
class _contactUsPage extends State<ContactUsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DataService dataService = DataService();
  Setting _setting = new Setting();
  Future<void> _launched;
  String _phone = '';
  Color currentColor = primary1Color;
  Color bgColor = Colors.white;
  void changemenuColor(Color color) => setState(() => currentColor = color);
  void changebgColor(Color color) => setState(() => bgColor = color);

  void loadDefault() async{
    var dt = await dataService.getSetting();
    if(dt.length>0)
      _setting = dt[0];
    setState(() {

    });
  }
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> _createEmail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  String iconImg = imageDefaultUrl + imgFolderName+"/icon.png";
  @override
  void initState(){
    super.initState();
    loadDefault();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Contact Us',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        key: scaffoldKey,
        drawer: MenuItemWedget2(scaffoldKey: scaffoldKey, isLogin: false, color: currentColor, bgcolor: bgColor,),
        appBar: AppBar(
          title: Text('Contact Us', style: TextStyle(color: Colors.white),),
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
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0, 1],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Color(0xFFFFEBEE),
                      Color(0xFFFFFFE0),//0xFFEDE7F6
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    children: [
                      Container(
//                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: SweepGradient(
                              colors: [Colors.blue, Colors.green, Colors.yellow, Colors.red, Colors.blue],
                              stops: [0.0, 0.25, 0.5, 0.75, 1],
                            ),
                            shape: BoxShape.rectangle
                        ),
                        /*
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.1, 0.3, 0.7, 1],
                                colors: [primary1Color, Colors.white30, Colors.orange, primary1Color])
                        ),
                         */
                        child:  _setting != null ? Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(iconImg, height: 100,),
                            ),
                            _setting.contactCompanyName != null && _setting.contactCompanyName != "" ?
                            Text(_setting.contactCompanyName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),)
                            : Container(),
                            SizedBox(height: 10,),
                            _setting.contactName != null && _setting.contactName != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    //_launched = _makePhoneCall('tel:${_setting.contactNumber}');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person, color: Colors.white, size: 20,),
                                      SizedBox(width: 10,),
                                      Text(_setting.contactName, style: TextStyle(fontSize: 18, color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactName != null && _setting.contactName != "" ? SizedBox(height: 10,) : Container(),
                            _setting.contactNumber != null && _setting.contactNumber != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                  //_launched = _makePhoneCall('tel:${_setting.contactNumber}');
                                  },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.phone, color: Colors.white, size: 20,),
                                    SizedBox(width: 10,),
                                    Text(_setting.contactNumber, style: TextStyle(fontSize: 18, color: Colors.white),),
                                  ],
                                ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactNumber != null && _setting.contactNumber != "" ? SizedBox(height: 10,) : Container(),
                            _setting.contactEmail != null && _setting.contactEmail != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    //_createEmail('mailto:${_setting.contactEmail}');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email, color: Colors.white, size: 20,),
                                      SizedBox(width: 10,),
                                      Text(_setting.contactEmail, style: TextStyle(fontSize: 18, color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactEmail != null && _setting.contactEmail != "" ? SizedBox(height: 10,) : Container(),
                          ],
                        )
                        : Container(),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        color: Color(0xFFD7DBDD),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Reach us:"),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _setting.contactEmail != null && _setting.contactEmail != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    _createEmail('mailto:${_setting.contactEmail}');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.email, color: Colors.grey, size: 20,),
                                      SizedBox(width: 10,),
                                      Text("Mail us", style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactEmail != null && _setting.contactEmail != "" ? Divider() : Container(),
                            _setting.contactNumber != null && _setting.contactNumber != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    _launched = _makePhoneCall('tel:${_setting.contactNumber}');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.phone, color: Colors.grey, size: 20,),
                                      SizedBox(width: 10,),
                                      Text("Give us a call", style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactNumber != null && _setting.contactNumber != "" ? Divider() : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        color: Color(0xFFD7DBDD),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Find us on:"),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _setting.contactInstagram != null && _setting.contactInstagram != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    _launched = _launchInBrowser('${_setting.contactInstagram}');
                                  },
                                  child: Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/instagram.png", height: 20,),
                                      SizedBox(width: 10,),
                                      Text("Instagram", style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactInstagram != null && _setting.contactInstagram != "" ? Divider() : Container(),
                            _setting.contactFacebook != null && _setting.contactFacebook != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    _launched = _launchInBrowser('${_setting.contactFacebook}');
                                  },
                                  child: Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/facebook.png", height: 20,),
                                      SizedBox(width: 10,),
                                      Text("FaceBook", style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactFacebook != null && _setting.contactFacebook != "" ? Divider() : Container(),
                            _setting.contactTwitter != null && _setting.contactTwitter != "" ? Container(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    _launched = _launchInBrowser('${_setting.contactTwitter}');
                                  },
                                  child: Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/twitter.png", height: 20,),
                                      SizedBox(width: 10,),
                                      Text("Twitter", style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ),
                            ) : Container(),
                            _setting.contactTwitter != null && _setting.contactTwitter != "" ? Divider() : Container(),
                          ],
                        ),
                      )
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}