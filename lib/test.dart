import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';

class Test extends StatefulWidget{

  @override
  _test createState() => _test();
}
class _test extends State<Test>{
  final _keyLoader = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Address", style: TextStyle(color: title1Color),),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: title1Color,),
            onPressed: () {
              Navigator.pop(context, false);
            }
        ),
        backgroundColor: primary1Color,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
          MaterialButton(
            child: Text("Click"),
            onPressed:(){
              Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
            },
          )
          ],
        ),
      ),
    );
  }
}