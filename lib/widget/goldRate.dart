import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jemisyseshop/model/common.dart';

class GoldRateWedgit{
  Future<void> showGoldRate(BuildContext context, bool hideTitleMessage, GlobalKey _keyGoldRate) {
    hideGoldRate =true;
    bool _fromTop = true;
    double p = 100.0;
//    double topp=positionRed.dx;
//    double rightp=positionRed.dy;
    if (kIsWeb && hideTitleMessage)
      p = 45.0;
    else if (kIsWeb && !hideTitleMessage)
      p = 75.0;
    else if (!kIsWeb && hideTitleMessage)
      p = 70.0;
    final RenderBox renderBoxRed = _keyGoldRate.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    double topp = positionRed.dy+30;
//    double rightp = positionRed.dx;
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Padding(
//            padding: EdgeInsets.only(top: p, left:20.0, right:kIsWeb ? 50 : 50),
            padding: EdgeInsets.only(top: topp, left: 20.0, right: 50),
            child: Align(
                alignment: _fromTop ? Alignment.topRight : Alignment
                    .bottomCenter,
                child: Material(
                  type: MaterialType.transparency,
                  child: new Stack(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: SizedBox(width: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 10.0),
                              child: Column(
                                children: [
                                  Text('Gold Rate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0),
                                        child: Text('916 :'),
                                      ),
                                      Text('\$55.50'),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0),
                                        child: Text('999 :'),
                                      ),
                                      Text('\$65.50'),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
//              margin: EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 50),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(1000.0),
                              topRight: const Radius.circular(300.0),
                              bottomLeft: const Radius.circular(150.0),
                              bottomRight: const Radius.circular(1000.0),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                hideGoldRate = true;
                                Navigator.of(context).pop();
                              },
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close, color: Colors.white),
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