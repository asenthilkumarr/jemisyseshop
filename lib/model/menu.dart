import 'package:flutter/material.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/home.dart';
import 'package:jemisyseshop/view/home2.dart';
import 'package:jemisyseshop/view/home3.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'common.dart';

class menuList{
  String name;
  Widget url;
  menuList(this.name, this.url);
}
final List<String> menuitem = [
  'Home',
  'Home 2',
//  'Home 3',
  'Diamond',
  'Engagement',
  'Wedding',
  'GemStone',
  'Jewellery',
  'About us',
  'Contact us'
];
List<String> hitem = [
  'HOME',
  'CATEGORY',
  'TOP SELLERS',
];
List<String> MenuItemSplit(String type, double screenwidth) {
  int mainmenucount = 0,
      a = 0;
  List<String> _items = [];
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
    mainmenucount = 1;
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
  print(menuItem);
  if(menuItem == 'Home' || menuItem == 'Home 2' || menuItem == 'Home 3'
      || menuItem == 'Category' || menuItem == 'Top Sales') {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          switch (menuItem) {
            case 'Home':
              return MasterScreen(currentIndex: 0, key: null,);
              break;
            case 'Home 2':
              return HomeScreen2();
              break;
//            case 'Top Sales':
//              return TopSellingScreen();
//              break;
            case 'Category':
              return MasterScreen(currentIndex: 1, key: null,);
              break;

            default:
              return HomeScreen();
          }
        }), (Route<dynamic> route) => false);
  }
  else {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (menuItem) {
//        case 'Top Sales':
//          return TopSellingScreen();
//          break;
//        case 'Category':
//          return CategoryScreen();
//          break;
        case 'Home 3':
          return HomeScreen3();
          break;

        default:
          return HomeScreen();
      }
    }));
  }
}

class MenuItemWedget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isLogin;

  MenuItemWedget({Key key, this.scaffoldKey, this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    var _items = MenuItemSplit('M', screenSize.width);
    if (_items.length > 0) {
      return new Drawer(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
            ),
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
            for(var item in _items )
              ListTile(
                  title: Text(item),
                  onTap: () {
                    _openPage(item, context);
                  }
              ),
            isLogin ? ListTile(
                title: Text('Sign out'),
                onTap: () {
                  _openPage('Sign out', context);
                }
            ) : Container(),
          ],
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

class MenuNavigate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  }
}