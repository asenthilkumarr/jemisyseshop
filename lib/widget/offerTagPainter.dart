import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../style.dart';

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    // Create a rectangle with size and width same as the canvas
    //var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    paint.color = Color(0xFFF96013);
    // create a path
    var path = Path();
    path.lineTo(0, 80);
    path.lineTo(80, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
    paint.color = Colors.white;
    path = Path();
    path.lineTo(0, 25);
    path.lineTo(25, 0);
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

class ShapesPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    // Create a rectangle with size and width same as the canvas
    //var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    paint.color = listLabelbgColor;
    // create a path
    var path = Path();
    path.lineTo(0, 90);
    path.lineTo(90, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);
    paint.color = Colors.white;
    path = Path();
    path.lineTo(0, 25);
    path.lineTo(25, 0);
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