import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'compose.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class MessagePage extends StatefulWidget {
  @override
  _State createState() => new _State();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MessagePage(),
    );
  }
  static send(Type message) {}
}

//State is information of the application that can change over time or when some actions are taken.
class _State extends State<MessagePage> {
  int selectedIndex = 0;
  List<String> attachments = [];
  bool isHTML = false;
  List<GetMailContent> itemDt = [];
  bool _isOnTop = true;
  ByteData imgBytes = ByteData(0);
  String res2 = "Faild";

  final GlobalKey<State> _keyLoaderreply = new GlobalKey<State>();
  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtMessage = TextEditingController();
  TextEditingController txtMessage1 = TextEditingController();
  DataService dataService = DataService();
  PageController controller = PageController();
  get decoration => null;
  final fdatetime = new DateFormat('dd-MM-yyyy hh:mm aa');


  Future<List<GetMailContent>> _fetchData() async {
    GetMailContent param = GetMailContent();
    param.fromUID = gDeviceID; //dlog.storeCode;
    param.toEmail = userID;
    var dt = await obj.GetMessage(param);
    itemDt = dt;
    return dt;
  }

  final txtReceipent = TextEditingController(

  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    _scrollController2 = ScrollController();
    txtReceipent.text='';
    txtSubject.text='';
    txtMessage.text='';

    var padding = EdgeInsets.symmetric(horizontal: 12, vertical: 5);
    double gap = 30;
  }
  void dispose() {
    txtMessage.dispose();
    super.dispose();
  }

  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollController2 = new ScrollController();
  DataService obj = new DataService();
  _clearAll() async {
    setState(() {
      txtMessage.text="";
    });

  }


  _scrollToTop() {
    _scrollController2.animateTo(_scrollController2.position.minScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

  _navigatePage(BuildContext context) async {
    if (gProgramName == "SendEmail") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => compose(Sender:userID)),
      );
    }
  }

  ListView MessageList(List<GetMailContent> data) {
    return
      new ListView.builder(
        controller: _scrollController2,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            Doclist(data[index]),
      );
  }

  // ignore: non_constant_identifier_names
  Widget Doclist(GetMailContent Dt) {
    return new Card(
      elevation: 7,
      // margin: EdgeInsets.all(7.0),
      margin: EdgeInsets.fromLTRB(0.7, 5.0, 7.0, 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      color: Colors.deepOrangeAccent[50],
      child: new Container(
        //  decoration: new BoxDecoration(
        //    image: new DecorationImage(image: new NetworkImage("gNotificationImageURL/$Dt.GSS.png"),fit: BoxFit.cover,),
        //   ),
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          height: 290,
          //height: (MediaQuery.of(context).size.height-(AppBar().preferredSize.height)-30)/7,
          //width: double.maxFinite,
          child: Column(
            //  mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: ListTile(
                    //contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    //leading: _buildLeadingTile(),
                    leading:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 16, 0, 0),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Doclist1(Dt),
                          ) );
                      // gProgramName="PreviewDoc";
                      _navigatePage(context);
                    },
                    //title: Text('${Dt.storeCode} ${Dt.docNo}  ${Dt.docType } '),
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (Dt.imageFileName != null && Dt.imageFileName != '')?
                          ClipRect(
                              child: Image(image: new NetworkImage('$gNotificationImageURL'+Dt.imageFileName),
                                fit: BoxFit.contain,
                                height: 100,
                                width: 200,
                              )
                          ):Container(),
                          SizedBox(height: 20,),
                          Text(
                            'F: ${Dt.fromEmail} ', maxLines: 1,
                            style: GoogleFonts.lato(color: Colors.black,
                                fontSize: 16),
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'T: ${Dt.toEmail}', maxLines: 1,
                            style: GoogleFonts.lato(color: Colors.black,
                                fontSize: 16),
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '${Dt.subject} ', maxLines: 1,
                            style: GoogleFonts.lato(color: Colors.black,
                                fontSize: 14),
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                              '${Dt.message}', maxLines: 3,
                              style: TextStyle(fontStyle: FontStyle.italic,fontSize: 13,color: Colors.black)
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            Dt.createdDate,
                            style: TextStyle(color: Colors.black45,fontSize: 13),
                          ),
                        ]),
                    trailing:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.mail, size: 25,
                                color: Colors.redAccent,),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Doclist1(Dt),
                                    ) );
                                gMessageID=Dt.iD;
                                _navigatePage(context);
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                ]);
                              }),
                        ]),
                  ))],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenhight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      extendBody: true,
      appBar: new AppBar(
        title: new Text('Message',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            }
        ),
        backgroundColor: primary1Color,
      ),
      body:
      SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
            child: Container(
                height: screenhight - (AppBar().preferredSize.height) -
                    (AppBar().preferredSize.height) - 32,
                child: FutureBuilder<List<GetMailContent>>(
                  future: _fetchData(),
                  builder: (context, snapshot) {
                    if (itemDt.length > 0) {
                      List<GetMailContent> data = itemDt;
                      //return _jobsListView(data);
                      return MessageList(data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    //return Container();
                    return Text("No messages found!");
                  },
                )
            ),
          )
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              // width: 50.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.redAccent,
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Compose",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => compose(),
                      ) );
                },
              ),
            ),
            SizedBox(
              width: 165.0,
            ),
            SizedBox(
              //width: 65.0,
              child: FlatButton(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0,2.0,2.0,2.0),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.redAccent,
                        size: 24.0,
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        "Refresh",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _fetchData();
                  setState(() {
                  });
                  _scrollToTop();
                },
              ),
            ),
          ],
        ),
      ),
      //hit Ctrl+space in intellij to know what are the options you can use in flutter widget
    );
  }

  // ignore: non_constant_identifier_names
  Widget Doclist1(GetMailContent Dt) {
    var messageDate;
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.red),
        home: Scaffold(
            appBar: AppBar(
              title: new Text('Message',
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
              centerTitle: true,
              leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed:() {
                    Navigator.pop(context, false);
                  }
              ),
              backgroundColor: Colors.deepOrange,
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          (Dt.imageFileName != '' && Dt.imageFileName != null)? ClipRect(
                              child: Image(image: new NetworkImage('$gNotificationImageURL'+Dt.imageFileName),
                                fit: BoxFit.cover,
                              )
                          ):Container(),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child:
                            Text(
                              'From: ${Dt.fromEmail}       ', maxLines: 1,
                              style: GoogleFonts.lato(color: Colors.redAccent[200],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                              'Subject: ${Dt.subject}   ', maxLines: 1,
                              style: GoogleFonts.lato(color: Colors.black,
                                  fontSize: 16)
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          SizedBox(height: 14.0,),
                          Text(
                              'Message: \n${Dt.message}   ', maxLines: 8,
                              style: TextStyle(fontStyle: FontStyle.italic,fontSize: 13,color: Colors.black)
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          SizedBox(height: 30.0,),
                          Text(
                              'To:  ${Dt.toEmail}  ', maxLines: 1,
                              style: GoogleFonts.lato(color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                          SizedBox(height: 15.0,),
                          Text(
                              Dt.createdDate, maxLines: 1,
                              style: GoogleFonts.lato(color: Colors.black,
                                  fontSize: 14)
                            //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 14),
                          ),
                        ]
                    )
                )
            )
        )
    );
  }
}