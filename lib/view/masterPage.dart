
import 'package:flutter/cupertino.dart';
import 'package:jemisyseshop/view/TopSellingProducts.dart';
import 'package:jemisyseshop/view/category.dart';
import 'package:jemisyseshop/view/home.dart';

class MasterPage extends StatefulWidget{
  final int currentIndex;
  MasterPage({Key key, this.currentIndex}) : super(key: key);

  @override
  _masterPage createState() => _masterPage();
}

class _masterPage extends State<MasterPage> {
  int _currentIndex = 0;
  String _Title = 'Shopping Store';
  List<String> allDestinations=[];
  List<String> choices = [];

  Widget callPage(int currentIndex){
    switch(currentIndex){
      case 0: return HomeScreen();
      case 1: return new CategoryScreen();
      case 3: return TopSellingScreen();
      break;
      default: return Home();
    }
  }

//  @override
//  void initState() {
//    super.initState();
//    allDestinations = ButtomActionBarMenu.SetButtomActoinBarItem();
//    choices = ButtomActionBarMenu.SetMenuItem();
//    _currentIndex = widget.currentIndex;
//    pageTitle();
//  }
//  pageTitle(){
//    if(_currentIndex == 1 )_Title = 'Category';
//    else if(_currentIndex == 3 )_Title = 'Login';
//    else _Title = 'Shopping Store';
//  }
  @override
  Widget build(BuildContext context) {

  }
//    const IconThemeData selectedIconTheme = IconThemeData(
//        size: 26, color: primary1Color);
//    const IconThemeData unselectedIconTheme = IconThemeData(
//        size: 23, color: Colors.grey);
//
//    return MaterialApp(
//        home: Scaffold(
//          appBar: AppBar(
//            title: Text(_Title),
//            backgroundColor: pagetitle1Color,
//            centerTitle: true,
//            actions: <Widget>[
////              IconButton(
////                icon: Icon(Icons.receipt),
////                onPressed: () {},
////              ),
//              PopupMenuButton<MenuItem>(
//                onSelected: (choice) async {
//                  if (choice.title == "Store") {
////
//                  } else if (choice.title == "Image Slider") {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => ImageSliderWidget()),
//                    );
//                  } else if (choice.title == "Contact Us") {}
//                  else {
//                    var a = await Dialogs.asyncInputDialog2(context, 'TEST');
//                    print(a);
//                  }
//                },
//                itemBuilder: (BuildContext context) {
//                  return choices.map((MenuItem choice) {
//                    return PopupMenuItem<MenuItem>(
//                      value: choice,
//                      child: Text(choice.title),
//                    );
//                  }).toList();
//                },
//                icon: Icon(Icons.menu),
//              ),
//            ],
//          ),
//
//          body: callPage(_currentIndex),
//          bottomNavigationBar: BottomNavigationBar(
//            type: BottomNavigationBarType.fixed,
//            currentIndex: _currentIndex,
//            selectedIconTheme: selectedIconTheme,
//            unselectedIconTheme: unselectedIconTheme,
//            selectedItemColor: primary1Color,
//            onTap: (int index) {
//              _currentIndex = index;
//              pageTitle();
//
//              setState(() {
//              });
//            },
//            items: allDestinations.map((MenuItem destination) {
//              return BottomNavigationBarItem(
//                  icon: Icon(destination.icon,),
//                  //backgroundColor: Colors.white,
//                  title: Text(destination.title,)
//              );
//            }).toList(),
//          ),
//        )
//
//    );
//  }
}