import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:jemisyseshop/view/address.dart';
import 'package:jemisyseshop/view/masterPage.dart';

class Appointment extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  final List<Cart> itemList;

  Appointment({this.itemCount, this.totalAmount, this.itemList});
  @override
  State<StatefulWidget> createState() => _appointment();
}
class _appointment extends State<Appointment> {
  DataService dataService = DataService();
  Commonfn cfobj = Commonfn();
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();
  TimeOfDay tselectedTime = TimeOfDay.now();
  final _keyLoader = new GlobalKey<FormState>();

  List<Address> dAddress = [];
  Address selectedAddress;

  bool buttonVisable = true;

  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
  final DateFormat formatterTime = DateFormat.jm();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate == null ? DateTime.now() : selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primary1Color,
            accentColor: primary1Color,
            colorScheme: ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: primary1Color,
//                                      surface: Colors.pink,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.deepOrange[100],
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: tselectedTime == null ? TimeOfDay(hour: 9, minute: 0) : tselectedTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primary1Color,
            accentColor: primary1Color,
            colorScheme: ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: primary1Color,
//                                      surface: Colors.pink,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.deepOrange[100],
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        tselectedTime = picked;
        selectedTime = DateTime(2020, 1, 1, tselectedTime.hour, tselectedTime.minute);
      });
  }

  void getDeliveryAddress() async {
    dAddress = await dataService.getDeliveryAddress(userID);
    if (dAddress.length > 0) {
      selectedAddress = dAddress[0];
    }

    setState(() {

    });
  }

  void AddnewAddress(String mode, Address data) {
    if (mode == "S") {
      dAddress.add(data);
      if (dAddress.length > 0)
        selectedAddress = data; //dAddress[0];
    }
    setState(() {

    });
  }
  void UpdateOrder() async{
    Paymentfn objcf = new Paymentfn();
    OrderData param = new OrderData();
    FocusScope.of(context).requestFocus(FocusNode());
    param.eMail = userID;
    param.totalAmount = widget.totalAmount;
    param.discount = 0;
    param.netAmount = widget.totalAmount;
    param.shippingAddress = selectedAddress;
    param.billingAddress = new Address();
    param.dstoreCode = null;
    param.deliveryMode = "H";//Shipping
    param.payMode1 = null;
    param.payMode1_Amt = 0;
    param.payMode1_Ref = null;
    param.payMode2 = null;
    param.payMode2_Amt = 0;
    param.payMode2_Ref = null;
    param.payMode3 = null;
    param.payMode3_Amt = 0;
    param.payMode3_Ref = null;
    param.mode = "I";
    objcf.updateOrder(param, widget.itemList, null, context, _keyLoader);
  }
  Future<bool> CheckNull() async {
    bool isNull = false;
    if(selectedAddress == null){
      isNull = true;
      await Dialogs.AlertMessage(
          context, "Shipping address cannot be blank, please check");
    }
    if(isNull){
      buttonVisable = true;
      setState(() {

      });
    }
    return isNull;
  }
  void loadDefault() async{
    getDeliveryAddress();
  }
  @override
  void initState(){
    super.initState();
    tselectedTime = TimeOfDay(hour: 9, minute: 0);
    selectedDate = DateTime.now().add(Duration(days: 1));
    selectedTime = DateTime(2020, 1, 1, tselectedTime.hour, tselectedTime.minute);
    loadDefault();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    screenWidth = screenSize.width;
    if(kIsWeb){
      screenWidth =  cfobj.ScreenWidth(screenSize.width);
    }

    return MaterialApp(
      title: 'Appointment',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Appointment", style: TextStyle(color: Colors.white),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context, false);
              }
          ),
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(-0.4, -0.8),
                        stops: [0.0, 0.5, 0.5, 1],
                        colors: [
                          Color(0xfffff7f3), //red
                          Color(0xffffffff), //red
                          Color(0xffffffff), //orange
                          Color(0xffffffff), //orange
                        ],
                        tileMode: TileMode.repeated
                    ),

                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        color: webLeftContainerColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: 250, maxWidth: screenWidth),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                          child: Column(
//                            mainAxisSize: MainAxisSize.max,
//                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Preferred Date"),
                                  SizedBox(width: 10,),
                                  SizedBox(
                                      width: 100,
                                      child: Text(
                                          formatterDate.format(selectedDate))),
                                  SizedBox(width: 10.0,),
                                  SizedBox(
                                    width: 40,
                                    child: Material(
                                      color: buttonColor,
                                      child: InkWell(child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.date_range,
                                          color: Colors.white,),
                                      ),
                                        onTap: () => _selectDate(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Text("Preferred Time"),
                                  SizedBox(width: 10,),
                                  SizedBox(
                                      width: 100,
                                      child: Text(
                                          formatterTime.format(selectedTime))),
                                  SizedBox(width: 10.0,),
                                  SizedBox(
                                    width: 40,
                                    child: Material(
                                      color: buttonColor,
                                      child: InkWell(child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.timer, color: Colors.white,),
                                      ),
                                        onTap: () => _selectTime(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10, 0, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0,
                                          color: listLabelbgColor
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: listbgColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.2),
                                              topRight: Radius.circular(10.2)
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 5.0, bottom: 5.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Address",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ),
                                      dAddress.length > 0 ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, right: 0.0),
                                          child: Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    width: 1,
                                                    color: listLabelbgColor,
                                                  ),
                                                )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: DropdownButton<Address>(
                                                isExpanded: true,
                                                value: selectedAddress,
                                                onChanged: (Address newValue) {
                                                  selectedAddress = newValue;
                                                  setState(() {});
                                                },
                                                underline: Container(),
                                                items: dAddress.map((
                                                    Address taddress) {
                                                  return new DropdownMenuItem<
                                                      Address>(
                                                    value: taddress,
                                                    child: new Text("${taddress
                                                        .title} ${taddress
                                                        .fullName} ${taddress
                                                        .address1}",
                                                      style: new TextStyle(
                                                        color: Colors.black,),
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                          : Container(),

                                      dAddress.length > 0 ? Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                        width: 1,
                                                        color: listLabelbgColor,
                                                      ),
                                                      bottom: BorderSide(
                                                        width: 1,
                                                        color: listLabelbgColor,
                                                      )
                                                  )
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    12.0, 8.0, 8.0, 8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        selectedAddress.title != "" ? Text( "${selectedAddress.title}",
                                                          style: TextStyle(fontWeight: FontWeight.bold),)
                                                            : Container(),
                                                        selectedAddress.title != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                        selectedAddress.fullName != "" ? Text("${selectedAddress.fullName}",
                                                          style: TextStyle(fontWeight: FontWeight.bold),)
                                                            : Container(),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        selectedAddress.address1 != "" ? Text("${selectedAddress.address1}")
                                                            : Container(),
                                                        selectedAddress.address1 != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                        selectedAddress.address2 != "" ? Text("${selectedAddress.address2}")
                                                            : Container(),
                                                      ],
                                                    ),
                                                    selectedAddress.address3 != "" ? Row(
                                                      children: [
                                                        Text("${selectedAddress.address3}"),
                                                        selectedAddress.address3 != "" ? SizedBox(width: 3,)
                                                            : Container(),
//                                                    Text("${selectedAddress.pinCode}"),
                                                      ],
                                                    )
                                                        : Container(),
                                                    selectedAddress.city != "" || selectedAddress.state != "" ? Row(
                                                      children: [
                                                        selectedAddress.city != null && selectedAddress.city != "" ? Text("${selectedAddress.city}")
                                                            : Container(),
                                                        selectedAddress.city != null && selectedAddress.city != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                        selectedAddress.state != null && selectedAddress.state != "" ? Text("${selectedAddress.state}")
                                                            : Container(),
                                                      ],
                                                    ) : Container(),
                                                    Row(
                                                      children: [
                                                        selectedAddress.country != "" ? Text("${selectedAddress.country}")
                                                            : Container(),
                                                        selectedAddress.country != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                        selectedAddress.pinCode != "" ? Text("${selectedAddress.pinCode}")
                                                            : Container(),
                                                      ],
                                                    ),
                                                    selectedAddress.mobileNo != "" ? Row(
                                                      children: [
                                                        Text("Mobile No. : "),
                                                        Text(selectedAddress.mobileNo),
                                                      ],
                                                    )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 15.0,
                                              bottom: 0.0,
                                              child: GestureDetector(
                                                onTap: () async {},
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: CircleAvatar(
                                                      radius: 10.0,
                                                      backgroundColor: Colors
                                                          .green,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 17,),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )
                                          : Container(),
                                      Container(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 3.0, 8.0, 3.0),
                                            child: Material(
                                              child: InkWell(
                                                onTap: () async {
                                                  var result = await Navigator
                                                      .push(
                                                      context, MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddressEntryPage()));
                                                  if (result != null &&
                                                      result != false) {
                                                    AddnewAddress("S",
                                                        result); //Shipping Address
                                                  }
                                                },
                                                child: Card(
                                                  color: listbgColor,
                                                  //Color(0xFFEEEEEE),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        8.0, 10.0, 8.0, 10.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          " + Add New Address ",
                                                          style: TextStyle(
                                                              fontSize: 17),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        color: webRightContainerColor,
                      ),
                    ),
                  ],
                ),
              ]
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          color: webLeftContainerColor,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 250, maxWidth: screenWidth),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Visibility(
                                visible: buttonVisable,
                                child: RaisedButton(
                                  color: Color(0xFF517295),
                                  child: Text(
                                    "CONFIRM",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15, fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    buttonVisable = false;
                                    setState(() {

                                    });
                                    var status = await CheckNull();
                                    if (!status) {
                                      UpdateOrder();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: webRightContainerColor,
                        ),
                      ),
                    ]
                ),
              ),
            )
        ),
      ),
    );
  }
}