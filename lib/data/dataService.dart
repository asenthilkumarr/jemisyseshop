import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/style.dart';

class DataService {
  //SharedPreferences prefs;

  final Map<String, String> userheaders = {
    "Content-type": "application/json",
    "APIKey": "SkVNaVN5czo1MzU2NDNBVDk4NjU0MzU2"
  };

  Future<List<Country>> GetCountry(String country) async {
    List<Country> result = [];
    http.Response response = await http.get(
      apiurl + "Country/GetCountry?country="+country,
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Country.fromJson(i);
        result.add(iRow);
      }

      return result;
    }
    else {
      return result;
    }
  }
  Future<List<StateList>> GetState(String country) async {
    List<StateList> result = [];
    http.Response response = await http.get(
      apiurl + "Country/GetState?country="+country,
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = StateList.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<City>> GetCity(String country, String state) async {
    List<City> result = [];
    http.Response response = await http.get(
      apiurl + "Country/GetCity?country="+country+"&state="+state,
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = City.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<ReturnResponse> UpdateCart(String mode, List<Cart> param) async {
    ReturnResponse result = new ReturnResponse();
    http.Response response = await http.post(
        apiurl + "Cart/UpdateCart?mode="+mode,
        headers: userheaders,
        body: json.encode(param.map((e) => e.toParam()).toList())
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      result = ReturnResponse.fromData(data);
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<Cart>> GetCart(String eMail, String orderType) async {
    List<Cart> result = [];
    http.Response response = await http.get(
      apiurl + "Cart/GetCart?eMail="+eMail+"&orderType="+orderType,
        headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Cart.fromData(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<GoldRate>> GetGoldSellingRate() async {
    List<GoldRate> result = [];
    http.Response response = await http.get(
      apiurl + "GoldRate/GetGoldSellingRate",
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = GoldRate.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<Setting>> GetSetting() async {
    List<Setting> result = [];
    http.Response response = await http.get(
      apiurl + "Setting/GetSetting",
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Setting.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<DefaultData>> GetDefaultData(DefaultDataParam param) async {
    List<DefaultData> result = [];
    http.Response response = await http.post(
      apiurl + "Setting/GetDefaultData",
      headers: userheaders,
        body: json.encode(param.toParam())
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = DefaultData.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<Product>> GetProductDetails(ProductParam param) async {
    List<Product> result = [];
    http.Response response = await http.post(
        apiurl + "Product/GetProductDetails",
        headers: userheaders,
        body: json.encode(param.toParam())
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Product.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<Product>> GetProduct(ProductParam param) async {
    List<Product> result = [];
    http.Response response = await http.post(
        apiurl + "Product/GetProduct",
        headers: userheaders,
        body: json.encode(param.toParam())
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Product.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<Group>> GetGroup() async {
    List<Group> result = [];
    Group param = Group();
    param.groupName = "*ACTIVE";
    http.Response response = await http.post(
        apiurl + "Group/GetGroup",
        headers: userheaders,
        body: json.encode(param.toJson())
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Group.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<Customer> UpdateCustomer(Customer param) async {
    Customer result;
    http.Response response = await http.post(
        apiurl + "Customer/UpdateCustomer",
        headers: userheaders,
        body: json.encode(param.toParam())
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Customer.fromJson(i);
        result=iRow;
      }
      return result;

    }
    else {
      return result;
      //throw Exception('Failed to load album');
    }
  }
  Future<List<Address>> GetDeliveryAddress(String eMail) async {
    List<Address> result = [];
    http.Response response = await http.get(
      apiurl + "Customer/GetDeliveryAddress?eMail="+eMail,
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Address.fromJson(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<ReturnResponse> UpdateBillingAddress(Address param) async {
    ReturnResponse result;
    http.Response response = await http.post(
        apiurl + "Customer/UpdateBillingAddress",
        headers: userheaders,
        body: json.encode(param.toParam())
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      result = ReturnResponse.fromData(data);

      return result;
    }
    else {
      return result;
      //throw Exception('Failed to load album');
    }
  }
  Future<Customer> GetCustomer(Customer param) async {
    Customer result;
    http.Response response = await http.post(
        apiurl + "Customer/GetCustomer",
        headers: userheaders,
        body: json.encode(param.toParam())
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Customer.fromJson(i);
        result=iRow;
      }
      customerdata = result;
      return result;
    }
    else {
      return result;
      //throw Exception('Failed to load album');
    }
  }
  Future<String> UpdateMember(String mode, Customer param) async {
    String result = "ERROR";
    http.Response response = await http.post(
        apiurl + "Customer/UpdateMember?mode="+mode,
        headers: userheaders,
        body: json.encode(param.toParam())
    );
    if (response.statusCode == 200) {
      result = "OK";
      return result;
    }
    else {
      return result;
      //throw Exception('Failed to load album');
    }
  }

}
