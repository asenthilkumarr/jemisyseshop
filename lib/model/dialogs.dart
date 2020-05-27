import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/style.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.black),)
                      ]),
                    )
                  ]));
        });
  }

  static Future<void> showLoadingOnlyDialog(BuildContext context, GlobalKey _key) {
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return new WillPopScope(
              onWillPop: () async => false,
          child: GestureDetector(
          onTap: () {
          Navigator.of(context).pop();
          },
          child: Padding(
            key: _key,
            padding: EdgeInsets.only(top: 50, left: 20.0, right: 50),
            child: Align(
                alignment: Alignment.center,
                child: Material(
                  type: MaterialType.transparency,
                  child: new Stack(
                      children: <Widget>[
                        Container(
                          height: 50,
                          child: SizedBox(width: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent),
                              )
                            ),
                          ),
//              margin: EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 50),
                          decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.only(
//                              topLeft: const Radius.circular(1000.0),
//                              topRight: const Radius.circular(300.0),
//                              bottomLeft: const Radius.circular(150.0),
//                              bottomRight: const Radius.circular(1000.0),
//                            ),
                          ),
                        ),
                      ]),
                )
            ),
          ))
          );
        });
  }

  static Future<void> AlertMessage(BuildContext context, String msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> asyncConfirmDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset settings?'),
          content: const Text(
              'This will reset your device to its default factory settings.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  static Future<String> asyncInputDialog2(BuildContext context, String iTitle) async {
    final _text = TextEditingController();
    bool _validate = false;
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {

        return AlertDialog(
          title: Text(iTitle,
            //style: TextStyle(color: Colors.white, backgroundColor: title1Color,),
          ),
          content: new Theme(
            data: new ThemeData(
              primaryColor: primary1Color,
              accentColor: accent1Color,
            ),
            child: Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      controller: _text,
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: 'Enter the Value', hintText: 'Enter',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      ),
//                    onChanged: (value) {
//                      teamName = value;
//                    },
                    )
                )
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 100.0,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(7.0, 0.0, 10.0, 0.0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.redAccent),
                    ),
                    color: primary1Color,
                    padding: EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Ok",
                          style: TextStyle(
                              color: Colors.white, fontSize: 13
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _text.text.isEmpty ? _validate = true : _validate = false;
                      teamName = _text.text;
                      if(_validate){
                        Dialogs.AlertMessage(context, 'Input cannot be blank, please check.');
                      }
                      else {
                        Navigator.of(context).pop(teamName);
                      }
                    },
                  )
              ),
            ),
            SizedBox(
              width: 100.0,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(7.0, 0.0, 10.0, 0.0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.redAccent),
                    ),
                    color: primary1Color,
                    padding: EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white, fontSize: 13
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop('Cancel');
                    },
                  )
              ),
            ),

          ],
        );
      },
    );
  }

  static Future<String> asyncInputDialog(
      BuildContext context, String iTitle) async {
    final _text = TextEditingController();
    bool _validate = false;
    String inputvalue = '';
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.transparent,
              children: <Widget>[
                Center(
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(left: 0.0,right: 0.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              top: 18.0,
                            ),
                            margin: EdgeInsets.only(top: 13.0,right: 8.0),
                            decoration: BoxDecoration(
                                color: primary1Color,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 0.0,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ]),
                            child: new Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 0.0,
                                ),
                                Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: new Text(iTitle,
                                          style:TextStyle(fontSize: 24.0,color: Colors.white)),
                                    )//
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  //padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                    decoration: BoxDecoration(
                                      color:Colors.white,
                                    ),
                                    child: new Theme(
                                      data: new ThemeData(
                                        primaryColor: primary1Color,
                                        accentColor: accent1Color,
                                      ),
                                      child: TextField(
                                        controller: _text,
                                        autofocus: true,
                                        decoration: new InputDecoration(
                                          labelText: 'Enter the Value', hintText: 'Enter',
                                          errorText: _validate ? 'Value Can\'t Be Empty' : null,

                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Container(
                                          child: SizedBox(
                                              width: 100,
                                              child: RaisedButton(
                                                shape: new RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius.circular(10.0),
                                                  side: BorderSide(color: Colors.redAccent),
                                                ),
                                                color: primary1Color,
                                                padding: EdgeInsets.all(3.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 13
                                                        //fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  _text.text.isEmpty ? _validate = true : _validate = false;
                                                  inputvalue = _text.text;
                                                  if(_validate){
                                                    Dialogs.AlertMessage(context, 'Input cannot be blank, please check.');
                                                  }
                                                  else {
                                                    Navigator.of(context).pop(inputvalue);
                                                  }
                                                },
                                              )
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                      ],
                                    )
                                ),
                                InkWell(
                                  child: Container(),

                                )
                              ],
                            ),

                          ),
                          Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop('Cancel');
                                //Navigator.of(context).pop();
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          );
        }
    );
  }
}