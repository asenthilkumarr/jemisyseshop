import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen3 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Home3(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Home3 extends StatefulWidget{
  @override
  _home3 createState() => _home3();
}
class _home3 extends State<Home3> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("ListView"),
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  HeaderWidget("Header 1"),
                  HeaderWidget("Header 2"),
                  HeaderWidget("Header 3"),
                  HeaderWidget("Header 4"),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  BodyWidget(Colors.blue),
                  BodyWidget(Colors.red),
                  BodyWidget(Colors.green),
                  BodyWidget(Colors.orange),
                  BodyWidget(Colors.blue),
                  BodyWidget(Colors.red),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              delegate: SliverChildListDelegate(
                [
                  BodyWidget(Colors.blue),
                  BodyWidget(Colors.green),
                  BodyWidget(Colors.yellow),
                  BodyWidget(Colors.orange),
                  BodyWidget(Colors.blue),
                  BodyWidget(Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(text),
      color: Colors.grey[200],
    );
  }
}

class BodyWidget extends StatelessWidget {
  final Color color;

  BodyWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: color,
      alignment: Alignment.center,

    );
  }
}