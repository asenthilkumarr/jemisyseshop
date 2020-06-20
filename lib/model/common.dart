import 'package:intl/intl.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String apiurl = 'http://42.61.99.57/JEMiSyseShopAPI/api/';
final String imageDefaultUrl = 'http://42.61.99.57/JEMiSyseShopImage/';
String imgFolderName = "";
String imageUrl = "";
String bannerimageUrl = '';
String startupimageUrl = "";
String fontName = "Loto";
String isBackendJEMiSys = "N";

String userID = "";
String userName = "";
bool isLogin = false;
String udid = "";
int cartCount = 0;
Customer customerdata;

String titMessage = "";

final List<Country2> country = [
  Country2('Singapore', 'SG', 'SGD', 'assets/SG.png'),
];
String currencysymbol = "\$";
String appTitle = "JEMiSys eShop";
bool hideGoldRate = false;
bool hideTitleMessage = false;
int hMenuCount = 3;
int fMenuCount = 4;

final formatter2dec = new NumberFormat('#,##0.00', 'en_US');
final formatterint = new NumberFormat('#,##0', 'en_US');

class Commonfn{
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
}