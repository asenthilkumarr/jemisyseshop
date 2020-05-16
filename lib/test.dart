import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemisyseshop/style.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.deepOrangeAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Shapes'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 200, width: 200,

            child: CustomPaint(
              painter: ShapesPainter(),
              child: Container(
                height: 700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    paint.color = Colors.red;
    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
    paint.color = Colors.yellow;
    // create a path
    var path = Path();
    path.lineTo(0, 200);
    path.lineTo(200, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
    // set the color property of the paint
    paint.color = Colors.deepOrange;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);
    // draw the circle with center having radius 75.0
//    canvas.drawCircle(center, 75.0, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
Widget DesignGridWidgets() {
  return Card(
    color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: listbgColor,
          width: 1.0,
        ),
      ),
      child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: FractionalOffset.topCenter,
                child: Image.network(
                    '', fit: BoxFit.fitHeight
                  ),
                ),

            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  //color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 0.0, bottom: 3.0),
                    child: Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('designCode'),
                        Spacer(),
                        Text('3400.00'),
                      ],
                    ),
                  ),
                )
            ),
            Positioned(
                left: 10.0,
                child: SizedBox(
                  height: 100,
                  child: CustomPaint(
                    painter: ShapesPainter(),
                    child: Center(
                        child: Transform.rotate(angle: - pi / 4,
                          child: Text("50%\nOFF", style: TextStyle(fontSize: 22),),),
                    ),
                  )
                )),
          ]
      )
  );
}