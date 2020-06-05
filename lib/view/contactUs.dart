import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: 'Product Details', theme:
    ThemeData(
      textTheme: GoogleFonts.latoTextTheme(
        Theme
            .of(context)
            .textTheme,
      ),
    ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
                children: [
                  Customtitle(context, "Contact Us"),
                ]
            ),
          ),
        ),
      ),
    );
  }
}