import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/contactUs.dart';
import 'package:jemisyseshop/view/masterPage.dart';

class MasterPageOld extends StatefulWidget{
  final int currentIndex;
  MasterPageOld({Key key, this.currentIndex}) : super(key: key);

  @override
  _masterPageOld createState() => _masterPageOld();
}

class _masterPageOld extends State<MasterPageOld> {
  int _currentIndex = 0;
  String _Title = 'eShop';
  List<MenuItem> allDestinations=[];
  List<MenuItem> choices = [];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKeyReset = GlobalKey<FormState>();

  Widget callPage(int currentIndex){
    switch(currentIndex){
      case 0: return MasterScreen();
      case 1: return new ContactUsPage();
//      case 3: return HomeT();
      break;
      default: return MasterScreen();
    }
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex;
    pageTitle();
  }
  pageTitle(){
    if(_currentIndex == 1 )_Title = 'Category';
    else if(_currentIndex == 3 )_Title = 'Login';
    else _Title = 'Shopping Store';
  }
  @override
  Widget build(BuildContext context) {
    const IconThemeData selectedIconTheme = IconThemeData(
        size: 26, color: primary1Color);
    const IconThemeData unselectedIconTheme = IconThemeData(
        size: 23, color: Colors.grey);

    return MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          drawer: Container(
              width: 220,
              child: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin, masterScreenFormKey: _formKeyReset,)),

          body: callPage(_currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedIconTheme: selectedIconTheme,
            unselectedIconTheme: unselectedIconTheme,
            selectedItemColor: primary1Color,
            onTap: (int index) {
              _currentIndex = index;
              pageTitle();

              setState(() {
              });
            },
            items: allDestinations.map((MenuItem destination) {
              return BottomNavigationBarItem(
                  icon: Icon(destination.icon,),
                  //backgroundColor: Colors.white,
                  title: Text(destination.title,)
              );
            }).toList(),
          ),
        )

    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final MaterialColor color;
  MenuItem(this.title, this.icon, this.color);
}
