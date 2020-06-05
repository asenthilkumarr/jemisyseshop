import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/view/productDetails.dart';
import 'package:jemisyseshop/view/productList.dart';

import '../style.dart';
import 'offerTagPainter.dart';

class ProductGridWidget extends StatelessWidget {
  final Product item;
  ProductGridWidget({this.item});
  Future<void> _product_onTap(Product selItem, BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: item, title: item.itemCode,),)
    );
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
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFe2e8ec),
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
//                                      SizedBox(height: 5,),
                                      Text("${item.itemCode}", style: TextStyle(fontSize: 12, color: Colors.grey)),
//                                      SizedBox(height: 5,),
                                      item.goldWeight > 0 ? Text("Weight : ${formatter2dec.format(item.goldWeight)}g") : Container(),
//                                      SizedBox(height: 5,),
                                      item.listingPrice > 0 && item.discountPercentage > 0 && item.onlinePrice>0 ?
                                      Text('$currencysymbol${formatterint.format(
                                          item.onlinePrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                          : item.listingPrice > 0 ? Text("$currencysymbol${formatterint.format(
                                          item.listingPrice)}") : Container(),
                                      item.listingPrice > 0 && item.discountPercentage > 0 && item.onlinePrice==0 ?
                                      Text('$currencysymbol${formatterint.format(
                                          item.listingPrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                          : Container(),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      onTap: (){
                        _product_onTap(item, context);
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
//  @override
//  State<StatefulWidget> createState() {
//    return _productGridWidget();
//  }
}

class ProductGridWidgetHome extends StatelessWidget {
  final Product item;
  final String productType;
  ProductGridWidgetHome({this.item, this.productType});
  String _where="ALL";
  DataService dataService = DataService();

  Future<void> _product_onTap(String productType, Product selItem, BuildContext context) async {
    var productdetail = await getProductDetail(productType, selItem.designCode, selItem.version);
    if (productdetail.length > 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListPage(productdt: productdetail, title: selItem.designCode,),)
      );
    }
    else if (productdetail.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ProductDetailPage(product: productdetail[0],
                title: productdetail[0].designCode,),)
      );
    }
//    else {
//      Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) =>
//              ProductDetailPage(product: item,
//                title: item.designCode,),)
//      );
//    }
  }
  Future<List<Product>> getProductDetail(String productType, String designCode, int version) async {
    ProductParam param = new ProductParam();
    param.productType = productType;
    param.designCode = designCode;
    param.version = version;
    param.where = _where;
    var dt = await dataService.GetProductDetails(param);
    return dt;
  }

  @override
  Widget build(BuildContext context) {
//    print("list price ${item.listingPrice}");
//    print("onlinePrice ${item.onlinePrice}");
//    print("discountPercentage ${item.discountPercentage}");
//    print("goldWeight ${item.goldWeight}");

    return Scaffold(
      body: Builder(
        builder: (context) {
          final screenSize = MediaQuery
              .of(context)
              .size;
          return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: listbgColor,
                  width: 1.0,
                ),
                  borderRadius: BorderRadius.circular(4.0)
              ),
              child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        _product_onTap(productType, item, context);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0,top:10.0, right:20.0, bottom:5),
                                  child: Align(
                                    alignment: FractionalOffset.center,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                        item.imageFile1,
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
//                  child: Image.network(
//                    item.imageUrl, fit: BoxFit.fitHeight,),
                                  ),
                                ),
                                Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom:1.0, right: 2.0),
                                    child: Text(item.designCode, style: TextStyle(fontSize: 10, color: Color(0xFFD0CECE)),),
                                  ),
                                ),
                              ]
                            ),
                          ),
                          Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
//                    height: 100,
                                color: listbgColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Text(item.onlineName, style: TextStyle(color: Color(0xFF444444)),
                                              maxLines: 1, overflow: TextOverflow.ellipsis,
                                              softWrap: false,),
                                          ),
//                                          Spacer(),

//                                          item.listingPrice > 0 && item.discountPercentage != 0 ?
//                                          Text(item.listingPrice > 0 ? '$currencysymbol${formatterint.format(
//                                              item.listingPrice)}' : '${formatter2dec.format(
//                                              item.weightFrom)}g',
//                                              style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12, color: Colors.grey))
//                                              : Text(item.weightFrom > 0 ? '${formatter2dec.format(
//                                              item.weightFrom)} -' : ''),
                                        ],
                                      ),
                                      SizedBox(height: 6,),
                                      Row(
                                        children: [

                                          item.listingPrice > 0 && item.discountPercentage != 0 ?
                                          Text(item.listingPrice > 0 ? '$currencysymbol${formatterint.format(
                                              item.listingPrice)}' : '${formatter2dec.format(
                                              item.weightFrom)}g',
                                              style: TextStyle(decoration: TextDecoration.lineThrough,color: Color(0xFF6F6C6C)))
                                              : Container(),

                                          item.listingPrice > 0 && item.discountPercentage > 0 ?
                                            Spacer()
                                              : item.listingPrice > 0 ? Spacer() : Container(),
                                          //Spacer(),

                                          item.listingPrice > 0 && item.discountPercentage > 0 ?
                                          Text('$currencysymbol${formatterint.format(
                                              item.onlinePrice)}', style: TextStyle(fontWeight: FontWeight.bold))
                                              : Text(item.listingPrice > 0 ? '$currencysymbol${formatterint.format(
                                              item.listingPrice)}' : 'Wt.: ${formatter2dec.format(item.weightFrom)}-${formatter2dec.format(item.weightTo)}g'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
//  @override
//  State<StatefulWidget> createState() {
//    return _productGridWidgetHome();
//  }
}
