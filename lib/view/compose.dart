import 'dart:async';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/style.dart';
import 'package:flutter/services.dart';
import '../style.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';

class compose extends StatefulWidget {
  final String Sender;
  compose({this.Sender});

  @override
  _State1 createState() => _State1();
}

class _State1 extends State<compose> {
  String _selectedSubject = "Video Call";
  List<String> attachments = [];
  bool isHTML = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtMessage = TextEditingController();
  TextEditingController txttomail = TextEditingController();
  DataService dataService = DataService();
  Map<String, dynamic> formData;

  // ignore: non_constant_identifier_names, missing_return
  bool _SenderAdmin() {
    if (isAdmin == true) {
      return true;
    }
    else {
      return false;
    }
  }

  var txtSub = [
    'Video Call',
    'Home Try-On',
    'Feedback',
  ];

  Future<String> UpdateMsg() async {
    String res = "Faild";
      if (txtReceipent.text != null && txtReceipent.text != '' &&
        txtMessage.text != null && txtMessage.text != '') {
      Messages param = Messages();
      param.iD = 0;
      param.fromUID = gDeviceID;
      param.toUID = "";
      param.fromEmail = isAdmin==true?gEmailAdmin:userID;
      param.toEmail = txtReceipent.text;
      param.subject = _selectedSubject;
      param.message = txtMessage.text;
      param.messageType = _selectedSubject.substring(0, 1);
      param.mode = "I";
      var dt = await dataService.UpdateMessage(param);
       res = 'OK';
        txtMessage.clear();
        Navigator.pop(context, false);
       }
    return res;
  }

  final txtReceipent = TextEditingController(

  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (isAdmin == false) {
      txtReceipent.text = gEmailAdmin;
    }
    txtSubject.text = '';
    txtMessage.text = '';
  }

// ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          title: new Text('New Message',
              style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              }
          ),
          backgroundColor: primary1Color,

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20,15,20,15),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: TextField(

                      keyboardType:TextInputType.emailAddress,
                      readOnly: _SenderAdmin() == true ? false : true,
                      controller: txtReceipent,
                      decoration: InputDecoration(
                        //prefixIcon: ,
                        icon: Icon(Icons.arrow_drop_down_circle,size: 30,color: primary1Color),
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Recipient',
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "Subject",
                            labelText: "Subject",
                            icon: Icon(Icons.subject,size: 30,color: primary1Color),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius
                                  .circular(3),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          isEmpty: _selectedSubject == '',
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSubject,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _selectedSubject = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: txtSub.map((String value) {
                                  return DropdownMenuItem<String>(
                                    // child:Divider(color: Colors.black87),
                                    value: value,
                                    //Divider(color: Colors.black87),
                                    child: Text(value,
                                        style: GoogleFonts.lato(
                                          color: Colors.black,)
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ));
                    },
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: TextField(
                      controller: txtMessage,
                      maxLines: 8,
                      decoration: InputDecoration(
                          icon: Icon(Icons.message,size: 26,color: primary1Color),
                          labelText: 'Body', border: OutlineInputBorder()),
                    ),
                  ),
                ]),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.send,),
          label: Text('Send'),
          backgroundColor: primary1Color,
          onPressed: (){
            UpdateMsg();
          },
        ),
      ),
    );
  }
}



