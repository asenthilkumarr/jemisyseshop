import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

class ContactUsPage extends StatefulWidget{
  @override
  _contactUsPage createState() => _contactUsPage();
}
class _contactUsPage extends State<ContactUsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Color currentColor = primary1Color;
  Color bgColor = Colors.white;
  void changemenuColor(Color color) => setState(() => currentColor = color);
  void changebgColor(Color color) => setState(() => bgColor = color);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Contact Us',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        key: scaffoldKey,
        drawer: MenuItemWedget2(scaffoldKey: scaffoldKey, isLogin: false, color: currentColor, bgcolor: bgColor,),
        appBar: AppBar(
          title: Text('Contact Us', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            iconSize: 25,

            onPressed: () {
              Navigator.pop(context);
//              scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
                children: [
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: currentColor,
                                onColorChanged: changemenuColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Change menu color'),
                    color: currentColor,
                    textColor: useWhiteForeground(currentColor)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: bgColor,
                                onColorChanged: changebgColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Change menu background color'),
                    color: bgColor,
                    textColor: useWhiteForeground(bgColor)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}