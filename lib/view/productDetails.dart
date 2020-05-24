import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/menu.dart';
import 'package:jemisyseshop/widget/imageSlide.dart';
import 'package:jemisyseshop/widget/offerTagPainter.dart';
import 'package:jemisyseshop/widget/titleBar.dart';

import '../style.dart';

class ProductDetailPage extends StatefulWidget{
  final String designCode;
  final int version;
  ProductDetailPage({this.designCode, this.version});
  @override
  _productDetailPage createState() => _productDetailPage();
}
class _productDetailPage extends State<ProductDetailPage> {
  DataService dataService = DataService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _keyGoldRate = GlobalKey();
  ScrollController _scrollController = new ScrollController();
  List<Product> productdt = List<Product>();
  final formatter2dec = new NumberFormat('##0.00', 'en_US');
  final formatterint = new NumberFormat('##0', 'en_US');
  String _where;

  Future<List<Product>> getProductDetail() async {
    ProductParam param = new ProductParam();
    param.designCode = widget.designCode;
    param.version = widget.version;
    param.where = _where;
    var dt = await dataService.GetProductDetails(param);
    productdt = dt;
    setState(() {

    });
    return dt;
  }

  double GridItemHeight(double screenHeight, double screenWidth) {
    double itemHeight = 0.55;
    itemHeight = 1;
    if(!kIsWeb){
      if(screenHeight>screenWidth)
        itemHeight = 0.6;
      else
        itemHeight = 0.60;
    }
    else{
      if(screenHeight>screenWidth)
        itemHeight = 0.85;
      else{
        if(screenWidth<800)
          itemHeight = 0.65;
        if(screenWidth<950)
          itemHeight = 0.75;
        if(screenWidth<1050)
          itemHeight = 0.60;
        else
          itemHeight = 0.45;
      }
    }

    return itemHeight;
  }
  int GridItemCount(double screenwidth) {
    int itemCount = 0;
    if(!kIsWeb){
      if (screenwidth <= 550)
        itemCount = 1;
      else if (screenwidth <= 750)
        itemCount = 2;
    }
    else{
      if (screenwidth <= 550)
        itemCount = 1;
      else if (screenwidth <= 950)
        itemCount = 2;
      else if (screenwidth <= 1100)
        itemCount = 3;
      else if (screenwidth <= 1250)
        itemCount = 4;
      else if (screenwidth <= 1400)
        itemCount = 5;
      else
        itemCount = 7;
    }

    return itemCount;
  }
  Widget productListWidget(Product item) {
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
        imgHeight = (screenSize.width / 4) * 1.7;
    }
    else {
      imgHeight = (screenSize.height / 2);
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

    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: listbgColor,
            width: 1.0,
          ),
        ),
        child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Wrap(
               direction: Axis.horizontal,
               children: [
                 Container(
                   //width: 50.0,
                   //height: 50.0,
                   padding: const EdgeInsets.all(1.0),
                   //I used some padding without fSixed width and height
                   decoration: new BoxDecoration(
                     shape: BoxShape.rectangle,
                     // You can use like this way or like the below line
                     //borderRadius: new BorderRadius.circular(30.0),
                     color: listLabelbgColor, //Colors.grey,
                     boxShadow: [
                       BoxShadow(
                         color: listbgColor, //Colors.grey.withOpacity(0.5),
                         spreadRadius: 1,
                         blurRadius: 2,
                         offset: Offset(0, 1), // changes position of shadow
                       ),
                     ],
                   ),

                   child: Container(
                     padding: const EdgeInsets.all(1.0),
                     //I used some padding without fixed width and height
                     decoration: new BoxDecoration(
                       shape: BoxShape.rectangle,
                       // You can use like this way or like the below line
                       //borderRadius: new BorderRadius.circular(30.0),
                       color: Colors.white,
                     ),
                     child: ConstrainedBox(
                       constraints: BoxConstraints(
                           minHeight: 100, maxHeight: imgHeight),
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
                 ),

                 Column(
                   children: [
                     SizedBox(height: 10),
                     Wrap(
                         children: [
                           Column(
                             mainAxisSize: MainAxisSize.max,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               Align(
                                   alignment: Alignment.topCenter,
                                   child: Text(
                                     "${item.description} - ${item
                                         .itemCode}",
                                     softWrap: true,)),
                               item.listingPrice > 0 ? Row(
                                 children: [
                                   Spacer(),
                                   item.listingPrice > 0 &&
                                       item.discountPercentage > 0
                                       ?
                                   Text(item.listingPrice > 0
                                       ? '$currencysymbol${formatterint
                                       .format(
                                       item.listingPrice)}'
                                       : '',
                                       style: TextStyle(
                                           decoration: TextDecoration
                                               .lineThrough))
                                       : Container(),
                                   item.listingPrice > 0 &&
                                       item.discountPercentage > 0
                                       ?
                                   Text(item.onlinePrice > 0
                                       ? ' $currencysymbol${formatterint
                                       .format(item.onlinePrice)}'
                                       : '',
                                       style: TextStyle(
                                           fontWeight: FontWeight.bold))
                                       : Text(item.onlinePrice > 0
                                       ? ' $currencysymbol${formatterint
                                       .format(
                                       item.onlinePrice)}'
                                       : '', style: TextStyle(
                                       fontWeight: FontWeight
                                           .normal)),
                                   item.discountPercentage != 0
                                       ? Text(
                                     " ${formatterint.format(item
                                         .discountPercentage)}% OFF",)
                                       : Text(''),
                                   Spacer(),
                                 ],
                               ) : Container(),
                               item.goldWeight > 0 ? Row(
                                 children: [
                                   Spacer(),
                                   item.goldWeight > 0 ?
                                   Text("Weight : ${item.goldWeight}g",)
                                       : Text(''),
                                   Spacer(),
                                 ],
                               ) : Container(),
                               SizedBox(
                                 height: 20,
                               ),
                               item.shortDescription != "" ? Row(
                                 children: [
                                   Flexible(
                                     flex: 1,
                                     child: Align(
                                         alignment: Alignment
                                             .centerRight,
                                         child: Text(
                                             "Description : ")),
                                   ),
                                   Flexible(
                                     flex: 2,
                                     child: Align(
                                         alignment: Alignment
                                             .centerLeft,
                                         child: Text(item
                                             .shortDescription)),
                                   )
                                 ],
                               ) : Container(),
                               Row(
                                 children: [
                                   Flexible(
                                     flex: 1,
                                     child: Align(
                                         alignment: Alignment
                                             .centerRight,
                                         child: Text("Design : ")),
                                   ),
                                   Flexible(
                                     flex: 2,
                                     child: Align(
                                         alignment: Alignment
                                             .centerLeft,
                                         child: Text(
                                             item.designCode)),
                                   )
                                 ],
                               ),
                               item.designName != "" ? Row(
                                 children: [
                                   Flexible(
                                     flex: 1,
                                     child: Align(
                                         alignment: Alignment
                                             .centerRight,
                                         child: Text("")),
                                   ),
                                   Flexible(
                                     flex: 2,
                                     child: Align(
                                         alignment: Alignment
                                             .centerLeft,
                                         child: Text(
                                             item.designName)),
                                   )
                                 ],
                               ) : Container(),
                               item.brand != "" ? Row(
                                 children: [
                                   Flexible(
                                     flex: 1,
                                     child: Align(
                                         alignment: Alignment
                                             .centerRight,
                                         child: Text("Brand : ")),
                                   ),
                                   Flexible(
                                     flex: 2,
                                     child: Align(
                                         alignment: Alignment
                                             .centerLeft,
                                         child: Text(item.brand)),
                                   )
                                 ],
                               ) : Container(),
                               diamondDetail != "" ? Row(
                                 children: [
                                   Flexible(
                                     flex: 1,
                                     child: Align(
                                         alignment: Alignment
                                             .centerRight,
                                         child: Text(
                                             "Diamond Details : ")),
                                   ),
                                   Flexible(
                                     flex: 2,
                                     child: Align(
                                         alignment: Alignment
                                             .centerLeft,
                                         child: Text(
                                             diamondDetail)),
                                   )
                                 ],
                               ) : Container(),

                             ],
                           )
                         ]
                     ),
                   ],
                 )
               ],
             ),
             Spacer(),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Align(
                 alignment: Alignment.bottomCenter,
                 child: Container(
                   child: Row(
                     children: [
                       Column(
                         children: [
                           Text("Quantity"),
                           Center(
                             child: Container(
                               width: 60.0,
                               foregroundDecoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(5.0),
                                 border: Border.all(
                                   color: Colors.blueGrey,
                                   width: 2.0,
                                 ),
                               ),
                               child: Row(
                                 children: <Widget>[
                                   Expanded(
                                     flex: 1,
                                     child: TextFormField(
                                       textAlign: TextAlign.center,
                                       decoration: InputDecoration(
                                         contentPadding: EdgeInsets.all(8.0),
                                         border: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(5.0),
                                         ),
                                       ),
initialValue: item.quantity == null ? "1" : item.quantity.toString(),
                                       keyboardType: TextInputType.numberWithOptions(
                                         decimal: false,
                                         signed: true,
                                       ),
                                       inputFormatters: <TextInputFormatter>[
                                         WhitelistingTextInputFormatter.digitsOnly
                                       ],
                                     ),
                                   ),
                                   Container(
                                     height: 38.0,
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: <Widget>[
                                         Container(
                                           decoration: BoxDecoration(
                                             border: Border(
                                               bottom: BorderSide(
                                                 width: 0.5,
                                               ),
                                             ),
                                           ),
                                           child: InkWell(
                                             child: Icon(
                                               Icons.arrow_drop_up,
                                               size: 18.0,
                                             ),
                                             onTap: () {
                                               int currentValue = item.quantity;
                                               setState(() {
                                                 currentValue++;
                                                 item.quantity = currentValue;
                                                 int i=0;
                                                 for(var drow in productdt){
                                                   if(item.designCode == drow.designCode &&
                                                   item.version == drow.version &&
                                                   item.itemCode == drow.itemCode){
                                                     productdt[i].quantity = currentValue;
                                                     print(productdt[i].quantity);
                                                     i++;
                                                     break;
                                                   }
                                                 }
                                               });
                                             },
                                           ),
                                         ),
                                         InkWell(
                                           child: Icon(
                                             Icons.arrow_drop_down,
                                             size: 18.0,
                                           ),
                                           onTap: () {
                                             int currentValue = item.quantity;
                                             setState(() {
                                               print("Setting state");
                                               currentValue--;
                                               item.quantity = currentValue;
                                               int i=0;
                                               for(var drow in productdt){
                                                 if(item.designCode == drow.designCode &&
                                                     item.version == drow.version &&
                                                     item.itemCode == drow.itemCode){
                                                   productdt[i].quantity = currentValue;
                                                   i++;
                                                   break;
                                                 }
                                               }
                                             });
                                           },
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ],
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
                                 Color(0xFF7a98a8),
                                 Color(0xFF88a9bb),
                               ],
                             ),
                           ),
                           padding: const EdgeInsets.all(
                               10.0),
                           child: Container(
                             width: 200,
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Spacer(),
                                 Icon(Icons.shopping_cart, color: Colors.white,
                                   size: 26,),
                                 Text(
                                     'ADD TO CART',
                                     style: TextStyle(fontSize: 20)),
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
                        child: Icon(
                          Icons.favorite_border, color: Colors.redAccent,)),
                  ),
                ),
              ),
            ]
        )
    );
  }
  Widget productListWidget2(Product item) {
    List<String> timgList = [];
    if(item.imageFile1 != "")
      timgList.add(item.imageFile1);
    if(item.imageFile2 != "")
      timgList.add(item.imageFile2);
    if(item.imageFile3 != "")
      timgList.add(item.imageFile3);
    if(item.imageFile4 != "")
      timgList.add(item.imageFile4);
    if(item.imageFile5 != "")
      timgList.add(item.imageFile5);

    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: listbgColor,
            width: 1.0,
          ),
        ),
        child: Flexible(
            flex: 1,
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: listbgColor,
                    width: 1.0,
                  ),
                ),
                child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, top: 20.0, right: 5.0, bottom: 5),
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: FullscreenSliderIndicator(imgList: timgList,),
                                ),
                              ),
                            ),
                            Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: Container(
                                  color: listbgColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(child: Text(item.description)),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text(item.itemCode),
                                            Spacer(),
                                            item.listingPrice > 0 &&
                                                item.discountPercentage > 0 ?
                                            Text('$currencysymbol${formatterint.format(
                                                item.onlinePrice)}', style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                                : Text(item.listingPrice > 0
                                                ? '$currencysymbol${formatterint.format(
                                                item.listingPrice)}'
                                                : 'Wt.: ${formatter2dec.format(
                                                item.weightTo)}g'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => ProductDetailPage(designCode: item.designCode, version: item.version),)
//                  );
                        },
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
                                                    fontSize: 12, color: Colors.white),
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
            )
        )
    );

  }

  Widget homeWidget(int itemCount, double screenHeight, double screenWidth) {
    double itemHeight = GridItemHeight(screenHeight, screenWidth);
    double imgHeight = 100;
    if(!kIsWeb) imgHeight = (itemHeight / 4) * 1;
    else imgHeight = (itemHeight / 4) * 2;
    return Flexible(
        child: Container(
            child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: itemCount,
                      childAspectRatio: itemHeight,
                    ),
                    delegate: SliverChildListDelegate(
                      [
                        for(var i in productdt)
                          productListWidget(i),
                      ],
                    ),
                  ),



                ]
            )
        )
    );
  }

  @override
  void initState(){
    super.initState();
    getProductDetail();

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    int itemCount = GridItemCount(screenSize.width);
    double itemheight = GridItemHeight(screenSize.height, screenSize.width);

    return MaterialApp(
        title: 'Product Details',
        home: Scaffold(
            key: scaffoldKey,
//      appBar: pageAppBar(),
            drawer: MenuItemWedget(scaffoldKey: scaffoldKey, isLogin: isLogin),
            body: SafeArea(
                child: Container(
                    color: Colors.white,
                    child: Column(
                        children: [
                          Customtitle(context, widget.designCode),
//                          titleBar2(context, scaffoldKey, _keyGoldRate),
                          homeWidget(itemCount, screenSize.height, screenSize.width),
                        ]
                    )
                )
            )
        )
    );
  }
}