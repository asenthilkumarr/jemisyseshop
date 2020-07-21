import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/payment.dart';

import 'masterPage.dart';

class AddressPage extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  final List<Cart> itemList;
  AddressPage({this.itemCount, this.totalAmount, this.itemList});

  @override
  _addressPage createState() => _addressPage();
}
class _addressPage extends State<AddressPage> {
  DataService dataService = DataService();
  final _keyLoader = new GlobalKey<FormState>();
  List<Store> storeList = new List<Store>();
  List<Address> dAddress = [];
  List<Address> bAddress = [];
  Address selectedAddress;
  Address billingAddress;
  Store selectedStore;
  double sumValue = 0;
  int itemCount = 0;
  String dstoreCode;
  //f Default Radio Button Item
  String radioItem = 'Deliver at the Shipping Address';

  // Group Value for Radio Button.
  int id = 1;
  bool sameval = true,
      newBilla = false;
  String enableNewAddress = "A",
      title = "Mr.";

  List<String> titlelist = ["Mr.", "Ms.", "Mrs."];
  List<RadioButtonListValue> fList = [
    RadioButtonListValue(
      index: 1,
      name: "Deliver at the Shipping Address",
    ),
    RadioButtonListValue(
      index: 2,
      name: "Pickup from a Store Nearby",
    ),
  ];
  int selectedDropdown;
  String selectedText;
  final textController = new TextEditingController();

  void _handleRadioValueChange(RadioButtonListValue value) {
    if (value.index == 1){
      enableNewAddress = "A";
      if(dAddress.length>0)
        selectedAddress = dAddress[0];
      else
        selectedAddress = null;
    }
    else{
      enableNewAddress = "S";
      selectedAddress = null;
      if(bAddress.length>0)
        billingAddress = bAddress[0];
      else
        billingAddress = null;
    }

    setState(() {

    });
  }

  void getDeliveryAddress() async {
    dAddress = await dataService.getDeliveryAddress(userID);
    bAddress = await dataService.getBillingAddress(userID);
    if (dAddress.length > 0) {
      selectedAddress = dAddress[0];
      if (sameval)
        billingAddress = selectedAddress;
    }

    setState(() {

    });
  }
  void getBillingAddress() async {
    if(sameval){
      billingAddress = selectedAddress;
    }
    else{
      billingAddress = null;
    }
  }
  void AddnewAddress(String mode, Address data) {
    if (mode == "S") {
      dAddress.add(data);
      if (dAddress.length > 0)
        selectedAddress = data; //dAddress[0];
      if (sameval)
        billingAddress = data; //dAddress[0];
    }
    else
      billingAddress = data;
    setState(() {

    });
  }
  Future<bool> CheckNull() async {
    bool isNull = false;
    dstoreCode =null;
    if(selectedStore != null){
      selectedAddress = new Address();
      selectedAddress.fullName = userName;
      selectedAddress.address1 = selectedStore.address1;
      selectedAddress.address2 = selectedStore.address2;
      selectedAddress.address3 = selectedStore.address3;
      selectedAddress.address4 = selectedStore.address4;
      selectedAddress.country = selectedStore.state;
      selectedAddress.pinCode = selectedStore.pinCode;
      selectedAddress.mobileNo = selectedStore.telePhone;;
      dstoreCode = selectedStore.storeCode;
    }
    if (selectedAddress == null) {
      if(radioItem == "Pickup from a Store Nearby")
        await Dialogs.AlertMessage(
            context, "Pickup store cannot be blank, please check");
      else
        await Dialogs.AlertMessage(
            context, "Shipping address cannot be blank, please check");
      isNull = true;
    }
    else if (billingAddress == null) {
      await Dialogs.AlertMessage(
          context, "Billing address cannot be blank, please check");
      isNull = true;
    }
    return isNull;
  }
  void UpdatePayment() async{
    Paymentfn objcf = new Paymentfn();
    OrderData param = new OrderData();
    FocusScope.of(context).requestFocus(FocusNode());
    param.eMail = userID;
    param.totalAmount = widget.totalAmount;
    param.discount = 0;
    param.netAmount = widget.totalAmount;
    param.shippingAddress = selectedAddress;
    param.billingAddress = billingAddress;
    if(radioItem=="Pickup from a Store Nearby" && selectedStore != null){
      param.dstoreCode = selectedStore.storeCode;
      param.deliveryMode = "S";//Pickup
    }
    else{
      param.dstoreCode = null;
      param.deliveryMode = "S";//Shipping
    }
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
    objcf.updateOrder(param, widget.itemList, null, context);
  }
  void loadDefault() async{
    storeList = new List<Store>();

    getDeliveryAddress();
    storeList = await dataService.getStores();
  }

  @override
  void initState() {
    super.initState();
    sumValue = widget.totalAmount;
    itemCount = widget.itemCount;

    loadDefault();
  }

  @override
  Widget build(BuildContext context) {
//    print(billingAddress.fullName);
    return MaterialApp(
      title: 'Address',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Address", style: TextStyle(color: title1Color),),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: title1Color,),
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
                Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: buttonColor,
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Items ($itemCount)",
                                      style: TextStyle(color: buttonTextColor,
                                          fontSize: 17),),
                                  )),),
                            Expanded(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                        "$currencysymbol${formatterint.format(
                                            sumValue)}", style: TextStyle(
                                        color: buttonTextColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                  )),),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 5, right: 15, bottom: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: listLabelbgColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.1, 0.1, 0.1, 0.0),
                                      child: Container(
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
                                            child: Text("Delivery Mode",
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold),),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              width: 1,
                                              color: listLabelbgColor,
                                            ),
                                          )
                                      ),
                                      child: Column(
                                        children:
                                        fList.map((data) =>
                                            Container(
                                              height: 35,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      radioItem = data.name;
                                                      id = data.index;
                                                      _handleRadioValueChange(
                                                          data);
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .max,
                                                    children: [
                                                      Radio(
                                                        value: data.index,
                                                        groupValue: id,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioItem =
                                                                data.name;
                                                            id = data.index;
                                                            _handleRadioValueChange(
                                                                data);
                                                          });
                                                        },
                                                      ),
                                                      Text("${data.name}",),
                                                    ],
                                                  )
                                              ),
                                            )
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            radioItem == "Deliver at the Shipping Address"
                                ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 10, 15, 0),
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
                                          child: Text("Shipping Address",
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
                                                if(sameval){
                                                  billingAddress = selectedAddress;
                                                }
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
                                    enableNewAddress == "A" ? Container(
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
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                                : Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 10, 15, 0),
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
                                            child: Text("Chose Your Store",
                                              style: TextStyle(fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ),
                                      Align(
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
                                              child: DropdownButton<Store>(
                                                isExpanded: true,
                                                value: selectedStore,
                                                onChanged: (Store newValue) {
                                                  selectedStore = newValue;

                                                  setState(() {});
                                                },
                                                underline: Container(),
                                                items: storeList.map((
                                                    Store taddress) {
                                                  return new DropdownMenuItem<
                                                      Store>(
                                                    value: taddress,
                                                    child: new Text("${taddress
                                                        .storeCode} ${taddress
                                                        .address1} ${taddress
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
                                      ),
                                      selectedStore != null ? Stack(
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
                                                        selectedStore.storeCode != "" ? Text( "${selectedStore.storeCode}",
                                                          style: TextStyle(fontWeight: FontWeight.bold),)
                                                            : Container(),
                                                        selectedStore.description != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                        selectedStore.description != "" ? Text("${selectedStore.description}",
                                                          style: TextStyle(fontWeight: FontWeight.bold),)
                                                            : Container(),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        selectedStore.address1 != "" ? Text("${selectedStore.address1}")
                                                            : Container(),
                                                      ],
                                                    ),
                                                    selectedStore.address2 != "" ? Row(
                                                      children: [
                                                        Text("${selectedStore.address2}"),
                                                      ],
                                                    )
                                                        : Container(),
                                                    selectedStore.address3 != "" ? Row(
                                                      children: [
                                                        Text("${selectedStore.address3}"),
                                                        selectedStore.address3 != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                      ],
                                                    )
                                                        : Container(),
                                                    Row(
                                                      children: [
                                                        selectedStore.state != "" ? Text("${selectedStore.state}")
                                                            : Container(),
                                                        selectedStore.state != "" ? SizedBox(width: 3,)
                                                            : Container(),
                                                        selectedStore.pinCode != "" ? Text("${selectedStore.pinCode}")
                                                            : Container(),
                                                      ],
                                                    ),
                                                    selectedStore.telePhone != "" ? Row(
                                                      children: [
                                                        Text("Tel. : "),
                                                        Text(selectedStore.telePhone),
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
                                    ]
                                )
                              ),
                            ),
                            SizedBox(height: 5,),
                            dAddress.length > 0 || radioItem == "Pickup from a Store Nearby"
                                ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 10, 15.0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: listLabelbgColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          child: Text("Billing Address",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                    radioItem == "Deliver at the Shipping Address" ?
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              width: 1,
                                              color: listLabelbgColor,
                                            ),
                                          )
                                      ),
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (sameval) {
                                                sameval = false;
                                                getBillingAddress();
                                              }
                                              else {
                                                sameval = true;
                                                getBillingAddress();
                                              }
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Checkbox(
                                                  value: sameval,
                                                  onChanged: (bool val) {
                                                    setState(() {
                                                      if (sameval) {
                                                        sameval = false;
                                                        getBillingAddress();
                                                      }
                                                      else {
                                                        sameval = true;
                                                        getBillingAddress();
                                                      }
                                                    });
                                                  }
                                              ),
                                              Text("Same as shipping address",),
                                            ],
                                          )
                                      ),
                                    )
                                        : Container(),

                                    (!sameval ||radioItem == "Pickup from a Store Nearby") && bAddress.length > 0 ? Align(
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
                                              value: billingAddress,
                                              onChanged: (Address newValue) {
                                                billingAddress = newValue;
                                                setState(() {});
                                              },
                                              underline: Container(),
                                              items: bAddress.map((
                                                  Address taddress) {
                                                return new DropdownMenuItem<Address>(
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
                                    billingAddress != null ? Stack(
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
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      billingAddress.title != "" ? Text("${billingAddress.title}",
                                                        style: TextStyle(fontWeight: FontWeight.bold),)
                                                          : Container(),
                                                      billingAddress.title != "" ? SizedBox(width: 3,)
                                                          : Container(),
                                                      billingAddress.fullName != "" ? Text("${billingAddress.fullName}",
                                                        style: TextStyle(fontWeight: FontWeight.bold),)
                                                          : Container(),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      billingAddress.address1 != "" ? Text("${billingAddress.address1}")
                                                          : Container(),
                                                      billingAddress.address1 != "" ? SizedBox(width: 3,)
                                                          : Container(),
                                                      billingAddress.address2 != "" ? Text("${billingAddress.address2}")
                                                          : Container(),
                                                    ],
                                                  ),
                                                  billingAddress.address3 != "" ? Row(
                                                    children: [
                                                      Text("${billingAddress.address3}"),
                                                      billingAddress.address3 != "" ? SizedBox(width: 3,)
                                                          : Container(),
//                                                    Text("${selectedAddress.pinCode}"),
                                                    ],
                                                  )
                                                      : Container(),
                                                  billingAddress.city != null || billingAddress.state != "" ? Row(
                                                    children: [
                                                      billingAddress.city != null && billingAddress.city != "" ? Text("${billingAddress.city}")
                                                          : Container(),
                                                      billingAddress.city != null && billingAddress.city != "" ? SizedBox(width: 3,)
                                                          : Container(),
                                                      billingAddress.state != null && billingAddress .state != "" ? Text("${billingAddress.state}")
                                                          : Container(),
                                                    ],
                                                  )
                                                      : Container(),
                                                  Row(
                                                    children: [
                                                      billingAddress.country != "" ? Text("${billingAddress.country}")
                                                          : Container(),
                                                      billingAddress.country !="" ? SizedBox(width: 3,)
                                                          : Container(),
                                                      billingAddress.country !="" ? Text("${billingAddress.pinCode}")
                                                          : Container(),
                                                    ],
                                                  ),
                                                  billingAddress.mobileNo != "" ? Row(
                                                    children: [
                                                      Text("Mobile No. : "),
                                                      Text(billingAddress.mobileNo),
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
                                            top: 0.0,
                                            child: GestureDetector(
                                              onTap: () async {
                                                var result = await Navigator
                                                    .push(
                                                    context, MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddressEntryPage(
                                                          addressdt: billingAddress,)));
                                                if (result != null &&
                                                    result != false) {
                                                  AddnewAddress("B",
                                                      result); //Billing Address
                                                }
                                              },
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(8.0),
                                                    child: Text("Edit",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight: FontWeight
                                                              .bold),)
                                                ),
                                              ),
                                            )),
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

                                    sameval == false || radioItem == "Pickup from a Store Nearby" ? Container(
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
                                                  AddnewAddress("B", result);
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
                                        : Container(),

                                  ],
                                ),
                              ),
                            )
                                : Container(),
                            SizedBox(height: 5,)
                          ],
                        ),
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
                padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            color: Color(0xFF517295),
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              var status = await CheckNull();
                              if (!status) {
                                if(paymentGateway != ""){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentPage(itemCount: itemCount,
                                            totalAmount: sumValue,
                                            sAddress: selectedAddress,
                                            dAddress: billingAddress, itemList: widget.itemList,dstoreCode: dstoreCode,)));
                                }
                                else{
                                  UpdatePayment();
                                }
                              }
                            },
                          ),
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

  void _dropdownChange(val) {
    setState(() {
      selectedDropdown = val;
    });
  }
}

class AddressEntryPage extends StatefulWidget{
  final Address addressdt;
  AddressEntryPage({this.addressdt});

  @override
  _addressEntryPage createState() => _addressEntryPage();
}
class _addressEntryPage extends State<AddressEntryPage>{
  DataService dataService = DataService();
  final _keyLoader = new GlobalKey<FormState>();
  String _errorText;
  String _dropdownTitleValue;
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtMobileno = TextEditingController();
  TextEditingController txtAddress1 = TextEditingController();
  TextEditingController txtAddress2 = TextEditingController();
  TextEditingController txtAddress3 = TextEditingController();
  TextEditingController txtPincode = TextEditingController();
  TextEditingController txtCity = TextEditingController();

  List<String> titlelist = ["Mr.","Ms.", "Mrs."];
//  List<String> statelist = ["State 1","State 2"];
  //List<String> countrylist = ["Singapore","Malaysia"];
  Address param = new Address();
  List<Country> countrylist = new List<Country>();
  List<StateList> statelist = new List<StateList>();
  List<StateList> selectedState = new List<StateList>();
  List<City> citylist = new List<City>();
  Country _dropdownCountryValue;
  StateList _dropdownStateValue;
  City _dropdownCityValue;

  void getDefault() async{
    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go

    countrylist = await dataService.getCountry("*ALL");
    statelist = await dataService.getState("*ALL");
    setAddress();

    Navigator.of(
        _keyLoader.currentContext, rootNavigator: true)
        .pop(); //close the dialoge
    setState(() {

    });
  }
  void getSelectedState(String country) async{
    selectedState = new List<StateList>();
    _dropdownStateValue = null;
    if(_dropdownCountryValue.cityState == false)
      selectedState = statelist.where((e) => e.country == country).toList();
    setState(() {

    });
  }
  void getCity(String country, String state) async {
    citylist =new List<City>();
    _dropdownCityValue = null;
//    Dialogs.showLoadingDialog(context, _keyLoader); //invoking go
    citylist = await dataService.getCity(country, state);
//    Navigator.of(
//        _keyLoader.currentContext, rootNavigator: true)
//        .pop(); //close the dialoge
    setState(() {

    });
  }
  void updateAddress() async{
    FocusScope.of(context).requestFocus(FocusNode());
    var checknull = await CheckNull();
    if(!checknull){
      param.eMail = userID;
      param.title = _dropdownTitleValue;
      param.fullName = txtFirstName.text.toString().toUpperCase();
      param.mobileNo = txtMobileno.text.toString();
      param.address1 = txtAddress1.text.toString();
      param.address2 = txtAddress2.text.toString();
      param.address3 = txtAddress3.text.toString();
      param.pinCode = txtPincode.text.toString();
      if(_dropdownCityValue != null)
        param.city = _dropdownCityValue.city;
      if(_dropdownStateValue != null)
        param.state = _dropdownStateValue.state;
      param.country = _dropdownCountryValue.country;
      Navigator.pop(context, param);
    }
  }
  void setAddress() async{
    if(widget.addressdt.title!="")
      _dropdownTitleValue = widget.addressdt.title;
    txtFirstName.text = widget.addressdt.fullName;
    txtMobileno.text = widget.addressdt.mobileNo;
    txtAddress1.text = widget.addressdt.address1;
    txtAddress2.text = widget.addressdt.address2;
    txtAddress3.text = widget.addressdt.address3;
    txtPincode.text = widget.addressdt.pinCode;
    if(widget.addressdt != null && widget.addressdt.address1 != null && widget.addressdt.address1 != ""){
      if(widget.addressdt.title != "")
        _dropdownTitleValue = widget.addressdt.title;
      if(widget.addressdt.country != ""){
        _dropdownCountryValue = countrylist.where((e) => e.country == widget.addressdt.country).toList()[0];
        await getSelectedState(widget.addressdt.country);
      }
      if(widget.addressdt.state != ""){
        _dropdownStateValue = statelist.where((e) => e.country == widget.addressdt.country &&
        e.state == widget.addressdt.state).toList()[0];
        await getCity(widget.addressdt.country, widget.addressdt.state);
      }
    }
    setState(() {

    });
  }

  Future<bool> CheckNull() async {
    bool isNull = false;
    if (_dropdownTitleValue == null) {
      await Dialogs.AlertMessage(
          context, "Title cannot be blank, please check");
      isNull = true;
    }
    else if (txtFirstName.text == null || txtFirstName.text == "") {
      await Dialogs.AlertMessage(
          context, "Name cannot be blank, please check");
      isNull = true;
    }
    else if (txtMobileno.text == null || txtMobileno.text == "") {
      await Dialogs.AlertMessage(
          context, "Mobile number cannot be blank, please check");
      isNull = true;
    }
    else if (txtAddress1.text == null || txtAddress1.text == "") {
      await Dialogs.AlertMessage(
          context, "Address cannot be blank, please check");
      isNull = true;
    }
    else if (txtPincode.text == null || txtPincode.text == "") {
      await Dialogs.AlertMessage(
          context, "Postal code cannot be blank, please check");
      isNull = true;
    }
    else if (_dropdownCountryValue == null) {
      await Dialogs.AlertMessage(
          context, "Country cannot be blank, please check");
      isNull = true;
    }
    else if (_dropdownCountryValue.cityState == false && _dropdownStateValue == null) {
      await Dialogs.AlertMessage(
          context, "State cannot be blank, please check");
      isNull = true;
    }
    else if (_dropdownCountryValue.cityState == false && _dropdownStateValue.cityState == false && _dropdownCityValue == null) {
      await Dialogs.AlertMessage(
          context, "City cannot be blank, please check");
      isNull = true;
    }
    return isNull;
  }
  @override
  void initState(){
    super.initState();
    getDefault();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return MaterialApp(
        title: 'Address',
        theme: MasterScreen.themeData(context),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Add New Address", style: TextStyle(color: Colors.white),),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }
              ),
              backgroundColor: Color(0xFFFF8752),
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
                  Container(
                    constraints: BoxConstraints(minWidth: 300, maxWidth: 450),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        border: Border.all(
                                          width: 1,
                                          color: BoxBorderColor,
                                        ),
                                        color: Colors.white70,
                                      ),

                                      child: DropdownButtonHideUnderline(
                                        child: Column(
                                          children: [
                                            InputDecorator(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: false,
//                                        hintText: 'Title',
                                                labelText: 'Title ',
                                                errorText: _errorText,
                                                fillColor:  Colors.white70,
                                          border: InputBorder.none,
//                                        focusedBorder: InputBorder.none,
//                                        enabledBorder: InputBorder.none,
//                                        errorBorder: InputBorder.none,

                                                contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                              ),
                                              isEmpty: _dropdownTitleValue == null,
                                              child: new DropdownButton<String>(
                                                value: _dropdownTitleValue,
                                                isDense: true,
                                                dropdownColor: Colors.white,
                                                focusColor: Colors.white,
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    _dropdownTitleValue = newValue;
                                                  });
                                                },
                                                items: titlelist.map((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Flexible(
                                    child: TextField(
                                      controller: txtFirstName,
                                      textCapitalization: TextCapitalization.characters,
                                      autocorrect: true,
                                      decoration: InputDecoration(
                                        isDense: true,
//                                      hintText: 'Full Name',
                                        labelText: "Full Name",
                                        prefixIcon: Icon(Icons.person),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor:  Colors.white70,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                        ),
                                        contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                      ),),
                                  ),
                                ],
                              ),
                              SizedBox(height: 9.0,),
                              TextField(
                                controller: txtMobileno,
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
//                                hintText: 'Mobile No*',
                                  labelText: "Mobile No*",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  prefixIcon: Icon(Icons.mobile_screen_share),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              TextField(
                                controller: txtAddress1,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
//                                hintText: 'Address*',
                                  labelText: "Address*",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  prefixIcon: Icon(Icons.location_on),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              TextField(
                                controller: txtAddress2,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
//                                hintText: 'Address',
                                  labelText: "Address",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  prefixIcon: Icon(Icons.contact_mail, color: Colors.transparent,),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              TextField(
                                controller: txtAddress3,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
//                                hintText: 'Address',
                                  labelText: "Address",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  prefixIcon: Icon(Icons.contact_mail, color: Colors.transparent,),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              TextField(
                                controller: txtPincode,
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
//                                hintText: 'Postal Code*',
                                  labelText: "Postal Code*",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  prefixIcon: Icon(Icons.contact_mail, color: Colors.transparent,),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              /*
                              TextField(
                                controller: txtCity,
                                autocorrect: true,
                                decoration: InputDecoration(
                                  isDense: true,
//                                hintText: 'City',
                                  labelText: "City",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor:  Colors.white70,
                                  prefixIcon: Icon(Icons.location_city,),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: BoxBorderColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color:  BoxBorderColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              */
                              Container(
//                              height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                    width: 1,
                                    color: BoxBorderColor,
                                  ),
                                  color: Colors.white70,
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: Column(
                                    children: [
                                      InputDecorator(
                                        decoration: InputDecoration(
                                          isDense: true,
                                          filled: false,
//                                        hintText: 'Title',
                                          labelText: 'Country ',
                                          errorText: _errorText,
                                          fillColor:  Colors.white70,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.location_city, color: Colors.transparent,),
                                          contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                        ),
                                        isEmpty: _dropdownCountryValue == null,
                                        child: new DropdownButton<Country>(
                                          value: _dropdownCountryValue,
                                          isDense: true,
                                          dropdownColor: Colors.white,
                                          focusColor: Colors.white,
                                          onChanged: (Country newValue) {
//                                            selectedState = new List<StateList>();
                                            citylist = new List<City>();
//                                            _dropdownStateValue = new StateList();
                                            setState(() {
                                              _dropdownCountryValue = newValue;
                                            });
                                            setState(() {
                                              getSelectedState(_dropdownCountryValue.country);
                                            });
                                          },

                                          items: countrylist.map((Country value) {
                                            return DropdownMenuItem<Country>(
                                              value: value,
                                              child: Text(value.country),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 9.0,),
                              Container(
//                              height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                    width: 1,
                                    color: BoxBorderColor,
                                  ),
                                  color: Colors.white70,
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: Column(
                                    children: [
                                      InputDecorator(
                                        decoration: InputDecoration(
                                          isDense: true,
                                          filled: false,
//                                        hintText: 'Title',
                                          labelText: 'State',
                                          errorText: _errorText,
                                          fillColor:  Colors.white70,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.location_city, color: Colors.transparent,),
                                          contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                        ),
                                        isEmpty: _dropdownStateValue == null,
                                        child: selectedState != null && selectedState.length>0 ? new DropdownButton<StateList>(
                                          value: _dropdownStateValue,
                                          isDense: true,
                                          dropdownColor: Colors.white,
                                          focusColor: Colors.white,
                                          onChanged: (StateList newValue) {
                                            _dropdownStateValue = newValue;
                                            citylist =new List<City>();
                                            setState(() {
                                              getCity(_dropdownCountryValue.country, _dropdownStateValue.state);
                                            });
                                          },
                                          items: selectedState.map((StateList value) {
                                            return DropdownMenuItem<StateList>(
                                              value: value,
                                              child: Text(value.state),
                                            );
                                          }).toList(),
                                        )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              ,
                              SizedBox(height: 9.0,),
                              Container(
//                              height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                    width: 1,
                                    color: BoxBorderColor,
                                  ),
                                  color: Colors.white70,
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: Column(
                                    children: [
                                      InputDecorator(
                                        decoration: InputDecoration(
                                          isDense: true,
                                          filled: false,
//                                        hintText: 'Title',
                                          labelText: 'City',
                                          errorText: _errorText,
                                          fillColor:  Colors.white70,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.location_city, color: Colors.transparent,),
                                          contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 0),
                                        ),
                                        isEmpty: _dropdownCityValue == null,
                                        child: citylist.length>0 ? new DropdownButton<City>(
                                          value: _dropdownCityValue,
                                          isDense: true,
                                          dropdownColor: Colors.white,
                                          focusColor: Colors.white,
                                          onChanged: (City newValue) {
                                            setState(() {
                                              _dropdownCityValue = newValue;
                                            });
                                          },
                                          items: citylist.map((City value) {
                                            return DropdownMenuItem<City>(
                                              value: value,
                                              child: Text(value.city),
                                            );
                                          }).toList(),
                                        )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  ,
                              SizedBox(height: 15.0,),
                            ]
                        ),
                      ),
                    ),
                  ),
                  ]
                )
            ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Material(
                child: InkWell(
                  onTap: (){
                    updateAddress();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        width: 1,
                        color: BoxBorderColor,
                      ),
                      color: Color(0xFF517295),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0,13.0,0.0,13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SAVE", style: TextStyle(fontSize: 17, color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}