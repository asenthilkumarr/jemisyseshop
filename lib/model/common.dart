
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/view/order.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String apiurl = 'http://51.79.160.233/JEMiSyseShopAPI/api/';
final String apiurlERP = 'http://51.79.160.233/JEMiSyseShopAPI/api/';
final String imageDefaultUrl = 'http://51.79.160.233/JEMiSyseShopImage/';
final String emailapiurl = "http://51.79.160.233/SMSeMailAppsToolAPI/";
final String notificationsUrl = "http://51.79.160.233/JEMiSysNotificationsAPI/api/";

final String paymenturl = "http://51.79.160.233/JEMiSyseShopAPI/api/Payment";
final String paymentBackurl = "http://51.79.160.233/JEMiSyseShopAPI/api/PaymentBack";
final String paymentSuccessurl = "http://51.79.160.233/JEMiSyseShopAPI/api/PaymentSuccess";
final String paymentSuccessurl2 = "http://localhost/Payment/SuccessMessage.html";

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
final agora_APP_ID = '7fa9aeb8265e4400933c6ea397c0625c';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;
String gProgramName = '';
String gDeviceID = '';

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
String loginMethod = "L";
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
int homeScreen = 1;

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

final List<Country2> country = [
  Country2('Singapore', 'SG', 'SGD', 'assets/SG.png'),
];

class ReminderNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReminderNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<String> GetMacAddress() async {
  String identifier;
  try {
    identifier = await FlutterUdid.udid;
  } on PlatformException {
    print('Failed to get platform version');
  }

  return identifier;
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
  static void saveUser(String userID, String password, bool isLogin, String loginMethod) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userID", userID);
    await prefs.setString("password", password);
    await prefs.setBool("isLogin", isLogin);
    await prefs.setString("loginMethod", loginMethod);
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
  static Future<String> getLoginMethod() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginMethod = await prefs.getString('loginMethod');
    return loginMethod;
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
  static void handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

class Paymentfn{
  Future<String> updateOrder(OrderData param, List<Cart> itemList, GlobalKey<FormState> _masterScreenFormKey, BuildContext context, GlobalKey _keyLoader) async{
    DataService dataService = DataService();
    String returnmag = "ERROR", orderSource = "";
    Dialogs.showLoadingDialog(context, _keyLoader);
    var status = await dataService.getCheckStockOnline(customerdata.eMail, param.deliveryMode);
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
        Navigator.of(
            _keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            OrderPage(itemlist: itemList, source: orderSource, masterScreenFormKey: _masterScreenFormKey,)), (Route<dynamic> route) => false);

//        await Dialogs.AlertMessage(context, "Order Completed");
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//            MasterScreen(currentIndex: 0, ky: null,)), (Route<dynamic> route) => false);
      }
      else{
        Navigator.of(
            _keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
        await Dialogs.AlertMessage(context, result.errorMessage);
      }
    }
    else{
      Navigator.of(
          _keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      await Dialogs.AlertMessage(context, status.returnStatus);
    }
    return returnmag;
  }

  Future<String> sendmail(String storeCode, String docNo, String docType, BuildContext context) async {
    DataService dataService = DataService();
    final _keyLoader = new GlobalKey<FormState>();
    String res = "Faild";

    SendEmail param = SendEmail();
    param.docno = docNo;
    param.mailTo=  userID;
    param.doctype= docType;
    param.vipname = userName;
    param.storeCode = storeCode;
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
