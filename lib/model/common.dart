import 'package:jemisyseshop/model/dataObject.dart';

final String apiurl = 'http://42.61.99.57/JEMiSyseShopAPI/api/';
final String imageUrl = 'http://42.61.99.57/JEMiSyseShopImage/jewelimages/';

final List<Country> country = [
  Country('Singapore', 'SG', 'SGD', 'assets/SG.png'),
];
String currencysymbol = "\$";
bool isLogin = false;
bool hideGoldRate = false;
bool hideTitleMessage = false;
int hMenuCount = 3;
int fMenuCount = 4;
