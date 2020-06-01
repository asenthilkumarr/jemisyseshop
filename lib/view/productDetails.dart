import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/widget/imageSlide.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
import 'package:share/share.dart';

import '../style.dart';

class ProductDetailPage extends StatefulWidget{
  final Product product;
  final String title;
  ProductDetailPage({this.product, this.title});
  @override
  _productDetailPage createState() => _productDetailPage();
}
class _productDetailPage extends State<ProductDetailPage> {
  DataService dataService = DataService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final txtQtyController = TextEditingController();
  bool favorite = false;
  Widget productDetailWidget(Product item) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    double imgHeight = 100;
    String diamondDetail = "";

    if(item.quantity==null);
    item.quantity = 1;

    if (item.labelLine1 != null && item.labelLine1 != "")
      diamondDetail = item.labelLine1;
    if (item.labelLine2 != null && item.labelLine2 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine2;
    }
    if (item.labelLine3 != null && item.labelLine3 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine3;
    }
    if (item.labelLine4 != null && item.labelLine4 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine4;
    }
    if (item.labelLine5 != null && item.labelLine5 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine5;
    }
    if (!kIsWeb) {
      if (screenSize.height > screenSize.width)
        imgHeight = (screenSize.height / 4) * 2.0;
      else
        imgHeight = (screenSize.width / 4) * 1.9;
    }
    else {
      if (screenSize.height > screenSize.width)
        imgHeight = (screenSize.height / 2)+70;
      else if(screenSize.width < 600)
        imgHeight = (screenSize.width / 4) * 2.1;
      else if(screenSize.width < 700)
        imgHeight = (screenSize.width / 4) * 1.9;
      else if(screenSize.width < 800)
        imgHeight = (screenSize.width / 4) * 1.9;
      else if(screenSize.width < 1000)
        imgHeight = (screenSize.width / 4) * 1.8;
      else
        imgHeight = (screenSize.width / 4) * 1.4;
      if(imgHeight > 400)
        imgHeight = 400;
    }

    List<String> timgList = [];
    if (item.imageFile1 != "")
      timgList.add(item.imageFile1);
    if (item.imageFile2 != "")
      timgList.add(item.imageFile2);
    if (item.imageFile3 != "")
      timgList.add(item.imageFile3);
    if (item.imageFile4 != "")
      timgList.add(item.imageFile4);
    if (item.imageFile5 != "")
      timgList.add(item.imageFile5);

//    return Card(
//        shape: RoundedRectangleBorder(
//          side: BorderSide(
//            color: listbgColor,
//            width: 1.0,
//          ),
//        ),
    return Container(
        margin: const EdgeInsets.only(left:8.0, top:4.0, right:8.0, bottom:10.0),
        padding: const EdgeInsets.all(0.0),
      color: Colors.white,
        child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    border: Border.all(color: listbgColor)
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 0.0, // gap between adjacent chips
                  runSpacing: 0.0, // gap between lines
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: imgHeight),
                        child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(0.0),
                              padding: const EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: listbgColor),
                                      right: BorderSide(color: listbgColor))
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: 100, maxHeight: imgHeight,
                                    maxWidth: imgHeight),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, top: 20.0, right: 5.0, bottom: 5),
                                  child: Align(
                                    alignment: FractionalOffset.centerLeft,
                                    child: FullscreenSliderIndicator(
                                      imgList: timgList,),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              top: 4,
                              child: Container(
                                //width: 50.0,
                                //height: 50.0,
                                padding: const EdgeInsets.all(0.0),
                                //I used some padding without fixed width and height
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  // You can use like this way or like the below line
                                  //borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.grey, //listLabelbgColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: listbgColor, //Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),

                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  //I used some padding without fixed width and height
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    // You can use like this way or like the below line
                                    //borderRadius: new BorderRadius.circular(30.0),
                                    color: Colors.white,
                                  ),
                                  child: SizedBox(width: 40,
                                      height: 40,
                                      child: IconButton(
                                        icon: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent,),
                                        onPressed: (){
                                          if(favorite)
                                            favorite = false;
                                          else
                                            favorite = true;
                                          print(favorite);
                                          setState(() {});
                                        },
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              bottom: 4,
                              child: Container(
                                //width: 50.0,
                                //height: 50.0,
                                padding: const EdgeInsets.all(0.0),
                                //I used some padding without fixed width and height
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  // You can use like this way or like the below line
                                  //borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.grey, //listLabelbgColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: listbgColor, //Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),

                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  //I used some padding without fixed width and height
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    // You can use like this way or like the below line
                                    //borderRadius: new BorderRadius.circular(30.0),
                                    color: Colors.white,
                                  ),
                                  child: SizedBox(width: 40,
                                      height: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.share, color: Colors.redAccent,),
                                        onPressed: (){
                                          final RenderBox box = context.findRenderObject();
                                          Share.share("Share this item",
                                              subject: "Share",
                                              sharePositionOrigin:
                                              box.localToGlobal(Offset.zero) &
                                              box.size);
                                        },
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:5),
                        Column(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "${item.description}",
                                      softWrap: true,),
                                    Text(" - ${item.itemCode}",
                                      softWrap: true, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Spacer(),
                            ])
                            ),
                            Row(
                              children: [
                                Spacer(),
                                item.discountPercentage>0 && item.listingPrice > 0 ?
                                Text("$currencysymbol${formatterint.format(item.listingPrice)} ",
                                    style: TextStyle(
                                        decoration: TextDecoration
                                            .lineThrough)) : Container(),
                                item.discountPercentage>0 && item.onlinePrice > 0 ?
                                Text("$currencysymbol${formatterint.format(item.onlinePrice)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)) : Text("$currencysymbol${formatterint.format(item.listingPrice)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                item.discountPercentage>0 && item.listingPrice > 0 ?
                                Text(
                                  " ${formatterint.format(item
                                      .discountPercentage)}% OFF",) : Container(),
                                Spacer(),
                              ],
                            ),

                          ],
                        ),
                        /*
                        //Quantity
                        Padding(
                          padding: const EdgeInsets.only(left:2.0, right:2.0, bottom:5.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                child: Row(
                                  children: [
                                    Text("Quantity : "),
                                    SizedBox(
                                      width: 24.0,
                                      height: 24.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          if(txtQtyController.text!= "" && int.parse(txtQtyController.text)>1){
                                            txtQtyController.text = (int.parse(txtQtyController.text) - 1).toString();
                                          }
                                        },
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          color: Colors.grey,
                                          child: Container(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.remove, color: Colors.white,
                                                  size: 20,),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height:24,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: txtQtyController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter.digitsOnly
                                        ],

                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(3.0),
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius
                                                .circular(5.0),
                                            borderSide: new BorderSide(
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24.0,
                                      height: 24.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          if(txtQtyController.text!= ""){
                                            txtQtyController.text = (int.parse(txtQtyController.text) + 1).toString();
                                          }
                                        },
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          color: Colors.grey,

                                          child: Container(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add, color: Colors.white,
                                                  size: 20,),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    RawMaterialButton(
                                      fillColor: primary1Color,
                                      splashColor: Colors.grey,
                                      textStyle: TextStyle(color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:8.0, right:8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[Icon(Icons.shopping_cart),Text('ADD TO CART')],
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                        */
                      ],
                    )),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: imgHeight),
                        child: Column(
                      children: [
                        SizedBox(height: 10),
                        Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:10.0,right:10),
                                child: Column(
//                                      mainAxisSize: MainAxisSize.max,
//                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("Product Description", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:20.0),
                                      child: Column(
                                        children: [
                                          Container(),
                                          item.description != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                  child: new Text("${item.description}",
                                                    softWrap: true,)),
                                            ],
                                          ) : Container(),
                                          item.shortDescription != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                  child: new Text("${item.shortDescription}",
                                                    softWrap: true,)),
                                            ],
                                          ) : Container(),
                                          item.goldWeight >0 ? Row(
                                            children: [
                                              SizedBox(
                                                  width: 100,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text("Weight : ")
                                                  )),
                                              Flexible(
                                                flex: 3,
                                                child: Text("${formatter2dec.format(item.goldWeight)}g"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.metalType != "" ? Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Metal Type : ")
                                                ),
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Text("${item.metalType}"),
                                              )

                                            ],
                                          ) : Container(),
                                          item.designCode != "" ? Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Design : ")),
                                              ),

                                              Flexible(
                                                flex: 3,
                                                child: Text("${item.designCode}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.designName != "" ? Row(
                                            children: [
                                              SizedBox(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Design : ", style: TextStyle(color: Colors.transparent),),
                                                  )
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Text("${item.designName}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.brand != "" ? Row(
                                            children: [
                                              SizedBox(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Brand : "),
                                                  )
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Text("${item.brand}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.labelLine1 != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text("${item.labelLine1}"),
                                              ),
                                            ],
                                          ) : Container(),
                                          item.labelLine2 != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text("${item.labelLine2}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.labelLine3 != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text("${item.labelLine3}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.labelLine4 != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text("${item.labelLine4}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.labelLine5 != "" ? Row(
                                            children: [
                                              Container(
                                                width: 6.0,
                                                height: 6.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(0, 0, 0, 0.9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text("${item.labelLine5}"),
                                              )
                                            ],
                                          ) : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height:5),

                                  ],
                                ),
                              )
                            ]
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              item.discountPercentage > 0 ? Positioned(
                left: 0.0,
                child: Container(
                  child: CustomPaint(
                    painter: ShapesPainter(),
//                      painter: DrawTriangle(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.rotate(angle: -pi / 4,
                            child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                      width: 40,
                                      child: Text("${formatterint.format(
                                          item.discountPercentage)}% OFF",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white),
                                      )

                                  ),
                                ])
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(height: 1, width: 1,),

            ]
        )
    );
  }
  Widget productDetailWidget2(Product item) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    double imgHeight = 100;
    String diamondDetail = "";

    if(item.quantity==null);
    item.quantity = 1;

    if (item.labelLine1 != null && item.labelLine1 != "")
      diamondDetail = item.labelLine1;
    if (item.labelLine2 != null && item.labelLine2 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine2;
    }
    if (item.labelLine3 != null && item.labelLine3 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine3;
    }
    if (item.labelLine4 != null && item.labelLine4 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine4;
    }
    if (item.labelLine5 != null && item.labelLine5 != "") {
      if (diamondDetail != "") diamondDetail = diamondDetail + ", ";
      diamondDetail = diamondDetail + item.labelLine5;
    }
    if (!kIsWeb) {
      if (screenSize.height > screenSize.width)
        imgHeight = (screenSize.height / 4) * 2.5;
      else
        imgHeight = (screenSize.width / 4) * 1.9;
    }
    else {
      if (screenSize.height > screenSize.width)
      imgHeight = (screenSize.height / 2);
      else
        imgHeight = (screenSize.height / 1.3);
    }

    List<String> timgList = [];
    if (item.imageFile1 != "")
      timgList.add(item.imageFile1);
    if (item.imageFile2 != "")
      timgList.add(item.imageFile2);
    if (item.imageFile3 != "")
      timgList.add(item.imageFile3);
    if (item.imageFile4 != "")
      timgList.add(item.imageFile4);
    if (item.imageFile5 != "")
      timgList.add(item.imageFile5);

//    return Card(
//        shape: RoundedRectangleBorder(
//          side: BorderSide(
//            color: listbgColor,
//            width: 1.0,
//          ),
//        ),
    return Container(
        margin: const EdgeInsets.only(left:8.0, top:4.0, right:8.0, bottom:10.0),
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
        child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    border: Border.all(color: listbgColor)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Container(
                          width: imgHeight,
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: listbgColor))
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: imgHeight, maxHeight: imgHeight,
                            minWidth: imgHeight),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 20.0, right: 5.0, bottom: 5),
                              child: Align(
                                alignment: FractionalOffset.centerLeft,
                                child: FullscreenSliderIndicator(
                                  imgList: timgList,),
                              ),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            SizedBox(height: 10),
                            Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0,right:10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              "${item.description} - ${item
                                                  .itemCode}",
                                              softWrap: true,)),
                                        Row(
                                          children: [
                                            Spacer(),
                                            item.discountPercentage>0 && item.listingPrice > 0 ?
                                            Text("$currencysymbol${formatterint.format(item.listingPrice)} ",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough)) : Container(),
                                            item.discountPercentage>0 && item.onlinePrice > 0 ?
                                            Text("$currencysymbol${formatterint.format(item.onlinePrice)}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold)) : Text("$currencysymbol${formatterint.format(item.listingPrice)}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                            item.discountPercentage>0 && item.listingPrice > 0 ?
                                            Text(
                                              " ${formatterint.format(item
                                                  .discountPercentage)}% OFF",) : Container(),
                                            Spacer(),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Product Description", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: Column(
                                            children: [
                                              Container(),
                                              item.description != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.description}"),
                                                ],
                                              ) : Container(),
                                              item.shortDescription != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.shortDescription}"),
                                                ],
                                              ) : Container(),
                                              item.goldWeight >0 ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Weight : "),
                                                  Text("${formatter2dec.format(item.goldWeight)}g"),
                                                ],
                                              ) : Container(),
                                              item.metalType != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.metalType}"),
                                                ],
                                              ) : Container(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Basic Information", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: Column(
                                            children: [
                                              Container(),
                                              item.designCode != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Design : "),
                                                  Text("${item.designCode}"),
                                                ],
                                              ) : Container(),
                                              item.designName != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),

                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Design : ", style: TextStyle(color: Colors.transparent),),
                                                  Text("${item.designName}"),
                                                ],
                                              ) : Container(),
                                              item.brand != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Brand : "),
                                                  Text("${item.brand}"),
                                                ],
                                              ) : Container(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Stone Details", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: Column(
                                            children: [
                                              Container(),
                                              item.labelLine1 != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.labelLine1}"),
                                                ],
                                              ) : Container(),
                                              item.labelLine2 != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.labelLine2}"),
                                                ],
                                              ) : Container(),
                                              item.labelLine3 != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.labelLine3}"),
                                                ],
                                              ) : Container(),
                                              item.labelLine4 != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.labelLine4}"),
                                                ],
                                              ) : Container(),
                                              item.labelLine5 != "" ? Row(
                                                children: [
                                                  Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0, horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(0, 0, 0, 0.9),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${item.labelLine5}"),
                                                ],
                                              ) : Container(),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  )
                                ]
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:10.0, right:10.0, bottom:5.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            child: Row(
                              children: [
                                Text("Quantity : "),
                                SizedBox(
                                  width: 40,
                                  height:25,
                                  child: TextFormField(
                                    initialValue: "1",
//                           controller: _controller,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],

                                    decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius
                                            .circular(5.0),
                                        borderSide: new BorderSide(
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Spacer(),
                                RaisedButton(
                                  onPressed: () {},
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF5f7682),
                                          Color(0xFF88a9bb),
                                          Color(0xFF5f7682),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(
                                        10.0),
                                    child: SizedBox(
                                      width: 160,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Icon(Icons.shopping_cart, color: Colors.white,
                                            size: 26,),
                                          Text(
                                              'ADD TO CART',
                                              style: TextStyle(fontSize: 17)),
                                          Spacer(),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              item.discountPercentage > 0 ? Positioned(
                left: 0.0,
                child: Container(
                  child: CustomPaint(
                    painter: ShapesPainter(),
//                      painter: DrawTriangle(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.rotate(angle: -pi / 4,
                            child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                direction: Axis.vertical,
                                children: [
                                  SizedBox(
                                      width: 40,
                                      child: Text("${formatterint.format(
                                          item.discountPercentage)}% OFF",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white),
                                      )

                                  ),
                                ])
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(height: 1, width: 1,),
/*
              Positioned(
                right: 5,
                top: 4,
                child: Container(
                  //width: 50.0,
                  //height: 50.0,
                  padding: const EdgeInsets.all(1.0),
                  //I used some padding without fixed width and height
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    // You can use like this way or like the below line
                    //borderRadius: new BorderRadius.circular(30.0),
                    color: listLabelbgColor, //Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: listbgColor, //Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),

                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    //I used some padding without fixed width and height
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      // You can use like this way or like the below line
                      //borderRadius: new BorderRadius.circular(30.0),
                      color: Colors.white,
                    ),
                    child: SizedBox(width: 45,
                        height: 45,
                        child: IconButton(
                         icon: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent,),
                         onPressed: (){
                           if(favorite)
                             favorite = false;
                           else
                             favorite = true;
                           print(favorite);
                           setState(() {});
                         },
                        )
                    ),
                  ),
                ),
              ),
              */
            ]
        )
    );
  }
  @override
  void initState() {
    super.initState();
    txtQtyController.text = "1";
  }
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
            key: scaffoldKey,
//      appBar: pageAppBar(),
            drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
//                  margin: const EdgeInsets.all(8.0),
//                  padding: const EdgeInsets.all(1.0),
//                  decoration: BoxDecoration(
//                      border: Border.all(color: Colors.blueAccent)
//                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Customtitle(context, widget.title),
                      productDetailWidget(widget.product),
                      SizedBox(height: 3,)
                    ],
                  ),
                ),
              ),

            ),
          bottomNavigationBar: BottomAppBar(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0, right: 15.0),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(

                            color: listLabelbgColor,
                            padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                            child: Text(
                    "Home Try On",
                    style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                            onPressed: () async {

                            },
                          ),
                        ),
                        SizedBox(width: 1),
                        Expanded(
                          child: RaisedButton(
                            color: listLabelbgColor,
                            padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "Buy Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () async {

                            },
                          ),
                        ),
                      ]
                  ),
                ),
              )
          ),

        )
    );
  }
}
