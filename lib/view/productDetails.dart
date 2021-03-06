import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/view/cart.dart';
import 'package:jemisyseshop/view/login.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/widget/imageSlide.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import 'package:share/share.dart';
import '../style.dart';

class ProductDetailPage extends StatefulWidget{
  final Product product;
  final String title;
  final GlobalKey<FormState> masterScreenFormKey;
  final String source;

  ProductDetailPage({this.product, this.title, this.masterScreenFormKey, this.source});
  @override
  _productDetailPage createState() => _productDetailPage();
}
class _productDetailPage extends State<ProductDetailPage> {
  DataService dataService = DataService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final txtQtyController = TextEditingController();
  bool favorite = false;

  Widget productDetailWidget(Product item) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    double imgHeight = 100;
    String diamondDetail = "", title = "";

    if(item.quantity==null);
    item.quantity = 1;

    if(item.itemCode != null && item.itemCode != "") title = item.itemCode;
    else title = item.designCode;

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
                            //Design Code
                            Positioned(
                              left: 5,
                              bottom: 4,
                              child: Container(
                                child: Text(item.designCode, style: TextStyle(fontSize: 10, color: Color(0xFFD0CECE)),),
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
                                          else {
                                            favorite = true;
                                           // AddWishList(widget.product, "W");
                                          }
                                          setState(() {});
                                        },
                                      )
                                  ),
                                ),
                              ),
                            ),
                            !kIsWeb ? Positioned(
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
                                          Share.share(webURL+"designdetail?SKU="+title,
                                              subject: appTitle,
                                              sharePositionOrigin:
                                              box.localToGlobal(Offset.zero) &
                                              box.size);
                                        },
                                      )),
                                ),
                              ),
                            )
                            : Container(),
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
                                      "${item.onlineName}",
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
                                                  width: 120,
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
                                                width: 120,
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
                                          /*
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
                                          */
                                          item.designName != "" ? Row(
                                            children: [
                                              SizedBox(
                                                  width: 120,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Design Name : ", ),
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
                                                  width: 120,
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
                                          item.jewelSize != "" ? Row(
                                            children: [
                                              SizedBox(
                                                  width: 120,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Size : "),
                                                  )
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Text("${item.jewelSize}"),
                                              )
                                            ],
                                          ) : Container(),
                                          item.jewelLength != "" ? Row(
                                            children: [
                                              SizedBox(
                                                  width: 120,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text("Length : "),
                                                  )
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Text("${item.jewelLength}"),
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
            ]
        )
    );
  }
  void AddtoCart(Product sItem, String oType) async{
    if(isLogin == true){
      List<Cart> lparam = [];
      Cart param = new Cart();
      param.eMail = userID;
      param.recordNo = 0;
      param.designCode = sItem.designCode;
      param.version = sItem.version;
      param.itemCode = sItem.itemCode;
      param.onlineName = sItem.onlineName;
      param.description = sItem.description;
      param.qty = 1;
      param.jewelSize = sItem.jewelSize;
      param.unitPrice = sItem.onlinePrice;
      param.totalPrice = sItem.onlinePrice;
      param.imageFileName = sItem.imageFile1.replaceAll(imageUrl, "");
      param.shippingDays = 7;
      param.isSizeCanChange = true;
      param.orderType = oType;
      lparam.add(param);

      Dialogs.showLoadingDialog(context, _keyLoader);//invoking go
      var dt = await dataService.updateCart("I", lparam);
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CartPage(pSource: oType, masterScreenFormKey: widget.masterScreenFormKey,)),);

    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()),);
    }
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
        title: 'Product Details',
        theme: MasterScreen.themeData(context),
        home: Scaffold(
            key: scaffoldKey,
          appBar: AppBar(
            title: Row(
              children: [
                Text(widget.title, style: TextStyle(color: Colors.white),),
              ],
            ),
            leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
              onPressed:() => Navigator.pop(context, false),
            ),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.home,color: Colors.white,),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
//            ],
            backgroundColor: Color(0xFFFF8752),
            centerTitle: true,
          ),
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Customtitle(context, widget.title),
                      Center(child: productDetailWidget(widget.product)),
                      SizedBox(height: 3,)
                    ],
                  ),
                ),
              ),

            ),
          bottomNavigationBar: BottomAppBar(

              child: Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left:1.0, right: 1.0),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.product.homeTryOn == true && widget.source == null ? Expanded(
                          child: SizedBox(
                            height:50,
                            child: RaisedButton(

                              color: Color(0xFF509583),
                              padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                              child: Text(
                                "Home Try-On",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                AddtoCart(widget.product, "H");
                              },
                            ),
                          ),
                        ) :
                        Container(),
                        widget.product.homeTryOn == true ? SizedBox(width: 1) :
                        Container(),
                        Expanded(
                          child: SizedBox(
                            height:50,
                            child: RaisedButton(
                              color: Color(0xFF517295),
                              padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  widget.source == null ? "Buy Now" : "Close",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15, fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if(widget.source == null)
                                AddtoCart(widget.product, "S");
                                else
                                  Navigator.pop(context);
                              },
                            ),
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

class ProductDetailPage2 extends StatefulWidget{
  static const String route = '/designdetail';
  // final Product product;
  // final String title;
  // final GlobalKey<FormState> masterScreenFormKey;
  // final String source;
  // ProductDetailPage2({this.product, this.title, this.masterScreenFormKey, this.source});
  @override
  _productDetailPage2 createState() => _productDetailPage2();
}
class _productDetailPage2 extends State<ProductDetailPage2> {
  DataService dataService = DataService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final txtQtyController = TextEditingController();
  bool favorite = false;
  Product dt = new Product();
  String title="", source = null;

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
                                //Design Code
                                Positioned(
                                  left: 5,
                                  bottom: 4,
                                  child: Container(
                                    child: Text(item.designCode, style: TextStyle(fontSize: 10, color: Color(0xFFD0CECE)),),
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
                                              else {
                                                favorite = true;
                                                // AddWishList(widget.product, "W");
                                              }
                                              setState(() {});
                                            },
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                !kIsWeb ? Positioned(
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
                                              Share.share(webURL+"designdetail?SKU="+title,
                                                  subject: appTitle,
                                                  sharePositionOrigin:
                                                  box.localToGlobal(Offset.zero) &
                                                  box.size);
                                            },
                                          )),
                                    ),
                                  ),
                                )
                                    : Container(),
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
                                            "${item.onlineName}",
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
                                                      width: 120,
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
                                                    width: 120,
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
                                              /*
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
                                          */
                                              item.designName != "" ? Row(
                                                children: [
                                                  SizedBox(
                                                      width: 120,
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text("Design Name : ", ),
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
                                                      width: 120,
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
                                              item.jewelSize != "" ? Row(
                                                children: [
                                                  SizedBox(
                                                      width: 120,
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text("Size : "),
                                                      )
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Text("${item.jewelSize}"),
                                                  )
                                                ],
                                              ) : Container(),
                                              item.jewelLength != "" ? Row(
                                                children: [
                                                  SizedBox(
                                                      width: 120,
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text("Length : "),
                                                      )
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Text("${item.jewelLength}"),
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
  void AddtoCart(Product sItem, String oType) async{
    if(isLogin == true){
      List<Cart> lparam = [];
      Cart param = new Cart();
      param.eMail = userID;
      param.recordNo = 0;
      param.designCode = sItem.designCode;
      param.version = sItem.version;
      param.itemCode = sItem.itemCode;
      param.onlineName = sItem.onlineName;
      param.description = sItem.description;
      param.qty = 1;
      param.jewelSize = sItem.jewelSize;
      param.unitPrice = sItem.onlinePrice;
      param.totalPrice = sItem.onlinePrice;
      param.imageFileName = sItem.imageFile1.replaceAll(imageUrl, "");
      param.shippingDays = 7;
      param.isSizeCanChange = true;
      param.orderType = oType;
      lparam.add(param);

      Dialogs.showLoadingDialog(context, _keyLoader);//invoking go
      var dt = await dataService.updateCart("I", lparam);
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CartPage(pSource: oType, masterScreenFormKey: null,)),);

    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()),);
    }
  }
  Future<Product> getProductDetail(String productType, String designCode) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.designCode = designCode;
    param.version = 1;
//    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    var tdt = await dataService.getProductDetails(param);
    dt = new Product();
    if(tdt.length>0){
      dt = tdt[0];
    }
    setState(() {
    });
    return dt;
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
    final routename=ModalRoute.of(context).settings.name;
    var rname = routename.split("?");
    if(rname.length>1)
      title = (routename.split("?")[1]).split("=")[1];

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Text(title, style: TextStyle(color: Colors.white),),
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
          onPressed:() => Navigator.pop(context, false),
        ),
        backgroundColor: Color(0xFFFF8752),
        centerTitle: true,
      ),
      drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
      body: Builder(
          builder: (context){
            getProductDetail("FROMCART", title);
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Customtitle(context, widget.title),
                      dt != null ? Center(child: productDetailWidget(dt))
                          : Container(),
                      SizedBox(height: 3,)
                    ],
                  ),
                ),
              ),
            );
          }
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left:1.0, right: 1.0),
              child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    dt.homeTryOn == true && source == null ? Expanded(
                      child: SizedBox(
                        height:50,
                        child: RaisedButton(

                          color: Color(0xFF509583),
                          padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                          child: Text(
                            "Home Try-On",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            AddtoCart(dt, "H");
                          },
                        ),
                      ),
                    ) :
                    Container(),
                    dt.homeTryOn == true ? SizedBox(width: 1) :
                    Container(),
                    Expanded(
                      child: SizedBox(
                        height:50,
                        child: RaisedButton(
                          color: Color(0xFF517295),
                          padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              source == null ? "Buy Now" : "Close",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15, fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if(source == null)
                              AddtoCart(dt, "S");
                            else
                              Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          )
      ),

    );
    // );
  }
}
