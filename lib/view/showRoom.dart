
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';

class ShowRoomPage extends StatefulWidget{
  @override
  _showRoomPage createState() => _showRoomPage();
}
class _showRoomPage extends State<ShowRoomPage> {
  DataService dataService = DataService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Store> list = new List<Store>();
  Future<List<Cart>> getDefaultData() async {
    list = new List<Store>();
    list = await dataService.getStores();

    setState(() {

    });
  }
  Widget storeDetail(Store dt, int index) {
    var formatter = new DateFormat.jm();;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 15.0),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dt.description,
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5,),
                      dt.address1 != "" ? Text(dt.address1,) : Container(),
                      dt.address1 != "" ? SizedBox(height: 5,) : Container(),
                      dt.address2 != "" ? Text(dt.address2,) : Container(),
                      dt.address2 != "" ? SizedBox(height: 5,) : Container(),
                      dt.address3 != "" ? Text(dt.address3,) : Container(),
                      dt.address3 != "" ? SizedBox(height: 5,) : Container(),
                      dt.address4 != "" ? Text(dt.address4,) : Container(),
                      dt.address4 != "" ? SizedBox(height: 5,) : Container(),
                      Row(
                        children: [
                          dt.state!="" ? Text("${dt.state} - ",) : Container(),
                          Text(dt.pinCode,),
                        ],
                      ),
                      dt.telePhone != "" ? SizedBox(height: 5,) : Container(),
                      dt.telePhone != "" ? Row(
                        children: [
                          Text("Tel : ",),
                          Text(dt.telePhone,),
                        ],
                      ) : Container(),
                      dt.openingTime != null ? SizedBox(height: 5,) : Container(),
                      dt.openingTime != null ? Row(
                        children: [
                          Text("Operation hours : ",),
                          Text(formatter.format(dt.openingTime)),
                          dt.closingTime != null ? Text(" - ${formatter.format(dt.closingTime)}") : Container(),
                        ],
                      ) : Container(),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState(){
    super.initState();
    getDefaultData();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Showroom',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        key: scaffoldKey,
//        drawer: MenuItemWedget3(scaffoldKey: scaffoldKey, isLogin: false),
        appBar: AppBar(
          title: Text('Showroom', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
              //scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              for(var i = 0; i < list.length; i++)
                storeDetail(list[i], i),
            ],
          ),
        ),
      ),
    );
  }
}