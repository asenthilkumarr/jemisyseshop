import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/test.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/productList.dart';
import 'package:jemisyseshop/view/profile.dart';
import 'common.dart';

class menuList{
  String displayname;
  String productType;
  String value;
  menuList(this.displayname, this.productType, this.value);
}
final List<menuList> menuitem =[
  menuList('Browse Gold Jewellery', "", "GOLDONLY"),
  menuList('Browse Diamond Jewellery', "", "DIAMONDONLY"),
  menuList('Browse Silver Jewellery', "", "SILVERONLY"),
  menuList('Browse Watches', "WATCHES", "WATCHONLY"),
  menuList('Browse My Transactions', "", ""),
];

final List<String> menuitem2 = [
  'Home',
  'Browse Gold Ring',
  'Browse Diamond Ring',
  'Browse Diamond Earring',
  'Browse Gold Bangles',
  'Browse Diamond Bangles',
  'Browse Watches',
//  'Engagement',
//  'Wedding',
//  'GemStone',
//  'Jewellery',
//  'About us',
//  'Contact us'
];
List<String> hitem = [
  'HOME',
  'CATEGORY',
  'TOP SELLERS',
];
List<menuList> MenuItemSplit(String type, double screenwidth) {
  int mainmenucount = 0,
      a = 0;
  List<menuList> _items = [];
  if (screenwidth > 1200 && menuitem.length < 11)
    mainmenucount = 10;
  else if (screenwidth > 900 && screenwidth <= 1200)
    mainmenucount = 8;
  else if (screenwidth > 800 && screenwidth <= 900)
    mainmenucount = 7;
  else if (screenwidth > 700 && screenwidth <= 800)
    mainmenucount = 6;
  else if (screenwidth > 600 && screenwidth <= 700)
    mainmenucount = 5;
  else if (screenwidth > 500 && screenwidth <= 600)
    mainmenucount = 4;
  else if (screenwidth > 400 && screenwidth <= 500)
    mainmenucount = 3;
  else if (screenwidth > 300 && screenwidth <= 400)
    mainmenucount = 2;
  if (type == 'H') {
    for (var i in menuitem) {
      if (a < mainmenucount) {
        _items.add(i);
      }
      a++;
    }
  }
  else if (type == 'M') {
    mainmenucount = 0;
    for (var i in menuitem) {
      if (a >= mainmenucount) {
        _items.add(i);
      }
      a++;
    }
  }
  return _items;
}

void _openPage(menuItem, BuildContext context) {

  if(menuItem == 'Home' || menuItem == 'Home 2' || menuItem == 'Home 3'
      || menuItem == 'Category' || menuItem == 'Top Sales') {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          switch (menuItem) {
            case 'Home':
              return MasterScreen(currentIndex: 0, key: null,);
              break;
            case 'Category':
              return MasterScreen(currentIndex: 1, key: null,);
              break;

            default:
              return MasterScreen(currentIndex: 0, key: null,);
          }
        }), (Route<dynamic> route) => false);
  }
  else {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (menuItem) {
        case 'Test':
          return Test();
          break;
//        case 'Category':
//          return CategoryScreen();
//          break;

        default:
          return MasterScreen(currentIndex: 0, key: null,);
      }
    }));
  }
}

class MenuItemWedget extends StatelessWidget {
  DataService dataService = DataService();
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isLogin;
  final GlobalKey<FormState> masterScreenFormKey;
  final _keyLoader = new GlobalKey<FormState>();

  MenuItemWedget({Key key, this.scaffoldKey, this.isLogin, this.masterScreenFormKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    var _items = MenuItemSplit('M', screenSize.width);
    if (_items.length > 0) {
      return new Drawer(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(-0.4, -0.8),
                      stops: [0.0, 0.5, 0.5, 1],
                      colors: [
                        Color(0xfffff7f3), //red
                        Color(0xffffffff), //red
                        Color(0xffffffff), //orange
                        Color(0xffffffff), //orange
                      ],
                      tileMode: TileMode.repeated
                  ),

                ),
              ),
              Column(
                children: [
                  /*
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Menu'),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(scaffoldKey.currentContext).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        )
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
                */
                  Container(
                    color: Color(0xFFEBEAF6),
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0, top: 15, right: 15.0, bottom: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 17.0,
                            backgroundColor: buttonColor,
                            child: Text("${userName[0]}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                          ),
                          SizedBox(width: 15,),
                          Text(userName,),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              scaffoldKey.currentState.openEndDrawer();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),);
                            },
                            child: CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors
                                  .green,
                              child: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 23,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  for(var item in _items)
                    Column(
                      children: [
                        SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () async {
                            if(item.value != "") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductListPage(
                                          title: item.displayname.replaceAll(
                                              "Browse ", ""),
                                          masterScreenFormKey: masterScreenFormKey,
                                          fsource: "MENU",
                                          filterType: item.value,),)
                              );
                            }
                            else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),);
                            }
                            scaffoldKey.currentState.openEndDrawer();
                          },
                          child: Container(
                            color: Colors.black,
//                height: 60,
                            child: Row(
                              children: [
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 12,),
//                                Text("SHAYA", style: TextStyle(color: Colors.white, fontSize: 19, fontStyle: FontStyle.italic),),
                                    Text(item.displayname, style: TextStyle(color: Colors.white, fontSize: 16),),
                                    SizedBox(height: 12,),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.chevron_right, color: Colors.white,size: 30,),
                              ],
                            ),
                          ),
                        ),
//                    ListTile(
//                        title: Text(item),
//                        onTap: () {
//                          scaffoldKey.currentState.openEndDrawer();
//                          _openPage(item, context);
//                        }
//                    ),
                      ],
                    ),
//              ListTile(
//                  title: Text('Jewellery'),
//                  onTap: () {
//                    scaffoldKey.currentState.openEndDrawer();
//                    _openPage('Jewellery', context);
//                  }
//              ),
                SizedBox(height: 5,),
                  ListTile(
                      title: Text('About us'),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        _openPage('About us', context);
                      }
                  ),
                  ListTile(
                      title: Text('Contact us'),
                      onTap: () {
                        scaffoldKey.currentState.openEndDrawer();
                        _openPage('Contact us', context);
                      }
                  ),
//              isLogin ? ListTile(
//                  title: Text('Sign out'),
//                  onTap: () {
//                    scaffoldKey.currentState.openEndDrawer();
//                    _openPage('Sign out', context);
//                  }
//              ) : Container(),
//              ListTile(
//                  title: Text('Test'),
//                  onTap: () {
//                    scaffoldKey.currentState.openEndDrawer();
//                    _openPage('Test', context);
//                  }
//              ),
                ],
              ),
            ]
          ),
        ),
      );
    }
    else
      return new Drawer();
  }
}

class HorizontalMenuWedget extends StatelessWidget {
  final TabController tabController;

  HorizontalMenuWedget({Key key, this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return new TabBar(
      isScrollable: true,
      controller: tabController, indicatorColor: listLabelbgColor, tabs: [
      for(var i in hitem)
        Tab(
          child: Text(
            i,
            style: TextStyle(fontFamily: "BarlowBold", color: Colors.black),
          ),
        ),
    ],
      onTap: (index) {
        if(tabController.index == 0)
          _openPage('Home', context);
        else if(tabController.index == 1)
          _openPage('Category', context);
        else if(tabController.index == 2)
          _openPage('Top Sales', context);
      },
    );
  }
}

class HorizontalMenuWedget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return new TabBar(
      indicatorColor: listLabelbgColor, tabs: [
      for(var i in hitem)
        Tab(
          child: Text(
            i,
            style: TextStyle(fontFamily: "BarlowBold", color: Colors.black),
          ),
        ),
    ],
      onTap: (index) {

      },
    );
  }
}

class FilterMenuWedget extends StatelessWidget {
  final TabController tabController;

  FilterMenuWedget({Key key, this.tabController}) : super(key: key);
  List<String> mitem = [
    'ALL',
    'LATEST',
    'SALE',
    'MOST POPULAR',
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return new TabBar(
      isScrollable: true,
      controller: tabController,
      indicatorColor: listLabelbgColor,
      tabs: [
        for(var i in mitem)
          Tab(
            child: Text(
              i,
              style: TextStyle(
                  fontFamily: "BarlowBold", color: Colors.black),
            ),
          ),
      ],
      labelPadding: EdgeInsets.only(left: 10, right:10),
//      indicatorWeight: 1.0,
      onTap: (index) {

      },
    );
  }
}
/*
class HorizontalMenuWedget3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    var _items = MenuItemSplit('H', screenSize.width);
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          children: <Widget>[
            for(var item in _items )
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child:
                  SizedBox(
                    height: 30,
                    child: FlatButton(
                      onPressed: () {
                        _openPage(item, context);
                      },
                      child: Text(
                        item,
                        //style: titleMenuText,
                      ),
                    ),
                  )
              ),
          ],
        )
      ],
    );
  }
}
*/
class MenuNavigate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  }
}