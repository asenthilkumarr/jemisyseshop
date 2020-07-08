import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/widget/expansionTile.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class FilterPage extends StatefulWidget{
//  final FilterValue fValue;
  final List<Product> productdt;
  FilterPage({this.productdt});

  @override
  _filterPage createState() => _filterPage();
}
class _filterPage extends State<FilterPage> {
  DataService dataService = DataService();
  List<Product> productdt = new List<Product>();
  List<Product> fproductdt = new List<Product>();

  double minprice = 0;
  double maxprice = 100;
  double minwt = 0;
  double maxwt = 50;
  double lowerprice = 0;
  double upperprice = 100;
  double lowerweight = 0;
  double upperweight = 100;
  int divisions = 10;
  bool showValueIndicator = true;
  int valueIndicatorMaxDecimals = 1;
  bool forceValueIndicator = true;
  Color overlayColor = Color(0xFF1C2852); //move icon color
  Color activeTrackColor = Color(0xFFFFC300); // select value
  Color inactiveTrackColor = Color(0xFFB1B6B1); // bar color
  Color thumbColor = Colors.green;
  Color valueIndicatorColor = Colors.blue;
  Color activeTickMarkColor = Colors.black;

  List<FilterSelValue> selMetal = [];

  bool flagWarranty = true;
  FilterValue mValue;
  FilterValue fValue;
  double rangebarWidth = 20;

  TextEditingController txtminpricecontroller = new TextEditingController();
  TextEditingController txtmaxpricecontroller = new TextEditingController();
  TextEditingController txtminwtcontroller = new TextEditingController();
  TextEditingController txtmaxwtcontroller = new TextEditingController();
  var isExpanded = false;

  List<double> _price;
  List<double> _weight;

  RangeValues values = RangeValues(0, 100);
  RangeLabels labels = RangeLabels("0", "100");
  GlobalKey stickyKey = GlobalKey();
  String source="groupName";

  List<FilterSelValue> getGroup() {
    List<FilterSelValue> dList = new List<FilterSelValue>();
    var col0 = widget.productdt.map<String>((row) => row.groupName).toList(growable: false);
    var grouplist = col0.toSet().where((e) => (e != null && e != "")).toList();
    for(var i in grouplist){
      dList.add(FilterSelValue(isChecked: false, value: i, value2: null));
    }
    return dList;
  }
  List<FilterSelValue> getFilterBrands(){
    List<FilterSelValue> dList = new List<FilterSelValue>();
    var col0 = widget.productdt.map<String>((row) => row.brand).toList(growable: false);
    var brand = col0.toSet().where((e) => (e != null && e != "")).toList();
    for(var i in brand){
      dList.add(FilterSelValue(isChecked: false, value: i, value2: null));
    }
    return dList;
  }
  List<FilterSelValue> getFilterDesign(){
    List<FilterSelValue> dList = new List<FilterSelValue>();
    int index = 0;
    var col0 = widget.productdt.map<String>((row) => row.designCode).toList(growable: false);
    var design = col0.toSet().where((e) => (e != null && e != "")).toList();
    for(var i in design){
      dList.add(FilterSelValue(isChecked: false, value: i, value2: null));
    }
    for(var i in dList){
      for(var a in widget.productdt){
        if(dList[index].value == a.designCode) {
          dList[index].value3 = a.imageFile1;
          break;
        }
      }
      index++;
    }
    return dList;

  }
  List<FilterSelValue> getFilterDiscount(){
    List<FilterSelValue> dList = new List<FilterSelValue>();
    var col0 = widget.productdt.map<double>((row) => row.discountPercentage).toList(growable: false);
    var discountlist = col0.toSet().toList();
    for(var i in discountlist){
      if(i>0){
        var t = i.toString() + "% OFF";
        dList.add(FilterSelValue(isChecked: false, value: i.toString()+"% OFF", value2: i));
      }
    }
    return dList;
  }
  List<FilterSelValue> getFilterMetalType(){
    List<FilterSelValue> dList = new List<FilterSelValue>();
    var col0 = widget.productdt.map<String>((row) => row.metalType).toList(growable: false);
    var metalType = col0.toSet().where((e) => (e != null && e != "")).toList();
    for(var i in metalType){
      dList.add(FilterSelValue(isChecked: false, value: i, value2: null));
    }
    return dList;
  }
  List<FilterSelValue> getFilterJewelSize(){
    List<FilterSelValue> dList = new List<FilterSelValue>();
    var col0 = widget.productdt.map<String>((row) => row.jewelSize).toList(growable: false);
    var jewelSize = col0.toSet().where((e) => (e != null && e != "")).toList();
    for(var i in jewelSize){
      dList.add(FilterSelValue(isChecked: false, value: i, value2: null));
    }
    dList.sort((a, b) => a.value.compareTo(b.value));
    return dList;
  }

  List<double> getFilterPricerange(){
    var col0 = widget.productdt.map<double>((row) => row.listingPrice).toList(growable: false);
    var listingprice = col0.toSet().toList();
    var minval = listingprice.reduce(min);
    var maxval = listingprice.reduce(max);
    List<double> reslut = List<double>();
    reslut.add(minval);
    reslut.add(maxval);
    return reslut;
  }
  List<double> getFilterWeightrange(){
    var col0 = widget.productdt.map<double>((row) => row.goldWeight).toList(growable: false);
    var goldWeight = col0.toSet().toList();
    var minval = goldWeight.reduce(min);
    var maxval = goldWeight.reduce(max);
    List<double> reslut = List<double>();
    reslut.add(minval);
    reslut.add(maxval);
    return reslut;
  }
  void getFilter() async {
    FilterValue result = new FilterValue();
    fValue = new FilterValue();
    _price=  getFilterPricerange();
    _weight = getFilterWeightrange();

    result.minprice = _price[0];
    result.maxprice = _price[1];
    result.minweight = _weight[0];
    result.maxweight = _weight[1];

    result.group = getGroup();
    result.metal = getFilterMetalType();
    result.brand = getFilterBrands();
    result.design = getFilterDesign();
    result.discount = getFilterDiscount();
    result.jewelSize = getFilterJewelSize();

    mValue = result;
    fValue = result;
    minprice = fValue.minprice;
    maxprice = fValue.maxprice;
    minwt = fValue.minweight;
    maxwt = fValue.maxweight;
    lowerprice = fValue.minprice;
    upperprice = fValue.maxprice;
    lowerweight = fValue.minweight;
    upperweight = fValue.maxweight;
    txtminpricecontroller.text = formatterint.format(lowerprice);
    txtmaxpricecontroller.text = formatterint.format(upperprice);
    txtminwtcontroller.text = formatterint.format(lowerweight);
    txtmaxwtcontroller.text = formatterint.format(upperweight);
    setState(() {

    });

  }
  Future<List<Product>> getFilterProductData(FilterValue fv) async {
    fproductdt = new List<Product>();
    bool isfvalid = false;
    if(fv.group.length>0) isfvalid=true;
    if(fv.metal.length>0) isfvalid=true;
    if(fv.brand.length>0) isfvalid=true;
    if(fv.design.length>0) isfvalid=true;
    if(fv.jewelSize.length>0) isfvalid=true;
    if(fv.discount.length>0) isfvalid=true;
    if(fv.minprice != null) isfvalid=true;
    if(fv.maxprice != null) isfvalid=true;
    if(fv.minweight != null) isfvalid=true;
    if(fv.maxweight != null) isfvalid=true;

    List<Product> temp = new List<Product>();
    for(var m in fv.group){
      var temp2 = productdt.where((i) =>
      i.groupName.toUpperCase() == m.value.toUpperCase()
      ).toList();
      temp.addAll(temp2);
    }
    if(fv.metal.length>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        for (var b in fv.metal) {
          var temp2 = fproductdt.where((i) => i.metalType == b.value).toList();
          temp.addAll(temp2);
        }
      }
      else {
        for (var b in fv.metal) {
          temp.addAll(productdt.where((i) => i.metalType == b.value).toList());
        }
      }
    }
    if(fv.brand.length>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        for (var b in fv.brand) {
          var temp2 = fproductdt.where((i) => i.brand == b.value).toList();
          temp.addAll(temp2);
        }
      }
      else {
        for (var b in fv.brand) {
          temp.addAll(productdt.where((i) => i.brand == b.value).toList());
        }
      }
    }
    if(fv.design.length>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        for (var b in fv.design) {
          var temp2 = fproductdt.where((i) => i.designCode == b.value).toList();
          temp.addAll(temp2);
        }
      }
      else {
        for (var b in fv.design) {
          temp.addAll(productdt.where((i) => i.designCode == b.value).toList());
        }
      }
    }
    if(fv.discount.length>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        for (var b in fv.discount) {
          var temp2 = fproductdt.where((i) => i.discountPercentage == b.value2).toList();
          temp.addAll(temp2);
        }
      }
      else {
        for (var b in fv.discount) {
          temp.addAll(productdt.where((i) => i.discountPercentage == b.value2).toList());
        }
      }
    }
    if(fv.jewelSize.length>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        for (var b in fv.jewelSize) {
          var temp2 = fproductdt.where((i) => i.jewelSize == b.value).toList();
          temp.addAll(temp2);
        }
      }
      else {
        for (var b in fv.jewelSize) {
          temp.addAll(productdt.where((i) => i.jewelSize == b.value).toList());
        }
      }
    }
    if(fv.minprice!=null && fv.minprice>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        var temp2 = fproductdt.where((i) => i.listingPrice >= fv.minprice).toList();
        temp.addAll(temp2);
      }
      else {
        temp.addAll(productdt.where((i) => i.listingPrice >= fv.minprice).toList());
      }
    }
    if(fv.maxprice!=null && fv.maxprice>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        var temp2 = fproductdt.where((i) => i.listingPrice <= fv.maxprice).toList();
        temp.addAll(temp2);
      }
      else {
        temp.addAll(productdt.where((i) => i.listingPrice <= fv.maxprice).toList());
      }
    }
    if(fv.minweight!=null && fv.minweight>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        var temp2 = fproductdt.where((i) => i.goldWeight >= fv.minweight).toList();
        temp.addAll(temp2);
      }
      else {
        temp.addAll(productdt.where((i) => i.goldWeight >= fv.minweight).toList());
      }
    }
    if(fv.maxweight!=null && fv.maxweight>0){
      fproductdt = temp;
      temp = new List<Product>();
      if(fproductdt.length>0){
        var temp2 = fproductdt.where((i) => i.goldWeight <= fv.maxweight).toList();
        temp.addAll(temp2);
      }
      else {
        temp.addAll(productdt.where((i) => i.goldWeight <= fv.maxweight).toList());
      }
    }
    fproductdt = new List<Product>();
    fproductdt.addAll(temp);
    if(isfvalid==false)
      fproductdt = productdt;
    Navigator.pop(context, fproductdt);
    return fproductdt;
  }
  Widget filterWidget(){
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: Row(
        children: [
          Container(
              width: 115,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFe2e8ec),
                  width: 1,
                ),
                //borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fValue.group.length > 0 ? RawMaterialButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'Product Type', softWrap: true,
                        ),
                      ),
                    ),
                  )
                  : Container(),
                  fValue.metal.length > 0 ? RawMaterialButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'Metal Type', softWrap: true,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  fValue.brand.length > 0 ? RawMaterialButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'Brand', softWrap: true,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  fValue.discount.length > 0 ? RawMaterialButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'Discount', softWrap: true,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  RawMaterialButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'Price Range', softWrap: true,
                        ),
                      ),
                    ),
                  ),
                  fValue.maxweight > 0 ? RawMaterialButton(
                    onPressed: () {},
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'Weight Range', softWrap: true,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),

      Container(
        width: screenSize.width-130,
        height: screenSize.height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFFe2e8ec),
            width: 1,
          ),
          //borderRadius: BorderRadius.circular(12),
        ),
      ),
        ],
      ),
    );
  }
  Widget filterWidget2() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left:8.0, right:8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: listbgColor,
                  width: 2
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fValue.group.length > 0 ? CustomExpansionTile(
                headerBackgroundColor: listbgColor,
                iconColor: Colors.black,
                initiallyExpanded: false,
                title: Container(
                  child: Text("Product Type")),
                children: [
                  for(int i = 0; i < fValue.group.length; i++)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: fValue.group[i].isChecked,
                                  onChanged: (bool value) {
                                    fValue.group[i].isChecked = value;
                                    setState(() {});
                                  },
                                ),
                                Text(toBeginningOfSentenceCase(fValue.group[i].value.toLowerCase()),),
                              ],
                            ),
                          ),
/*
                          child: CheckboxListTile(
                            value: gValue.metal[i].isChecked,
                            title: Text(gValue.metal[i].value, style: TextStyle(fontSize: 13),),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool value) {
                              gValue.metal[i].isChecked=value;
                              setState((
                                  ) {
                              });
                            },
                          ),
                          */
                        )),
                ],
              )
              : Container(),
              CustomExpansionTile(
                  headerBackgroundColor: listbgColor,
                  iconColor: Colors.black,
                  title:Text("Metal Type"),
                children: [
                  for(int i = 0; i < fValue.metal.length; i++)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: fValue.metal[i].isChecked,
                                  onChanged: (bool value) {
                                    fValue.metal[i].isChecked = value;
                                    setState(() {});
                                  },
                                ),
                                Text(fValue.metal[i].value,),
                              ],
                            ),
                          ),
/*
                          child: CheckboxListTile(
                            value: gValue.metal[i].isChecked,
                            title: Text(gValue.metal[i].value, style: TextStyle(fontSize: 13),),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool value) {
                              gValue.metal[i].isChecked=value;
                              setState((
                                  ) {
                              });
                            },
                          ),
                          */
                        )),
                ],
              ),
              CustomExpansionTile(
                headerBackgroundColor: listbgColor,
                iconColor: Colors.black,
                initiallyExpanded: isExpanded,
                title: Text("Brand"),
                children: [
                  for(int i = 0; i < fValue.brand.length; i++)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),

                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: fValue.brand[i].isChecked,
                                  onChanged: (bool value) {
                                    fValue.brand[i].isChecked = value;
                                    setState(() {});
                                  },
                                ),
                                Text(fValue.brand[i].value,),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
              fValue.discount.length > 0 ? CustomExpansionTile(
                headerBackgroundColor: listbgColor,
                iconColor: Colors.black,
                initiallyExpanded: false,
                title: Text("Discount"),
                children: [
                  for(int i = 0; i < fValue.discount.length; i++)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: fValue.discount[i].isChecked,
                                  onChanged: (bool value) {
                                    fValue.discount[i].isChecked = value;
                                    setState(() {});
                                  },
                                ),
                                Text(fValue.discount[i].value,),
                              ],
                            ),
                          ),
                        )),
                ],
              )
                  : Container(),

              CustomExpansionTile(
                headerBackgroundColor: listbgColor,
                iconColor: Colors.black,
                initiallyExpanded: isExpanded,
                title: Text("Price Range"),
                children: [
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top:15, bottom: 15),
                      child: Row(
                        children: [
                          Text(formatterint.format(lowerprice)),
                          /*
                          SizedBox(width: 50,
                              child: TextFormField(controller: txtminpricecontroller,
                                keyboardType: TextInputType.phone,

                                onFieldSubmitted: (String value) {
                                  if(value!=""){
                                    if(double.parse(value)>minprice && double.parse(value)<maxprice && double.parse(value)<upperprice){
                                      lowerprice = double.parse(value);
                                      setState(() {
                                      });
                                    }
                                    else{
                                      lowerprice=minprice;
                                      txtminpricecontroller.text = formatterint.format(minprice);
                                    }
                                  }
                                  else{
                                    lowerprice=minprice;
                                    txtminpricecontroller.text = formatterint.format(minprice);
                                  }
                                },
                              )),
                  */
                          /*
                          RangeSlider(
                              values: values,
                              min: 0,
                              max: 100,
                              labels: labels,
                              divisions: 5,
                              onChanged: (value) {
                                values = value;
                                setState(() {
                                  values = value;
                                  labels =RangeLabels(value.start.toString(), value.end.toString());
                                });
                              }
                          ),
                          */

                          SliderTheme(
                            // Customization of the SliderTheme
                            // based on individual definitions
                            // (see rangeSliders in _RangeSliderSampleState)
                            data: SliderTheme.of(context).copyWith(
                              overlayColor: overlayColor,
                              activeTickMarkColor: activeTickMarkColor,
                              activeTrackColor: activeTrackColor,
                              inactiveTrackColor: inactiveTrackColor,
                              trackHeight: rangebarWidth,
                              //trackHeight: 8.0,
                              thumbColor: thumbColor,
                              valueIndicatorColor: valueIndicatorColor,
                              showValueIndicator: true
                                  ? ShowValueIndicator.always
                                  : ShowValueIndicator.onlyForDiscrete,
                            ),
                            child: Expanded(
                              child: SliderTheme(
                                // Customization of the SliderTheme
                                // based on individual definitions
                                // (see rangeSliders in _RangeSliderSampleState)
                                data: SliderTheme.of(context).copyWith(
                                  overlayColor: overlayColor,
                                  activeTickMarkColor: activeTickMarkColor,
                                  activeTrackColor: activeTrackColor,
                                  inactiveTrackColor: inactiveTrackColor,
                                  trackHeight: rangebarWidth,
                                  //trackHeight: 8.0,
                                  thumbColor: thumbColor,
                                  valueIndicatorColor: valueIndicatorColor,
                                  showValueIndicator: showValueIndicator
                                      ? ShowValueIndicator.always
                                      : ShowValueIndicator.onlyForDiscrete,
                                ),
                                child: frs.RangeSlider(
                                  min: minprice,
                                  max: maxprice,
                                  lowerValue: lowerprice,
                                  upperValue: upperprice,
//                                divisions: divisions,
                                  showValueIndicator: showValueIndicator,
                                  valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                                  onChanged: (double lower, double upper) {
                                    lowerprice = lower;
                                    upperprice = upper;
                                    txtminpricecontroller.text =
                                        formatterint.format(lower);
                                    txtmaxpricecontroller.text =
                                        formatterint.format(upper);
                                    setState(() {

                                    });
                                    // call
                                    //callback(lower, upper);
                                  },
                                ),
                              ),
                            ),
                          ),

                          Text(formatterint.format(upperprice)),
                          /*
                          SizedBox(width: 50,
                              child: TextFormField(controller: txtmaxpricecontroller,
                                keyboardType: TextInputType.phone,

                                onFieldSubmitted: (String value) {
                                  if(value!=""){
                                    if(double.parse(value)>minprice && double.parse(value)<maxprice && double.parse(value)>lowerprice){
                                      upperprice = double.parse(value);
                                      setState(() {
                                      });
                                    }
                                    else{
                                      upperprice=maxprice;
                                      txtmaxpricecontroller.text = formatterint.format(maxprice);
                                    }
                                  }
                                  else{
                                    upperprice=maxprice;
                                    txtmaxpricecontroller.text = formatterint.format(maxprice);
                                  }
                                },
                              )),
                          */
                        ],
                      ),
                    ),
                  )
                ],
              ),
              fValue.maxweight > 0 ? CustomExpansionTile(
                headerBackgroundColor: listbgColor,
                iconColor: Colors.black,
                initiallyExpanded: isExpanded,
                title: Text("Weight Range"),
                children: [
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top:15, bottom: 15),
                      child: Row(
                        children: [
                          Text(formatterint.format(lowerweight)),
                          /*
                          SizedBox(width: 50,
                              child: TextFormField(controller: txtminwtcontroller,
                                keyboardType: TextInputType.phone,

                                onFieldSubmitted: (String value) {
                                  if(value!=""){
                                    if(double.parse(value)>minwt && double.parse(value)<maxwt && double.parse(value)<upperweight){
                                      lowerweight = double.parse(value);
                                      setState(() {
                                      });
                                    }
                                    else{
                                      lowerweight=minwt;
                                      txtminwtcontroller.text = formatterint.format(minwt);
                                    }
                                  }
                                  else{
                                    lowerweight=minwt;
                                    txtminwtcontroller.text = formatterint.format(minwt);
                                  }
                                },
                              )),
                          */
                          SliderTheme(
                            // Customization of the SliderTheme
                            // based on individual definitions
                            // (see rangeSliders in _RangeSliderSampleState)
                            data: SliderTheme.of(context).copyWith(
                              overlayColor: overlayColor,
                              activeTickMarkColor: activeTickMarkColor,
                              activeTrackColor: activeTrackColor,
                              inactiveTrackColor: inactiveTrackColor,
                              trackHeight: rangebarWidth,
                              //trackHeight: 8.0,
                              thumbColor: thumbColor,
                              valueIndicatorColor: valueIndicatorColor,
                              showValueIndicator: true
                                  ? ShowValueIndicator.always
                                  : ShowValueIndicator.onlyForDiscrete,
                            ),
                            child: Expanded(
                              child: SliderTheme(
                                // Customization of the SliderTheme
                                // based on individual definitions
                                // (see rangeSliders in _RangeSliderSampleState)
                                data: SliderTheme.of(context).copyWith(
                                  overlayColor: overlayColor,
                                  activeTickMarkColor: activeTickMarkColor,
                                  activeTrackColor: activeTrackColor,
                                  inactiveTrackColor: inactiveTrackColor,
                                  trackHeight: rangebarWidth,
                                  //trackHeight: 8.0,
                                  thumbColor: thumbColor,
                                  valueIndicatorColor: valueIndicatorColor,
                                  showValueIndicator: showValueIndicator
                                      ? ShowValueIndicator.always
                                      : ShowValueIndicator.onlyForDiscrete,
                                ),
                                child: frs.RangeSlider(
                                  min: minwt,
                                  max: maxwt,
                                  lowerValue: lowerweight,
                                  upperValue: upperweight,
//                                divisions: divisions,
                                  showValueIndicator: showValueIndicator,
                                  valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                                  onChanged: (double lower, double upper) {
                                    lowerweight = lower;
                                    upperweight = upper;
                                    txtminwtcontroller.text =
                                        formatterint.format(lower);
                                    txtmaxwtcontroller.text =
                                        formatterint.format(upper);
                                    setState(() {

                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Text(formatterint.format(upperweight)),
                          /*
                          SizedBox(width: 50,
                              child: TextFormField(controller: txtmaxwtcontroller,
                                keyboardType: TextInputType.phone,

                                onFieldSubmitted: (String value) {
                                  if(value!=""){
                                    if(double.parse(value)>minwt && double.parse(value)<maxwt && double.parse(value)>lowerweight){
                                      upperweight = double.parse(value);
                                      setState(() {
                                      });
                                    }
                                    else{
                                      upperweight=maxwt;
                                      txtmaxwtcontroller.text = formatterint.format(maxwt);
                                    }
                                  }
                                  else{
                                    upperweight=maxwt;
                                    txtmaxwtcontroller.text = formatterint.format(maxwt);
                                  }
                                },
                              )),
                          */
                        ],
                      ),
                    ),
                  )
                ],
              ) :
              Container(),
            ],
          ),
        ),
      ),
    );
  }

  void reset_Click(){
    fValue = new FilterValue();
    fValue = mValue;
    for(int i=0;i<fValue.group.length;i++){
      fValue.group[i].isChecked=false;
    }
    for(int i=0;i<fValue.metal.length;i++){
      fValue.metal[i].isChecked=false;
    }
    for(int i=0;i<fValue.brand.length;i++){
      fValue.brand[i].isChecked=false;
    }
    for(int i=0;i<fValue.design.length;i++){
      fValue.design[i].isChecked=false;
    }
    for(int i=0;i<fValue.discount.length;i++){
      fValue.discount[i].isChecked=false;
    }
    minprice = fValue.minprice;
    maxprice = fValue.maxprice;
    minwt = fValue.minweight;
    maxwt = fValue.maxweight;
    lowerprice = fValue.minprice;
    upperprice = fValue.maxprice;
    lowerweight = fValue.minweight;
    upperweight = fValue.maxweight;
    txtminpricecontroller.text = formatterint.format(lowerprice);
    txtmaxpricecontroller.text = formatterint.format(upperprice);
    txtminwtcontroller.text = formatterint.format(lowerweight);
    txtmaxwtcontroller.text = formatterint.format(upperweight);

    setState(() {

    });
  }
  void apply_Click(){
    FilterValue temp = new FilterValue();
    List<FilterSelValue> items = new List<FilterSelValue>();
    for (var i = 0; i<fValue.metal.length; i++){
      if(fValue.metal[i].isChecked){
        items.add(fValue.metal[i]);
      }
    }
    temp.metal = items;
    items = new List<FilterSelValue>();
    for (var i = 0; i<fValue.brand.length; i++){
      if(fValue.brand[i].isChecked){
        items.add(fValue.brand[i]);
      }
    }
    temp.brand = items;
    items = new List<FilterSelValue>();
    for (var i = 0; i<fValue.group.length; i++){
      if(fValue.group[i].isChecked){
        items.add(fValue.group[i]);
      }
    }
    temp.group = items;

    temp.design = items;
    items = new List<FilterSelValue>();
    for (var i = 0; i<fValue.design.length; i++){
      if(fValue.design[i].isChecked){
        items.add(fValue.design[i]);
      }
    }
    temp.design = items;

    temp.jewelSize = items;
    items = new List<FilterSelValue>();
    for (var i = 0; i<fValue.jewelSize.length; i++){
      if(fValue.jewelSize[i].isChecked){
        items.add(fValue.jewelSize[i]);
      }
    }
    temp.jewelSize = items;

    items = new List<FilterSelValue>();
    for (var i = 0; i<fValue.discount.length; i++){
      if(fValue.discount[i].isChecked){
        items.add(fValue.discount[i]);
      }
    }
    temp.discount = items;

    mValue.minprice != lowerprice ? temp.minprice = lowerprice : temp.minprice = null;
    mValue.maxprice != upperprice ? temp.maxprice = upperprice : temp.maxprice = null;
    mValue.minweight != lowerweight ? temp.minweight = lowerweight : temp.minweight = null;
    mValue.maxweight != upperweight ? temp.maxweight = upperweight : temp.maxweight = null;
    getFilterProductData(temp);
    //Navigator.pop(context, temp);
  }
  void showFilter(String _source) {
    source = _source;
    setState(() {

    });
  }

  Widget FilterWidgetValue(){
    final screenSize = MediaQuery
        .of(context)
        .size;
    if(source == "groupName") {
      return Container(
          width: screenSize.width - 143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fValue.group.length,
                itemBuilder: (BuildContext context, int index) =>
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: buttonShadowColor,
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: buttonShadowColor,
                                    value: fValue.group[index].isChecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        fValue.group[index].isChecked = value;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                                Text(toBeginningOfSentenceCase(fValue
                                    .group[index].value.toLowerCase()),),
                              ],
                            ),
                          ),

                        ))),
          ));
    }
    else if(source == "metalType"){
      return  Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fValue.metal.length,
                itemBuilder: (BuildContext context, int index) =>
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: buttonShadowColor,
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: buttonShadowColor,
                                    value: fValue.metal[index].isChecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        fValue.metal[index].isChecked = value;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),

                                Text(fValue.metal[index].value,),
                              ],
                            ),
                          ),

                        ))),
          ));
    }
    else if(source == "brand"){
      return  Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: fValue.brand.length > 0 ? new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fValue.brand.length,
                itemBuilder: (BuildContext context, int index) =>
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: buttonShadowColor,
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: buttonShadowColor,
                                    value: fValue.brand[index].isChecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        fValue.brand[index].isChecked = value;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),

                                Text(fValue.brand[index].value,),
                              ],
                            ),
                          ),

                        )))
                : Container(),
          ));
    }
    else if(source == "design"){
      return  Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: fValue.design.length > 0 ? new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fValue.design.length,
                itemBuilder: (BuildContext context, int index) =>
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: buttonShadowColor,
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: buttonShadowColor,
                                    value: fValue.design[index].isChecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        fValue.design[index].isChecked = value;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                      fValue.design[index].value3,
                                    ),
                                    height: 75,
                                    fit: BoxFit.fitHeight,
                                  ),
                                    onTap: (){
                                      fValue.design[index].isChecked = fValue.design[index].isChecked == true ? false : true;
                                      setState(() {});
                                    }
                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left:8.0),
//                                  child: Text(fValue.design[index].value,),
//                                ),
                              ],
                            ),
                          ),

                        )))
                : Container(),
          ));
    }
    else if(source == "discount"){
      return  Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fValue.discount.length,
                itemBuilder: (BuildContext context, int index) =>
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: buttonShadowColor,
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: buttonShadowColor,
                                    value: fValue.discount[index].isChecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        fValue.discount[index].isChecked = value;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),

                                Text(fValue.discount[index].value,),
                              ],
                            ),
                          ),

                        ))),
          ));
    }
    else if(source == "jewelSize"){
      return  Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: fValue.jewelSize.length > 0 ? new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fValue.jewelSize.length,
                itemBuilder: (BuildContext context, int index) =>
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: buttonShadowColor,
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: buttonShadowColor,
                                    value: fValue.jewelSize[index].isChecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        fValue.jewelSize[index].isChecked = value;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),

                                Text(fValue.jewelSize[index].value,),
                              ],
                            ),
                          ),

                        )))
                : Container(),
          ));
    }
    else if(source == "price") {
      return Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: new ListView(
                children: [
                  Container(
                    width: screenSize.width-143,
                    height: 120,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formatterint.format(lowerprice)),
                              Text(formatterint.format(upperprice)),
                            ],
                          ),
                        ),

                        SliderTheme(
                          // Customization of the SliderTheme
                          // based on individual definitions
                          // (see rangeSliders in _RangeSliderSampleState)
                          data: SliderTheme.of(context).copyWith(
                            overlayColor: overlayColor,
                            activeTickMarkColor: activeTickMarkColor,
                            activeTrackColor: activeTrackColor,
                            inactiveTrackColor: inactiveTrackColor,
                            trackHeight: rangebarWidth,
                            //trackHeight: 8.0,
                            thumbColor: thumbColor,
                            valueIndicatorColor: valueIndicatorColor,
                            showValueIndicator: true
                                ? ShowValueIndicator.always
                                : ShowValueIndicator.onlyForDiscrete,
                          ),
                          child: Expanded(
                            child: SliderTheme(
                              // Customization of the SliderTheme
                              // based on individual definitions
                              // (see rangeSliders in _RangeSliderSampleState)
                              data: SliderTheme.of(context).copyWith(
                                overlayColor: overlayColor,
                                activeTickMarkColor: activeTickMarkColor,
                                activeTrackColor: activeTrackColor,
                                inactiveTrackColor: inactiveTrackColor,
                                trackHeight: rangebarWidth,
                                //trackHeight: 8.0,
                                thumbColor: thumbColor,
                                valueIndicatorColor: valueIndicatorColor,
                                showValueIndicator: showValueIndicator
                                    ? ShowValueIndicator.always
                                    : ShowValueIndicator.onlyForDiscrete,
                              ),
                              child: frs.RangeSlider(
                                min: minprice,
                                max: maxprice,
                                lowerValue: lowerprice,
                                upperValue: upperprice,
//                                divisions: divisions,
                                showValueIndicator: showValueIndicator,
                                valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                                onChanged: (double lower, double upper) {
                                  lowerprice = lower;
                                  upperprice = upper;
                                  txtminpricecontroller.text =
                                      formatterint.format(lower);
                                  txtmaxpricecontroller.text =
                                      formatterint.format(upper);
                                  setState(() {

                                  });
                                  // call
                                  //callback(lower, upper);
                                },
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              )
          )
          );
    }
    else if(source == "weight"){
      return Container(
          width: screenSize.width-143,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: new ListView(
                  children: [
                    Container(
                      width: screenSize.width-143,
                      height: 120,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formatterint.format(lowerweight)),
                                Text(formatterint.format(upperweight)),
                              ],
                            ),
                          ),

                          SliderTheme(
                            // Customization of the SliderTheme
                            // based on individual definitions
                            // (see rangeSliders in _RangeSliderSampleState)
                            data: SliderTheme.of(context).copyWith(
                              overlayColor: overlayColor,
                              activeTickMarkColor: activeTickMarkColor,
                              activeTrackColor: activeTrackColor,
                              inactiveTrackColor: inactiveTrackColor,
                              trackHeight: rangebarWidth,
                              //trackHeight: 8.0,
                              thumbColor: thumbColor,
                              valueIndicatorColor: valueIndicatorColor,
                              showValueIndicator: true
                                  ? ShowValueIndicator.always
                                  : ShowValueIndicator.onlyForDiscrete,
                            ),
                            child: Expanded(
                              child: SliderTheme(
                                // Customization of the SliderTheme
                                // based on individual definitions
                                // (see rangeSliders in _RangeSliderSampleState)
                                data: SliderTheme.of(context).copyWith(
                                  overlayColor: overlayColor,
                                  activeTickMarkColor: activeTickMarkColor,
                                  activeTrackColor: activeTrackColor,
                                  inactiveTrackColor: inactiveTrackColor,
                                  trackHeight: rangebarWidth,
                                  //trackHeight: 8.0,
                                  thumbColor: thumbColor,
                                  valueIndicatorColor: valueIndicatorColor,
                                  showValueIndicator: showValueIndicator
                                      ? ShowValueIndicator.always
                                      : ShowValueIndicator.onlyForDiscrete,
                                ),
                                child: frs.RangeSlider(
                                  min: minwt,
                                  max: maxwt,
                                  lowerValue: lowerweight,
                                  upperValue: upperweight,
//                                divisions: divisions,
                                  showValueIndicator: showValueIndicator,
                                  valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                                  onChanged: (double lower, double upper) {
                                    lowerweight = lower;
                                    upperweight = upper;
                                    txtminwtcontroller.text =
                                        formatterint.format(lower);
                                    txtmaxwtcontroller.text =
                                        formatterint.format(upper);
                                    setState(() {

                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
              )
          )
      );
    }
    else if(source == "price2"){
      return Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
          Container(
            width: screenSize.width-143,
            height: 120,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatterint.format(lowerprice)),
                      Text(formatterint.format(upperprice)),
                    ],
                  ),
                ),

                SliderTheme(
                  // Customization of the SliderTheme
                  // based on individual definitions
                  // (see rangeSliders in _RangeSliderSampleState)
                  data: SliderTheme.of(context).copyWith(
                    overlayColor: overlayColor,
                    activeTickMarkColor: activeTickMarkColor,
                    activeTrackColor: activeTrackColor,
                    inactiveTrackColor: inactiveTrackColor,
                    trackHeight: rangebarWidth,
                    //trackHeight: 8.0,
                    thumbColor: thumbColor,
                    valueIndicatorColor: valueIndicatorColor,
                    showValueIndicator: true
                        ? ShowValueIndicator.always
                        : ShowValueIndicator.onlyForDiscrete,
                  ),
                  child: Expanded(
                    child: SliderTheme(
                      // Customization of the SliderTheme
                      // based on individual definitions
                      // (see rangeSliders in _RangeSliderSampleState)
                      data: SliderTheme.of(context).copyWith(
                        overlayColor: overlayColor,
                        activeTickMarkColor: activeTickMarkColor,
                        activeTrackColor: activeTrackColor,
                        inactiveTrackColor: inactiveTrackColor,
                        trackHeight: rangebarWidth,
                        //trackHeight: 8.0,
                        thumbColor: thumbColor,
                        valueIndicatorColor: valueIndicatorColor,
                        showValueIndicator: showValueIndicator
                            ? ShowValueIndicator.always
                            : ShowValueIndicator.onlyForDiscrete,
                      ),
                      child: frs.RangeSlider(
                        min: minprice,
                        max: maxprice,
                        lowerValue: lowerprice,
                        upperValue: upperprice,
//                                divisions: divisions,
                        showValueIndicator: showValueIndicator,
                        valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                        onChanged: (double lower, double upper) {
                          lowerprice = lower;
                          upperprice = upper;
                          txtminpricecontroller.text =
                              formatterint.format(lower);
                          txtmaxpricecontroller.text =
                              formatterint.format(upper);
                          setState(() {

                          });
                          // call
                          //callback(lower, upper);
                        },
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(color: Colors.white,)
        ),
          ]
        ),
      );
    }
    else if(source == "weight2"){
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: screenSize.width-143,
          height: 120,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatterint.format(lowerweight)),
                    Text(formatterint.format(upperweight)),
                  ],
                ),
              ),

              SliderTheme(
                // Customization of the SliderTheme
                // based on individual definitions
                // (see rangeSliders in _RangeSliderSampleState)
                data: SliderTheme.of(context).copyWith(
                  overlayColor: overlayColor,
                  activeTickMarkColor: activeTickMarkColor,
                  activeTrackColor: activeTrackColor,
                  inactiveTrackColor: inactiveTrackColor,
                  trackHeight: rangebarWidth,
                  //trackHeight: 8.0,
                  thumbColor: thumbColor,
                  valueIndicatorColor: valueIndicatorColor,
                  showValueIndicator: true
                      ? ShowValueIndicator.always
                      : ShowValueIndicator.onlyForDiscrete,
                ),
                child: Expanded(
                  child: SliderTheme(
                    // Customization of the SliderTheme
                    // based on individual definitions
                    // (see rangeSliders in _RangeSliderSampleState)
                    data: SliderTheme.of(context).copyWith(
                      overlayColor: overlayColor,
                      activeTickMarkColor: activeTickMarkColor,
                      activeTrackColor: activeTrackColor,
                      inactiveTrackColor: inactiveTrackColor,
                      trackHeight: rangebarWidth,
                      //trackHeight: 8.0,
                      thumbColor: thumbColor,
                      valueIndicatorColor: valueIndicatorColor,
                      showValueIndicator: showValueIndicator
                          ? ShowValueIndicator.always
                          : ShowValueIndicator.onlyForDiscrete,
                    ),
                    child: frs.RangeSlider(
                      min: minwt,
                      max: maxwt,
                      lowerValue: lowerweight,
                      upperValue: upperweight,
//                                divisions: divisions,
                      showValueIndicator: showValueIndicator,
                      valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                      onChanged: (double lower, double upper) {
                        lowerweight = lower;
                        upperweight = upper;
                        txtminwtcontroller.text =
                            formatterint.format(lower);
                        txtmaxwtcontroller.text =
                            formatterint.format(upper);
                        setState(() {

                        });
                      },
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }

    else
      Container(
          width: screenSize.width-133,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFe2e8ec),
              width: 1,
            ),
            //borderRadius: BorderRadius.circular(12),
          ),
          child: new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: fValue.group.length,
              itemBuilder: (BuildContext context, int index) =>
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Checkbox(
                                value: fValue.group[index].isChecked,
                                onChanged: (bool value) {
                                  fValue.group[index].isChecked = value;
                                  setState(() {});
                                },
                              ),
                              Text(fValue.group[index].value,),
                            ],
                          ),
                        ),

                      ))));
  }

  Widget FilterWidget(){
    final screenSize = MediaQuery
        .of(context)
        .size;

    return  Flexible(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0, 1],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  primary1Color,
                  Colors.white
                ],
              ),
            ),
          ),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 7.0, right: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: screenSize.height-110,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Color(0xFFE6E6E6),
                    border: Border.all(
                      color: Color(0xFFe2e8ec),
                      width: 1,
                    ),
                    //borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        fValue.group.length>0 ? Material(
                          color: source == "groupName" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("groupName");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Product Type",
                                      style: TextStyle(color: source == "groupName" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                            : Container(),
                        fValue.group.length>0 ? SizedBox(height: 5,)
                            : Container(),
                        fValue.metal.length>0 ? Material(
                          color: source == "metalType" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("metalType");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Metal Type",
                                      style: TextStyle(color: source == "metalType" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                            : Container(),
                        fValue.metal.length>0 ? SizedBox(height: 5,)
                            : Container(),
                        fValue.brand.length>0 ? Material(
                          color: source == "brand" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("brand");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Brand",
                                      style: TextStyle(color: source == "brand" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                        : Container(),
                        fValue.brand.length>0 ? SizedBox(height: 5,)
                            : Container(),
                        fValue.design.length>0 ? Material(
                          color: source == "design" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("design");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Design Code",
                                      style: TextStyle(color: source == "design" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                            : Container(),
                        fValue.design.length>0 ? SizedBox(height: 5,)
                            : Container(),
                        fValue.jewelSize.length>0 ? Material(
                          color: source == "jewelSize" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("jewelSize");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Size",
                                      style: TextStyle(color: source == "jewelSize" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                            : Container(),
                        fValue.jewelSize.length>0 ? SizedBox(height: 5,)
                            : Container(),
                        fValue.discount.length > 0 ?  Material(
                          color: source == "discount" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("discount");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Discount",
                                      style: TextStyle(color: source == "discount" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                          : Container(),
                        fValue.discount.length > 0 ?  SizedBox(height: 5,)
                            : Container(),
                        Material(
                          color: source == "price" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("price");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Price Range",
                                      style: TextStyle(color: source == "price" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        fValue.maxweight > 0 ? Material(
                          color: source == "weight" ? buttonShadowColor : Colors.white,
                          child: InkWell(
                            onTap: (){
                              showFilter("weight");
                            },
                            child: Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                                    child: Text("Weight Range",
                                    style: TextStyle(color: source == "weight" ? Colors.white : Colors.black),),
                                  )),
                            ),
                          ),
                        )
                        : Container(),
                        /*
                        RawMaterialButton(
                          fillColor: source == "groupName" ? buttonShadowColor : Colors.white,
                          onPressed:(){
                            showFilter("groupName");
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Product Type"),
                              )),
                        ),
                        RawMaterialButton(
                          fillColor: source == "metalType" ? buttonShadowColor : Colors.white,
                          onPressed:(){
                            showFilter("metalType");
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                                child: Text("Metal Type"),
                              )),
                        ),
                        RawMaterialButton(
                          fillColor: source == "brand" ? buttonShadowColor : Colors.white,
                          onPressed:(){
                            showFilter("brand");
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Brand"),
                              )),
                        ),
                        RawMaterialButton(
                          fillColor: source == "discount" ? buttonShadowColor : Colors.white,
                          onPressed:(){
                            showFilter("discount");
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Discount"),
                              )),
                        ),
                        RawMaterialButton(
                          fillColor: source == "price" ? buttonShadowColor : Colors.white,
                          onPressed:(){
                            showFilter("price");
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Price Range"),
                              )),
                        ),
                        RawMaterialButton(
                          fillColor: source == "weight" ? buttonShadowColor : Colors.white,
                          onPressed:(){
                            showFilter("weight");
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Weight Range"),
                              )),
                        ),
*/
                      ],
                    ),
                  ),
                ),
                FilterWidgetValue(),
              ],

            ),
          ),
        ),
        ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productdt = widget.productdt;
    getFilter();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return MaterialApp(
      title: 'Filter',

      theme: MasterScreen.themeData(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Filter', style: TextStyle(color: Colors.white),),
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, null),
          ),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.home,color: Colors.white,),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//          ],
          backgroundColor: primary1Color,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              //Customtitle2(context, "Filter", stickyKey),
              FilterWidget(),
          ]
        ),
        ),
        bottomNavigationBar: BottomAppBar(

            child: Container(
              height: 50,
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0, 1],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.white,
                    Colors.white
                  ],
                ),
              ),
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
                            color: Color(0xFF509583),
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              reset_Click();
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 1,),
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
                                "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              apply_Click();
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
}

class FilterValue{
  List<FilterSelValue> group=[];
  List<FilterSelValue> metal=[];
  List<FilterSelValue> brand=[];
  List<FilterSelValue> design=[];
  List<FilterSelValue> discount=[];
  List<FilterSelValue> jewelSize=[];

  double minprice;
  double maxprice;
  double minweight;
  double maxweight;
  FilterValue({this.group, this.metal, this.brand, this.design, this.minprice, this.maxweight, this.minweight, this.maxprice});
}
class FilterSelValue{
  bool isChecked;
  String value;
  String value3;
  double value2;
  FilterSelValue({this.isChecked, this.value, this.value2, this.value3});
}