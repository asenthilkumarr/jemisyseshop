
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String apiurl = 'http://51.79.160.233/JEMiSyseShopAPI/api/';
final String apiurlERP = 'http://51.79.160.233/JEMiSyseShopAPI/api/';
final String imageDefaultUrl = 'http://51.79.160.233/JEMiSyseShopImage/';
final String emailapiurl = "http://51.79.160.233/SMSeMailAppsToolAPI/";

final String paymenturl = "http://51.79.160.233/JEMiSyseShopAPI/api/Payment";
final String paymentBackurl = "http://51.79.160.233/JEMiSyseShopAPI/api/PaymentBack";
final String paymentSuccessurl = "http://51.79.160.233/JEMiSyseShopAPI/api/PaymentSuccess";
final String paymentSuccessurl2 = "http://localhost/Payment/SuccessMessage.html";

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

String imgFolderName = "";
String imageUrl = "";
String bannerimageUrl = '';
String startupimageUrl = "";
String fontName = "Loto";

String userID = "";
String userName = "";
//String password = "";
bool isLogin = false;
String udid = "";
int cartCount = 0;
Customer customerdata;

/*
String gDocNo = '';
String gVipName = '';
String gVipNo = '';
String gStoreCode = 'HQ';
String gDate = '';
String gNextDuedate = '';
int gTotalAmount =0;
int gReceivedAmount = 0;
int gBalanceAmount = 0;
*/
String titMessage = "";
double screenWidth = 300;
double screenMainContentWidth = 700;

String currencysymbol = "\$";
String currencyCode = "\$";
String appTitle = "JEMiSys eShop";
bool hideGoldRate = false;
bool hideTitleMessage = false;
int hMenuCount = 3;
int fMenuCount = 4;
String paymentGateway = "", aboutusUrl = "";
String isBackendJEMiSys = "N";
bool isERPandEShopOnSameServer = false;

final formatter2dec = new NumberFormat('#,##0.00', 'en_US');
final formatterint = new NumberFormat('#,##0', 'en_US');

Color menubgColor = Color(0xFFFFF1F1);
Color menuitembgColor = Color(0xFF170904);

class Message {
  final String title;
  final String body;
  final String screen;
  const Message({
    @required this.title,
    @required this.body,
    @required this.screen,
  });
}

final List<Country2> country = [
  Country2('Singapore', 'SG', 'SGD', 'assets/SG.png'),
];

Future<String> GetMacAddress() async {
  String platformVersion;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    platformVersion = await GetMac.macAddress;
  } on PlatformException {
    platformVersion = 'Failed';
  }

  return platformVersion;
}

class Commonfn{
  Future<Customer> getCustomer(String userID, String password) async{
    DataService dataService = DataService();
    Customer param = Customer();
    param.eMail = userID;
    param.password = password;
    var dt = await dataService.getCustomer(param);
    return dt;
  }
  void showInfoFlushbar(BuildContext context, String msg, String _title) {
    Flushbar(
      margin: EdgeInsets.all(8),
      backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.teal]),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      borderRadius: 8,
      title: _title,
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

  static void setMenuColor(String color, String bgcolor) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("menuitembgColor", color);
    await prefs.setString("menubgColor", bgcolor);
  }
  static void getMenuColor() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var color = await prefs.getString('menuitembgColor');
      print(color);
      if (color != null) {
        menuitembgColor = new Color(
            int.parse((color.replaceAll("Color(", "")).replaceAll(")", "")));
        color = await prefs.getString('menubgColor');
        menubgColor = new Color(
            int.parse((color.replaceAll("Color(", "")).replaceAll(")", "")));
      }
    }
    on Exception catch (_){

    }
  }
  static void saveUser(String userID, String password, bool isLogin) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userID", userID);
    await prefs.setString("password", password);
    await prefs.setBool("isLogin", isLogin);
  }
  static Future<String> getUserID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = await prefs.getString('userID');
    return userID;
  }
  static Future<String> getPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String password = await prefs.getString('password');
    return password;
  }
  static Future<bool> getLoginStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = await prefs.getBool('isLogin');
    return isLogin;
  }

  double ScreenWidth(double tscreenwidth) {
    double sWidth = 0,
        a = 0;
    if (tscreenwidth <= 550)
      sWidth = tscreenwidth;
    else if (tscreenwidth <= 750)
      sWidth = tscreenwidth;
    else if (tscreenwidth <= 850)
      sWidth = 700;
    else if (tscreenwidth <= 1050)
      sWidth = 800;
    else if (tscreenwidth <= 1200)
      sWidth = 900;
    else if (tscreenwidth <= 1450)
      sWidth = 1050;
    else if (tscreenwidth <= 1600)
      sWidth = 1300;
    else
      sWidth = 1400;

    return sWidth;
  }
}

class Paymentfn{
  Future<String> updateOrder(OrderData param, List<Cart> itemList, GlobalKey<FormState> _masterScreenFormKey, BuildContext context) async{
    DataService dataService = DataService();
    String returnmag = "ERROR", orderSource = "";
    var status = await dataService.getCheckStockOnline(customerdata.eMail);
    if(status.status == 1 && status.returnStatus == "OK"){
      if(param.deliveryMode=="H")
        orderSource = "HT";
      var result = await dataService.updateOrder(param);
      if(result.status == 1){
        if(isERPandEShopOnSameServer == false && isBackendJEMiSys == "Y"){
          await dataService.updateOrderSync(result.value);
        }
        await sendmail("", result.value, "eCORDER", context);
        returnmag = "OK";
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            OrderPage(itemlist: itemList, source: orderSource, masterScreenFormKey: _masterScreenFormKey,)), (Route<dynamic> route) => false);

//        await Dialogs.AlertMessage(context, "Order Completed");
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//            MasterScreen(currentIndex: 0, ky: null,)), (Route<dynamic> route) => false);
      }
      else{
        await Dialogs.AlertMessage(context, result.errorMessage);
      }
    }
    else{
      await Dialogs.AlertMessage(context, status.returnStatus);
    }
    return returnmag;
  }

  Future<String> sendmail(String storeCode, String docNo, String docType, BuildContext context) async {
    DataService dataService = DataService();
    final _keyLoader = new GlobalKey<FormState>();
    String res = "Faild";
    //SharedPreferences prefs =  await SharedPreferences.getInstance();
//    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    SendEmail param = SendEmail();
    param.docno = docNo;
    param.mailTo=  userID;
    param.doctype= docType;
    param.vipname = userName;
    param.storeCode = storeCode;
    print(param.toParam());
    print("------------------------------------------------------------AAAAAAAAAAAA------------------------------------");
    var dt2 = await dataService.sendEmailtoCustomer(param);
//    await Navigator.of(
//        _keyLoader.currentContext, rootNavigator: true)
//        .pop(); //close the dialoge

    if (dt2 != null && dt2.returnStatus != null && dt2.returnStatus == 'Message Sent Succesfully') {
      res = 'OK';
    }
    else {
//        gEmailreturnMsg='Failed to send email. please check.';
    }
    return res;
  }
}
