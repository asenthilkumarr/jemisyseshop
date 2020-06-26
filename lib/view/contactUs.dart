import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class ContactUsPage extends StatefulWidget{
  @override
  _contactUsPage createState() => _contactUsPage();
}
class _contactUsPage extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Contact Us',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact Us', style: TextStyle(color: Colors.white),),
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, null),
          ),
          backgroundColor: title1Color,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
                children: [
//                  Customtitle(context, "Contact Us"),
                ]
            ),
          ),
        ),
      ),
    );
  }
}