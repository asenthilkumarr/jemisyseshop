import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../model/dataObject.dart';
class HomeScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: brightness1,
        primaryColor: primary1Color,
        accentColor: accent1Color,
        //primarySwatch: primary1Color,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Home extends StatefulWidget{
  @override
  _home createState() => _home();
}
class _home extends State<Home> {
  final List<String> images = [
    'http://42.61.99.57/JEMiSyseShopImage/Banner3.png',
//    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
//    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
  ];
  final List<String> category = [
    'Diamond',
    'Engagement',
    'Weeding',
    'GemStone',
    'Jewellery',
    'About us',
    'Contact us'
  ];
  final List<ItemMasterList> items = [
    ItemMasterList('IN00001', 'Item 1','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00002', 'Item 2','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00003', 'Item 3','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00004', 'Item 4','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00005', 'Item 5','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
    ItemMasterList('IN00006', 'Item 6','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
//    ItemMasterList('IN00007', 'Item 7','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
//    ItemMasterList('IN00008', 'Item 8','Diamond','https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
  ];

  Drawer menuList(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    var _items = MenuItemSplit('M', screenSize.width);
    if(_items.length>0){
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
              ),
          ],
        ),
      );
    }
    else
      return new Drawer();
  }

  Container PageTitleBar(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    var _items = MenuItemSplit('M', screenSize.width);
    return new Container(
      color: titlebgColor,
      height: 50,
      width: screenSize.width,
      child: Row(
        children: [

          SizedBox(
            width: 15,
          ),
          _items.length>0 ? GestureDetector(

              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: title1Color,
              )
          ) : Container(),
          Spacer(),
          SizedBox(
            width: 80,
            child: FlatButton(
              onPressed: () {
                /*...*/
              },
              child: Text(
                "Login",
                style: titleMenuText,
              ),
            ),
          ),

          SizedBox(
              width: 90,
              child: FlatButton(
                onPressed: () {
                  /*...*/
                },
                child: Text(
                  "Sign up",
                  style: titleMenuText,
                ),
              )
          )
        ],
      ),
    );
  }

  Container BannerImage(BuildContext context) {
    print(images.length);
    if (images.length > 1) {
      return new Container(
        color: primary1Color,
          height: 90,
          width: MediaQuery
              .of(context)
          .size.width,
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 0.0,
            height: 90,
            //enlargeCenterPage: true,
          ),
          itemBuilder: (context, index) {
            return Container(
              color: primary1Color,
                child: Image.network(images[index],
                  fit: BoxFit.fill, width: MediaQuery
                      .of(context)
                      .size.width,
                )
            );
          },
        ),
      );
    }
    else {
      return new Container(
          color: primary1Color,
          height: 80,
          width: MediaQuery
              .of(context)
              .size.width,
          child: Image.network(images[0],
            fit: BoxFit.fitHeight, width: MediaQuery
                .of(context)
                .size.width,
          )
      );
    }
  }

  List<String> MenuItemSplit(String type, double screenwidth){
    int mainmenucount = 0, a =0;
    List<String> _items = [];
    if(screenwidth > 1200 && category.length < 11)
      mainmenucount = 10;
    else if(screenwidth > 900 && screenwidth <= 1200)
      mainmenucount = 8;
    else if(screenwidth > 800 && screenwidth <=900)
      mainmenucount = 7;
    else if(screenwidth > 700 && screenwidth <=800)
      mainmenucount = 6;
    else if(screenwidth > 600 && screenwidth <=700)
      mainmenucount = 5;
    else if(screenwidth > 500 && screenwidth <=600)
      mainmenucount = 4;
    else if(screenwidth > 400 && screenwidth <=500)
      mainmenucount = 3;
    else if(screenwidth > 300 && screenwidth <=400)
      mainmenucount = 2;
    if(type == 'H') {
      for (var i in category) {
        if (a < mainmenucount) {
          _items.add(i);
        }
        a++;
      }
    }
    else if(type == 'M') {
      for (var i in category) {
        if (a >= mainmenucount) {
          _items.add(i);
        }
        a++;
      }
    }
    return _items;
  }

  Row HorizontalMenu(List<String> item, BuildContext context) {
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
                        /*...*/
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

//    if ((screenSize.width > 1200 && category.length < 9)
//        || (screenSize.width > 900 && category.length < 7)
//        || (screenSize.width > 800 && category.length < 6)
//        || (screenSize.width > 700 && category.length < 5)) {
//    }
//    else {
//      return new Row();
//    }
  }

  Widget SelectedListItems() {
    print(items.length);
    List<Widget> list = new List<Widget>();
    for(var item in items){
      list.add(Card(
          elevation: 1.5,
          child: Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                          item.imageUrl, height: 100, width: 100,),
                        //Spacer(),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          5.0, 0.0, 5.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                              child: Center(
                                child: Text('${item.description}'),
                              )
                          ),
                          //Spacer(),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
//                        shape: new RoundedRectangleBorder(
//                          borderRadius: new BorderRadius.circular(10.0),
//                          side: BorderSide(color: Colors.redAccent),
//                        ),
                              color: Colors.white,
                              padding: EdgeInsets.all(3.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 4.0, 0.0),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: primary1Color,
                                      size: 30.0,
                                    ),
                                  ),
                                  Text(
                                    "Add to cart",
                                    style: TextStyle(
                                        color: primary1Color, fontSize: 13
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                //_getDeviceSetting();
                              },
                            ),
                            //Spacer(),
                          ],
                        )

                    ),
                  ]
              )
          )
      ));
    }
    print(list.length);
    return new Row(children: list);
    //return new ;
    //return new Wrap();
  }

  Widget getTextWidgets(ItemMasterList item) {
    print(item.description);
      return new Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  item.imageUrl, height: 100, width: 100,),
                //Spacer(),
              ],
            ),
            Text(item.description),
          ],
        ),
      );
    }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    print(screenSize.width);
    double screenheight = screenSize.height;
    if (!kIsWeb) screenheight = screenSize.height - 24;

    return Scaffold(
        key: scaffoldKey,
        drawer: menuList(context),
        body: Container(
                height: screenheight,
                width: screenSize.width,
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        PageTitleBar(context),

                        BannerImage(context),

                        HorizontalMenu(category, context),
          Expanded(
            child: SingleChildScrollView(
                        child: GridView.count(
                          primary: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          shrinkWrap: true,
                          children: List.generate(items.length, (index) {
                            return getTextWidgets(items[index]);
                          }),
                        )
            )),
//                getTextWidgets(),

//                        ClipPath(
//                          child: Container(
//                            color: Colors.blue[600],
//                            height: 120,
//                            width: screenSize.width,
//                          ),
//                          clipper: WaveClipperTwo(),
//                        ),
                      ],
                    ),

//                    Positioned(
//                      child: ClipPath(
//                        child: Container(
//                          color: Colors.blue[400],
//                          height: 80,
//                          width: screenSize.width,
//                        ),
//                        clipper: WaveClipperOne(reverse: true),
//                      ),
//                      bottom: 0,
//                      left: 0,
//                    ),
//                    Positioned(
//                      child: ClipPath(
//                        child: Container(
//                          color: Colors.blue[600],
//                          height: 90,
//                          width: screenSize.width,
//                        ),
//                        clipper: WaveClipperTwo(reverse: true),
//                      ),
//                      bottom: 0,
//                      left: 0,
//                    )
                  ],
                ),
              ),


    );
  }
}