import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/view/productDetails.dart';

import '../style.dart';
import 'offerTagPainter.dart';

class ProductGridWidget extends StatefulWidget {
  final Product item;
  ProductGridWidget({this.item});

  @override
  State<StatefulWidget> createState() {
    return _productGridWidget();
  }
}
class _productGridWidget extends State<ProductGridWidget> {
  Product item=new Product();
  Future<void> _product_onTap(Product selItem) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: item, title: item.itemCode,),)
    );
  }
  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final screenSize = MediaQuery
              .of(context)
              .size;
          return Container(
              decoration: BoxDecoration(
                //color: const Color(0xff7c94b6),
                border: Border.all(
                  color: listbgColor,
                  width: 1,
                ),
                //borderRadius: BorderRadius.circular(12),
              ),
              //return Card(
//              shape: RoundedRectangleBorder(
//                side: BorderSide(
//                  color: listbgColor,
//                  width: 0.0,
//                ),
//              ),

              child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:20.0,top:10.0, right:20.0, bottom:5),
                              child: Align(
                                alignment: FractionalOffset.center,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                    item.imageFile1,
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
//                    height: 100,
//                                color: listbgColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Wrap(
                                          runAlignment: WrapAlignment.center,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Text(
                                              "${item.description}",
                                              softWrap: true,),
                                          ]
                                      ),
                                      Text("${item.itemCode}"),
                                      SizedBox(height: 5,),
                                      item.goldWeight > 0 ? Text("Gold Weight : ${item.goldWeight}g") : Container(),
                                      SizedBox(height: 5,),
                                      item.listingPrice > 0 && item.discountPercentage > 0 ?
                                      Text('$currencysymbol${formatterint.format(
                                          item.onlinePrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                          : item.listingPrice > 0 ? Text("$currencysymbol${formatterint.format(
                                          item.listingPrice)}") : Container(),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      onTap: (){
                        _product_onTap(item);
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
                                            child: Text("${formatterint.format(item.discountPercentage)}% OFF",
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
          );
          //return ;
        },
      ),
    );
  }
}