import 'package:intl/intl.dart';
import 'package:jemisyseshop/model/dataObject.dart';

final String apiurl = 'http://42.61.99.57/JEMiSyseShopAPI/api/';
final String imageDefaultUrl = 'http://42.61.99.57/JEMiSyseShopImage/';
String imgFolderName = "";
String imageUrl = "";
String bannerimageUrl = '';
String startupimageUrl = "";

String titMessage = "";

final List<Country> country = [
  Country('Singapore', 'SG', 'SGD', 'assets/SG.png'),
];
String currencysymbol = "\$";
String appTitle = "JEMiSys eShop";
bool isLogin = false;
bool hideGoldRate = false;
bool hideTitleMessage = false;
int hMenuCount = 3;
int fMenuCount = 4;

final formatter2dec = new NumberFormat('##0.00', 'en_US');
final formatterint = new NumberFormat('##0', 'en_US');
