import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';
import 'package:jemisyseshop/widget/expansionTile.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class FilterValue{
  List<FilterSelValue> group=[];
  List<FilterSelValue> metal=[];
  List<FilterSelValue> brand=[];
  List<FilterSelValue> discount=[];

  double minprice;
  double maxprice;
  double minweight;
  double maxweight;
  FilterValue({this.group, this.metal, this.brand, this.minprice, this.maxweight, this.minweight, this.maxprice});
}
class FilterSelValue{
  bool isChecked;
  String value;
  double value2;
  FilterSelValue({this.isChecked, this.value, this.value2});
}
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
  var isExpanded = true;

  List<String> _group;
  List<String> _metal;
  List<String> _brand;
  List<double> _price;
  List<double> _weight;

  RangeValues values = RangeValues(0, 100);
  RangeLabels labels = RangeLabels("0", "100");

  List<FilterSelValue> getGroup() {
    List<FilterSelValue> dList = new List<FilterSelValue>();
    var col0 = widget.productdt.map<String>((row) => row.groupName).toList(growable: false);
    var grouplist = col0.toSet().toList();
    for(var i in grouplist){
      dList.add(FilterSelValue(isChecked: false, value: i, value2: null));
    }
    return dList;
  }
  List<String> getFilterBrands(){
    var col0 = widget.productdt.map<String>((row) => row.brand).toList(growable: false);
    var brand = col0.toSet().toList();
    return brand;
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
  List<String> getFilterMetalType(){
    var col0 = widget.productdt.map<String>((row) => row.metalType).toList(growable: false);
    var metalType = col0.toSet().toList();
    return metalType;
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
    FilterSelValue item;
    List<FilterSelValue> items = List<FilterSelValue>();
    _metal = getFilterMetalType();
    _brand = getFilterBrands();
    _price=  getFilterPricerange();
    _weight = getFilterWeightrange();

    result.minprice = _price[0];
    result.maxprice = _price[1];
    result.minweight = _weight[0];
    result.maxweight = _weight[1];

    for (var i in _metal) {
      if (i != "") {
        item = new FilterSelValue(isChecked: false, value: i);
        items.add(item);
      }
    }
    result.metal = items;

    items = List<FilterSelValue>();
    for (var i in _brand) {
      if (i != "") {
        item = new FilterSelValue(isChecked: false, value: i);
        items.add(item);
      }
    }
    result.brand = items;
    result.discount = getFilterDiscount();
    result.group = getGroup();

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
  Widget filterWidget() {
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
              fValue.group.length > 0 ? ExpansionTile(
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
                              print(gValue.metal[i].isChecked);
                            },
                          ),
                          */
                        )),
                ],
              )
              : Container(),
              CustomExpansionTile(
                  headerBackgroundColor: Colors.black,
                  iconColor: Colors.white,
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
                              print(gValue.metal[i].isChecked);
                            },
                          ),
                          */
                        )),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: isExpanded,
                title: Text("Metal Type"),
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
                              print(gValue.metal[i].isChecked);
                            },
                          ),
                          */
                        )),
                ],
              ),
              ExpansionTile(
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
              fValue.discount.length > 0 ? ExpansionTile(
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

              ExpansionTile(
                initiallyExpanded: isExpanded,
                title: Text("Price Range"),
                children: [
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20),
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
              fValue.maxweight > 0 ? ExpansionTile(
                initiallyExpanded: isExpanded,
                title: Text("Weight Range"),
                children: [
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20),
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
    for(int i=0;i<fValue.metal.length;i++){
      fValue.metal[i].isChecked=false;
    }
    for(int i=0;i<fValue.brand.length;i++){
      fValue.brand[i].isChecked=false;
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

  @override
  void initState() {
    super.initState();
    productdt = widget.productdt;
    getFilter();
//    mValue = widget.fValue;
//    fValue = widget.fValue;
//    minprice = fValue.minprice;
//    maxprice = fValue.maxprice;
//    minwt = fValue.minweight;
//    maxwt = fValue.maxweight;
//    lowerprice = fValue.minprice;
//    upperprice = fValue.maxprice;
//    lowerweight = fValue.minweight;
//    upperweight = fValue.maxweight;
//    txtminpricecontroller.text = formatterint.format(lowerprice);
//    txtmaxpricecontroller.text = formatterint.format(upperprice);
//    txtminwtcontroller.text = formatterint.format(lowerweight);
//    txtmaxwtcontroller.text = formatterint.format(upperweight);
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

      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme
              .of(context)
              .textTheme,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
//              decoration: BoxDecoration(
//                  color: Colors.white,
//                  border: Border.all(color: listbgColor,
//                    width: 2
//                  )
//              ),
              child: Column(
                  children: [
                    Customtitle(context, "Filter"),
                    filterWidget(),
                  ]
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(

            child: Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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