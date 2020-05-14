import 'package:flutter/material.dart';
import 'package:jemisyseshop/view/home.dart';
import 'package:jemisyseshop/view/home2.dart';
import 'package:jemisyseshop/view/home3.dart';

final List<String> menuitem = [
  'Home',
  'Home 2',
  'Home 3',
  'Diamond',
  'Engagement',
  'Wedding',
  'GemStone',
  'Jewellery',
  'About us',
  'Contact us'
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
  if(menuItem == 'Home' || menuItem == 'Home 2') {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          switch (menuItem) {
            case 'Home':
              return HomeScreen();
              break;
            case 'Home 2':
              return HomeScreen2();
              break;
            case 'Home 3':
              return HomeScreen3();
              break;

            default:
              return HomeScreen();
          }
        }), (Route<dynamic> route) => false);
  }
  else {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (menuItem) {
        case 'Home':
          return HomeScreen2();
          break;
        case 'Home 2':
          return HomeScreen3();
          break;

        default:
          return HomeScreen2();
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
                    print(item);
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