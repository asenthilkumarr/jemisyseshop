import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/widget/titleBar.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class FilterValue{
  List<FilterSelValue> metal=[];
  List<FilterSelValue> brand=[];
  double minprice;
  double maxprice;
  double minweight;
  double maxweight;
  FilterValue({this.metal, this.brand, this.minprice, this.maxweight, this.minweight, this.maxprice});
}
class FilterSelValue{
  bool isChecked;
  String value;
  FilterSelValue({this.isChecked, this.value});
}
class FilterPage extends StatefulWidget{
  final FilterValue fValue;
  FilterPage({this.fValue});

  @override
  _filterPage createState() => _filterPage();
}
class _filterPage extends State<FilterPage> {

  double minprice = 0;
  double maxprice = 100;
  double minwt = 0;
  double maxwt = 50;
  double lowerprice=0;
  double upperprice=100;
  double lowerweight=0;
  double upperweight=100;
  int divisions=10;
  bool showValueIndicator = true;
  int valueIndicatorMaxDecimals =1;
  bool forceValueIndicator =true;
  Color overlayColor=Color(0xFF1C2852); //move icon color
  Color activeTrackColor=Color(0xFFFFC300); // select value
  Color inactiveTrackColor=Color(0xFFB1B6B1); // bar color
  Color thumbColor=Colors.green;
  Color valueIndicatorColor = Colors.blue;
  Color activeTickMarkColor = Colors.black;

  List<FilterSelValue> selMetal=[];
  bool flagWarranty=true;
  FilterValue gValue;
  double rangebarWidth = 20;

  TextEditingController txtminpricecontroller = new TextEditingController();
  TextEditingController txtmaxpricecontroller = new TextEditingController();
  TextEditingController txtminwtcontroller = new TextEditingController();
  TextEditingController txtmaxwtcontroller = new TextEditingController();
  var isExpanded = true;

  _onExpansionChanged(bool val) {
    setState(() {
      isExpanded = isExpanded;
    });
  }

  RangeValues values = RangeValues(0,100);
  RangeLabels labels = RangeLabels("0", "100");
  Widget filterWidget() {


    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpansionTile(
              initiallyExpanded: isExpanded,
              title: Text("Metal Type"),
              children: [
                for(int i=0;i< gValue.metal.length;i++)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:0.0),
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Checkbox(
                                value: gValue.metal[i].isChecked,
                                onChanged: (bool value) {
                                  gValue.metal[i].isChecked=value;
                                  setState((
                                      ) {
                                  });
                                },
                              ),
                              Text(gValue.metal[i].value,),
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
                for(int i=0;i< gValue.brand.length;i++)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left:0.0),

                        child: SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Checkbox(
                                value: gValue.brand[i].isChecked,
                                onChanged: (bool value) {
                                  gValue.brand[i].isChecked=value;
                                  setState((
                                      ) {
                                  });
                                },
                              ),
                              Text(gValue.brand[i].value,),
                            ],
                          ),
                        ),
                  )),
              ],
            ),

            ExpansionTile(
              initiallyExpanded: isExpanded,
              title: Text("Price Range"),
              children: [
                Container(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left:20.0, right: 20.0, bottom: 20),
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
                        /*
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
                                  txtminpricecontroller.text = formatterint.format(lower);
                                  txtmaxpricecontroller.text = formatterint.format(upper);
                                  setState(() {

                                  });
                                  // call
                                  //callback(lower, upper);
                                },
                              ),
                            ),
                          ),
                        ),
                        */
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
            widget.fValue.maxweight>0 ? ExpansionTile(
              initiallyExpanded: isExpanded,
              title: Text("Weight Range"),
              children: [
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left:20.0, right: 20.0, bottom: 20),
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
                                  txtminwtcontroller.text = formatterint.format(lower);
                                  txtmaxwtcontroller.text = formatterint.format(upper);
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
    );
  }
  @override
  void initState() {
    super.initState();
    gValue = widget.fValue;
    minprice = gValue.minprice;
    maxprice = gValue.maxprice;
    minwt = gValue.minweight;
    maxwt = gValue.maxweight;
    lowerprice = gValue.minprice;
    upperprice = gValue.maxprice;
    lowerweight = gValue.minweight;
    upperweight = gValue.maxweight;
    txtminpricecontroller.text = formatterint.format(lowerprice);
    txtmaxpricecontroller.text = formatterint.format(upperprice);
    txtminwtcontroller.text = formatterint.format(lowerweight);
    txtmaxwtcontroller.text = formatterint.format(upperweight);
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
              color: Colors.white,
              child: Column(
                  children: [
                    Customtitle(context, "Filter"),
                    filterWidget(),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}