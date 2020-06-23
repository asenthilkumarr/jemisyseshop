import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';

class CartNotification{
  ItemScrollController _scrollControllerlist = ItemScrollController();
  Future<void> showCart(BuildContext context, List<Cart> dt, GlobalKey _keyCartNotification) async {
    double p = 100.0;

    if (dt.length > 0) {
      showGeneralDialog(
          barrierLabel: "Label",
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 700),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return Padding(
//            padding: EdgeInsets.only(top: p, left:20.0, right:kIsWeb ? 50 : 50),
              padding: EdgeInsets.only(top: 50, left: 20.0, right: 50),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    type: MaterialType.transparency,
                    child: new Stack(
                        children: <Widget>[
                          Container(
                            child: SizedBox(width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, top: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Cart', style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Container(
                                      width: double.maxFinite,
                                        child: CartListView(dt)),
                                  ],
                                ),
                              ),
                            ),
//              margin: EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(400.0),
                                topRight: const Radius.circular(100.0),
                                bottomLeft: const Radius.circular(150.0),
                                bottomRight: const Radius.circular(400.0),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                        Icons.close, color: Colors.white),
                                  ),
                                ),
                              )),
                        ]),
                  )
              ),
            );
          });
    }
  }
  Widget CartListitem(BuildContext context, Cart dt, int index, int totindex) {
    int nindex = index;

    if (dt.onlineName != null) {
      return Container(
        width: 110,
//        color: selectedColor,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {

                      },
                      child: _sizedContainer(
                        Image(
                          image: CachedNetworkImageProvider(
                            dt.imageFileName,
                          ),
                        ),
                      ),
                    )
                    //Image.network(dt.imageUrl, height: 80, width: 80,),
                    //Spacer(),
                  ],
                ),
                Spacer(),
                Container(
                  color: listLabelbgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${dt.onlineName}',
                        style: TextStyle(color: Colors.white),),
                      //Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return new Text('ERROR');
    }
  }
  Widget CartListView(List<Cart> data) {
    return new ScrollablePositionedList.builder(
      itemScrollController: _scrollControllerlist,
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) =>
          CartListitem(context, data[index], index, data.length),
    );
  }
  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: Center(child: child),
    );
  }

}