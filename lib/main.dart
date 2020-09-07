import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/route/route_config.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'data/dataService.dart';
import 'model/dataObject.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  DataService dataService = DataService();
  List<Setting> sDT = List<Setting>();
  var dt = await dataService.getSetting();
  if(dt.length>0){
    appTitle = dt[0].appName;
    currencysymbol = dt[0].currSymbol;
    currencyCode = dt[0].currCode;
    titMessage = dt[0].message;
    fontName = dt[0].fontName;
    isBackendJEMiSys = dt[0].isBackendJEMiSys;
    isERPandEShopOnSameServer = dt[0].isERPandEShopOnSameServer;
    paymentGateway = dt[0].paymentGateway;
    aboutusUrl = dt[0].aboutusUrl;
    homeScreen = dt[0].mainScreen;
  }
  if(kIsWeb){
    runApp(MaterialApp(
      initialRoute: homeScreen == 1 ? MasterPage.route : Home.route,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,));
  }
  else{
    runApp(MaterialApp(
      home: SplashScreen(),
    ));
  }
//  runApp(MasterScreen(currentIndex: 0, key: null,));
//  runApp(HomeScreen());
  //runApp(MyApp());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SplashScreen extends StatefulWidget{
  static const String route = '/SplashScreen';
  @override
  splashScreen createState() => splashScreen();
}
class splashScreen extends State<SplashScreen>{
  DataService dataService = DataService();
  List<Setting> sDT = List<Setting>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  route() async{
    if (_keyLoader.currentWidget != null) {
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
    }
    if(homeScreen == 1){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MasterScreen(currentIndex: 0, key: null,),
      ));
    }
    else if(homeScreen == 2){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MasterPage2(currentIndex: 0, key: null,)
      ));
    }
  }
  route2() async{
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => Home(),
    ));
  }
  Future<List<Setting>> getSetting() async {
    var dt = await dataService.getSetting();
    sDT = dt;
    if(dt.length>0){
      appTitle = dt[0].appName;
      currencysymbol = dt[0].currSymbol;
      currencyCode = dt[0].currCode;
      titMessage = dt[0].message;
      fontName = dt[0].fontName;
      isBackendJEMiSys = dt[0].isBackendJEMiSys;
      isERPandEShopOnSameServer = dt[0].isERPandEShopOnSameServer;
      paymentGateway = dt[0].paymentGateway;
      aboutusUrl = dt[0].aboutusUrl;
      homeScreen = dt[0].mainScreen;
    }
    if(!kIsWeb){
      udid = await FlutterUdid.udid;
    }
    setState(() {
    });
    return dt;
  }

  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 2),route2,
    );

    //Future.delayed(Duration.zero, () => Dialogs.showLoadingOnlyDialog(context, _keyLoader));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      //initialRoute: homeScreen == 1 ? MasterPage.route : MasterPage2.route,
      home: Scaffold(
          body: Builder(
              builder: (context)
              {
                getSetting();
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    sDT.length > 0 && sDT[0].startupImageName != "" ? Container(
                      constraints: BoxConstraints(minWidth: 350, maxWidth: 750),
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        image: DecorationImage(
                          image: NetworkImage(sDT[0].startupImageName),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ) : Container(
                    ),
                  ],
                );
              }
          )
      ),
    );
    //return
  }
}

class Home extends StatelessWidget{
  static const String route = '/';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MasterScreen.themeData(context),
      initialRoute: homeScreen == 1 ? MasterPage.route : Home.route,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
      // home: Home2(),
    );
  }
}

class Home2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}
