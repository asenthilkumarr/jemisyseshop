import 'package:flutter/material.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/order.dart';

import 'masterPage.dart';

class AddressPage extends StatefulWidget{
  final int itemCount;
  final double totalAmount;
  AddressPage({this.itemCount, this.totalAmount});

  @override
  _addressPage createState() => _addressPage();
}
class _addressPage extends State<AddressPage> {
  DataService dataService = DataService();
  final _keyLoader = new GlobalKey<FormState>();
  List<Address> dAddress = [];
  Address selectedAddress;
  Address billingAddress;
  double sumValue = 0;
  int itemCount = 0;
  //f Default Radio Button Item
  String radioItem = 'Deliver at the Shipping Address';
  // Group Value for Radio Button.
  int id = 1;
  bool sameval = true, newBilla= false;
  String enableNewAddress = "A", title = "Mr.";

  List<String> titlelist = ["Mr.","Ms.", "Mrs."];
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

  void _handleRadioValueChange(RadioButtonListValue value) {
    if(value.index == 1)
      enableNewAddress = "A";
    else
      enableNewAddress = "S";
    setState(() {

    });
  }

  void getDeliveryAddress() async{
    dAddress = await dataService.GetDeliveryAddress(userID);
    for(int i = 0;i<dAddress.length;i++){
      dAddress[i].title = customerdata.title;
      dAddress[i].fullName = customerdata.firstName;
    }
//    if((dAddress == null || dAddress.length == 0)&& customerdata.address.address1 != ""){
//      dAddress.add(new Address(
//        title: customerdata.title,
//        fullName: customerdata.firstName,
//        mobileNo: customerdata.mobileNumber,
//        address1: customerdata.address.address1,
//        address2: customerdata.address.address2,
//        address3: customerdata.address.address3,
//        address4: customerdata.address.address4,
//        city: customerdata.address.city,
//        state: customerdata.address.state,
//        country: customerdata.address.country,
//        pinCode: customerdata.address.pinCode
//      ));
//    }
    if(dAddress.length>0){
      selectedAddress = dAddress[0];
      if(sameval)
        billingAddress = selectedAddress;
    }

    setState(() {

    });
  }
  void AddnewAddress(String mode, Address data) {
    if (mode == "S") {
      dAddress.add(data);
      if (dAddress.length > 0)
        selectedAddress = dAddress[0];
      if (sameval)
        billingAddress = dAddress[0];
    }
    else
      billingAddress = data;
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    sumValue = widget.totalAmount;
    itemCount = widget.itemCount;

    getDeliveryAddress();
  }
  TextEditingController txtFirstName = TextEditingController();

  int selectedDropdown;
  String selectedText;
  final textController = new TextEditingController();

  String _dropdownValue;
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Address',
      theme: MasterScreen.themeData(context),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Address", style: TextStyle(color: Colors.white),),
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
              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Color(0xFF517295),
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
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text("Items ($itemCount)", style: TextStyle(color: Colors.white, fontSize: 17),),
                              )),),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Text("$currencysymbol${formatterint.format(sumValue)}", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
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
                            padding: const EdgeInsets.only(left:15.0, top:5, right:15, bottom:5),
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
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Text("Delivery Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                                  ),
                                  Column(
                                    children:
                                    fList.map((data) => GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            radioItem = data.name ;
                                            id = data.index;
                                            _handleRadioValueChange(data);
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Radio(
                                              value: data.index,
                                              groupValue: id,
                                              onChanged: (val) {
                                                setState(() {
                                                  radioItem = data.name ;
                                                  id = data.index;
                                                  _handleRadioValueChange(data);
                                                });
                                              },
                                            ),
                                            Text("${data.name}", style: TextStyle(fontSize: 17),),
                                          ],
                                        )
                                    )
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          dAddress.length>0 && radioItem == "Deliver at the Shipping Address" ? Padding(
                            padding: const EdgeInsets.fromLTRB(15.0,0,15,0),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left:5.0, top:5.0, bottom: 5.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Shipping Address", style: TextStyle(fontSize: 18),)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:0.0, right: 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                width: 1,
                                                color: listLabelbgColor,
                                              ),
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                          child: DropdownButton<Address>(
                                            isExpanded: true,
                                            value: selectedAddress,
                                            onChanged: (Address newValue) {
                                              selectedAddress = newValue;
                                              setState(() {
                                              });
                                            },
                                            underline: Container(),
                                            items: dAddress.map((Address taddress) {
                                              return new DropdownMenuItem<Address>(
                                                value: taddress,
                                                child: new Text("${taddress.title} ${taddress.fullName} ${taddress.address1}",
                                                  style: new TextStyle(color: Colors.black,),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
//                          SizedBox(height: 6,),

                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:0.0, right: 0.0),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${selectedAddress.title} ${selectedAddress.fullName}",
                                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                                Text("${selectedAddress.address1} ${selectedAddress.address2}"),
                                                Text("${selectedAddress.address3} ${selectedAddress.pinCode}"),
                                                Text("${selectedAddress.city} ${selectedAddress.state}"),
                                                Text("${selectedAddress.country}")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*
                                    Positioned(
                                        right: 25.0,
                                        top: 8.0,
                                        child: GestureDetector(
                                          onTap: () async {

                                          },
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Text("Edit", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                                          ),
                                        )),
                                    */
                                      Positioned(
                                          right: 15.0,
                                          bottom: 0.0,
                                          child: GestureDetector(
                                            onTap: () async {
                                            },
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 12.0,
                                                  backgroundColor: Colors.green,
                                                  child: Icon(
                                                    Icons.check, color: Colors.white, size: 20,),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  enableNewAddress == "A" ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          child: InkWell(
                                            onTap: () async{
                                              var result = await Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressEntryPage()));
                                              if(result != null){
                                                AddnewAddress("S", result);
                                              }
                                            },
                                            child: Card(
                                              color: listbgColor,//Color(0xFFEEEEEE),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0,13.0,8.0,13.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(" + Add New Address ", style: TextStyle(fontSize: 17),),
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

                          SizedBox(height: 5,),
                          dAddress.length>0 && radioItem == "Deliver at the Shipping Address" ? Padding(
                            padding: const EdgeInsets.only(left:15.0, right: 15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: listLabelbgColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Text("Billing Address", style: TextStyle(fontSize: 18),),
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          if(sameval) {
                                            sameval = false;
                                            billingAddress = null;
                                          }
                                          else{
                                            sameval = true;
                                            billingAddress = selectedAddress;
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
                                                  if(sameval){
                                                    sameval = false;
                                                    billingAddress = null;
                                                  }

                                                  else{
                                                    sameval = true;
                                                    billingAddress = selectedAddress;
                                                  }

                                                });
                                              }
                                          ),
                                          Text("Same as shipping address", style: TextStyle(fontSize: 17),),
                                        ],
                                      )
                                  ),
                                  billingAddress != null ? Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:0.0, right: 0.0),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${billingAddress.title} ${billingAddress.fullName}",
                                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                                Text("${billingAddress.address1} ${billingAddress.address2}"),
                                                Text("${billingAddress.address3} ${billingAddress.pinCode}"),
                                                Text("${billingAddress.city} ${billingAddress.state}"),
                                                Text("${billingAddress.country}")
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
                                              var result = await Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressEntryPage(addressdt: billingAddress,)));
                                              if(result != null) {
                                                AddnewAddress("B", result);
                                              }
                                            },
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Edit", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                          right: 15.0,
                                          bottom: 0.0,
                                          child: GestureDetector(
                                            onTap: () async {
                                            },
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  radius: 12.0,
                                                  backgroundColor: Colors.green,
                                                  child: Icon(
                                                    Icons.check, color: Colors.white, size: 20,),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  )
                                  : Container(),
                                      Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          child: InkWell(
                                            onTap: () async{
                                              var result = await Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressEntryPage()));
                                              if(result != null){
                                                AddnewAddress("B", result);
                                              }
                                            },
                                            child: Card(
                                              color: listbgColor,//Color(0xFFEEEEEE),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0,13.0,8.0,13.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(" + Add New Address ", style: TextStyle(fontSize: 17),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
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
          padding: const EdgeInsets.only(left:1.0, right: 1.0),
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height:50,
                    child: RaisedButton(
                      color: Color(0xFF517295),
                      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
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
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                OrderPage()));
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
//  List<StateList> statelist = new List<StateList>();
  void getDefault() async{
    countrylist = await dataService.GetCountry("*ALL");
    statelist = await dataService.GetState("*ALL");
    setAddress();
    setState(() {

    });
  }
  void getSelectedState(String country) async{
    selectedState = new List<StateList>();
    _dropdownStateValue = null;
    selectedState = statelist.where((e) => e.country == country).toList();
    setState(() {

    });
  }
  void getCity(String country, String state) async {
    citylist =new List<City>();
    _dropdownCityValue = null;
    citylist = await dataService.GetCity(country, state);
    setState(() {

    });
  }
  void updateAddress() async{
    param.eMail = userID;
    param.title = _dropdownTitleValue;
    param.fullName = txtFirstName.text.toString();
    param.address1 = txtAddress1.text.toString();
    param.address2 = txtAddress2.text.toString();
    param.address3 = txtAddress3.text.toString();
    param.pinCode = txtPincode.text.toString();
    param.city = txtCity.text.toString();
    param.state = _dropdownStateValue.state;
    param.country = _dropdownCountryValue.country;
   Navigator.pop(context, param);
  }
  void setAddress() async{
    print(widget.addressdt.title);
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