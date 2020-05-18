import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/model/tempData.dart';
import 'package:jemisyseshop/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen3 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home 2',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Home3(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Home3 extends StatefulWidget{
  @override
  _home3 createState() => _home3();
}

class _home3 extends State<Home3> {
  bool isLogin = false;
  String _selcategoryCode = '';
  String _selCategory = "";
  String _selCountry = 'SG';

  final formatter2dec = new NumberFormat('##0.00', 'en_US');
  final formatterint = new NumberFormat('##0', 'en_US');
  AnimationController controller;
  Animation<double> animation;

  List<DesignCode> selDesign = new List<DesignCode>();
  Country sCountry;

  void getDefault() {
    var sitem = country.firstWhere((d) => d.shortCode == _selCountry);
    sCountry = sitem;
  }

  void _showPopupMenu() async {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, kIsWeb ? 55 : 80, 50, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('CURRENCY'), value: 'CURRENCY'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                Image.asset(
                  sCountry.imageUrl, height: 20, fit: BoxFit.fitHeight,),
                SizedBox(width: 10,),
                Text(sCountry.currency)
              ],
            ))
      ],
      elevation: 8.0,
    );
  }

  void getDesign() {
    var sitem = design.where((d) => d.categoryCode == _selcategoryCode)
        .toList();
    selDesign = new List<DesignCode>();
    selDesign = sitem;
  }

  int GridItemCount(double screenwidth) {
    int itemCount = 0,
        a = 0;
    if (screenwidth <= 550)
      itemCount = 2;
    else if (screenwidth <= 650)
      itemCount = 3;
    else if (screenwidth <= 750)
      itemCount = 4;
    else if (screenwidth <= 950)
      itemCount = 5;
    else if (screenwidth <= 1100)
      itemCount = 6;
    else if (screenwidth <= 1250)
      itemCount = 7;
    else if (screenwidth <= 1400)
      itemCount = 8;
    else
      itemCount = 10;

    return itemCount;
  }

  double GridItemHeight(double screenHeight, double screenWidth) {
    double itemHeight = 0.55;
    if (screenHeight > 880)
      itemHeight = 0.90;
    else if (screenHeight > 780)
      itemHeight = 0.75;
    else if (screenHeight > 580)
      itemHeight = 0.75;
    else if (screenHeight > 270 && screenWidth > 350)
      itemHeight = 0.70;
    itemHeight = 1;
    return itemHeight;
  }

  Widget BannerImage(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
//    print(screenWidth);
    double _height = 100;
    if (screenWidth > 1600)
      _height = 650;
    else if (screenWidth >= 1300)
      _height = 500;
    else if (screenWidth >= 1000)
      _height = 400;
    else if (screenWidth >= 700)
      _height = 300;
    else if (screenWidth >= 500)
      _height = 200;
    else if (screenWidth >= 400)
      _height = 120;
    if (images.length > 1) {
      return new Container(
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              height: _height
          ),
          itemBuilder: (context, index) {
            return Container(
              child: SizedBox(
                  child: Image.network(images[index], fit: BoxFit.fitWidth,
                    width: screenWidth - 30,)
              ),
            );
          },
        ),
      );
    }
    else {
      return new Container(
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              height: _height
          ),
          itemBuilder: (context, index) {
            return Container(
              child: SizedBox(
                  child: Image.network(images[index], fit: BoxFit.fitWidth,
                    width: screenWidth - 30,)
              ),
            );
          },
        ),
      );
    }
  }

  Widget DesignGridWidgets(DesignCode item) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xFFEFEBEB),
            width: 1.0,
          ),
        ),
        child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Image.network(
                    item.imageUrl, fit: BoxFit.fitHeight,),
                ),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    //color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 0.0, bottom: 3.0),
                      child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(item.designCode),
                          Spacer(),
                          Text(item.tagPrice > 0 ? '\$${formatterint.format(
                              item.tagPrice)}' : 'Wt.: ${formatter2dec.format(
                              item.grossWeight)}g'),
                        ],
                      ),
                    ),
                  )
              ),
            ]
        )
    );
  }

  Widget DesignGridWidgets2(DesignCode item) {
//    print(item.description);
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: new Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Container(
                child: Image.network(
                  item.imageUrl, width: 500, fit: BoxFit.fill,),
              ),
            ),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(item.designCode),
                      Spacer(),
                      Text(item.tagPrice > 0 ? '\$${formatterint.format(
                          item.tagPrice)}' : 'Wt.: ${formatter2dec.format(
                          item.grossWeight)} g'),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget pageAppBar() {
    return AppBar(
      //title: Text("eShop"),

        elevation: 0.0,
        backgroundColor: primary1Color,
        centerTitle: true,
        actions: <Widget>[
//          Visibility(
//              visible: isLogin ? true : false,
//              child:
//          ),
          Visibility(
            visible: !isLogin ? true : false,
            child: IconButton(
              icon: new Image.asset(
                  isLogin ? 'assets/user_profile.png' : 'assets/login.png'),
              iconSize: 20,

              onPressed: () {
                if (isLogin)
                  isLogin = false;
                else
                  isLogin = true;
                setState(() {

                });
              },
            ),
          ),
          IconButton(
            icon: new Image.asset(sCountry.imageUrl),
            iconSize: 20,
            onPressed: () {
              _showPopupMenu();
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Stack(
                  children: <Widget>[
                    //new IconButton(icon: Icon(Icons.shopping_cart, size: 35, color: Colors.white,),
                    IconButton(
                      icon: new Image.asset('assets/shopping_cart.png'),
                      iconSize: 20,
                      onPressed: () {},),
                    new Positioned( // draw a red marble
                      top: 2.0,
                      right: 10.0,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new Text(
                            '5',
                            style: new TextStyle(
                              color: Colors.red,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ]
              ),
            ),
          ),
        ]
    );
  }

  Widget CategoryListitem(BuildContext context, Category dt) {
    if (dt.categoryCode != null) {
      return Container(
        width: 110,
        //color: Colors.grey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selcategoryCode = dt.categoryCode;
                        _selCategory = dt.description;
                        getDesign();
                        setState(() {});
                      },
                      child: Container(
                        child: ClipRRect(
//                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(dt.imageUrl,
                            width: 80, fit: BoxFit.fitHeight,),
                        ),),
                    )
                    //Image.network(dt.imageUrl, height: 80, width: 80,),
                    //Spacer(),
                  ],
                ),
                Spacer(),
                Container(
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${dt.description}',
                        style: TextStyle(color: Colors.white),),
                      //Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return new Text('ERROR');
    }
  }

  Widget CategoryListView(List<Category> data) {
    return
      new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            CategoryListitem(context, data[index]),
      );
  }

  Widget CompanyLogo() {
    return new Container(
      color: primary1Color,
      child: SizedBox(
        height: 40,
        child: new Image.network(
          'http://42.61.99.57/JEMiSyseShopImage/Banner3.png',
          //"http://42.61.99.57/JEMiSyseShopImage/logo.png",
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
//    DefaultCacheManager manager = new DefaultCacheManager();
//    manager.emptyCache(); //clears all data in cache.
//    imageCache.clear();
    getDefault();
    if (categoryList.length > 0) {
      _selcategoryCode = categoryList[0].categoryCode;
      _selCategory = categoryList[0].description;
      getDesign();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      images.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    int itemCount = GridItemCount(screenSize.width);
    double itemheight = GridItemHeight(screenSize.height, screenSize.width);

    return Scaffold(
      key: scaffoldKey,
      appBar: pageAppBar(),
      drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
      body: SafeArea(
          child: Container(
              color: Colors.white,
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: CompanyLogo(),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 5,),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: BannerImage(context),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          //PageTitleBar(context),
                          SizedBox(
                            height: 5,
                          ),
                          //Menu
                          SizedBox(
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0),
                              child: Container(
                                //margin: const EdgeInsets.all(15.0),
                                //padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFFD8D8D8))
                                ),
                                //child: HorizontalMenu(menuitem, context),
                                child: HorizontalMenuWedget2(),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0),
                            child: Container(
                                height: 120,
                                color: Color(0xFFE5E7E9),
                                child: FutureBuilder<List<ItemMasterList>>(
                                  //future: _fetchData(),
                                  builder: (context, snapshot) {
                                    if (categoryList.length > 0) {
                                      List<Category> data = categoryList;
                                      return CategoryListView(data);
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }
                                    return Container();
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Space
                    SliverToBoxAdapter(
                      child: SizedBox(height: 3,),
                    ),
                    //Design Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(
                                  0xFFD8D8D8)),
                              color: Color(0xFFD8D8D8)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 5.0, 0.0, 5.0),
                            child: Text(_selCategory,),
                          ),
                        ),
                      ),
                    ),
                    //Design List
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemCount,
                        childAspectRatio: itemheight-0.05,
                      ),
                      delegate: SliverChildListDelegate(
                        [
                          for(var i in selDesign)
                            DesignGridWidgets(i),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5.0),
                            child: Container(
                                height: 120,
                                color: Color(0xFFE5E7E9),
                                child: FutureBuilder<List<ItemMasterList>>(
                                  //future: _fetchData(),
                                  builder: (context, snapshot) {
                                    if (categoryList.length > 0) {
                                      List<Category> data = categoryList;
                                      return CategoryListView(data);
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }
                                    return Container();
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          )
      ),
    );
  }
}

