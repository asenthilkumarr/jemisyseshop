import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';

class DataService {
  //SharedPreferences prefs;

  final Map<String, String> userheaders = {
    "Content-type": "application/json",
    "APIKey": "SkVNaVN5czo1MzU2NDNBVDk4NjU0MzU2"
  };

  Future<Points> getPoints(String eMail) async {
    Points result = new Points();
    http.Response response = await http.get(
      apiurlERP + "Customer/GetCustomerPoints?eMail=" + eMail,
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      result = Points.fromJson(data);
      return result;
    }
    else {
      return result;
    }
  }
  Future<ReturnResponse> getCheckStockOnline(String eMail) async {
    ReturnResponse result = new ReturnResponse();
    http.Response response = await http.get(
      apiurlERP + "Product/GetCheckStockOnline?eMail="+eMail,
      headers: userheaders,
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
  Future<ReturnResponse> updateOrder(OrderData param) async {
    ReturnResponse result = new ReturnResponse();
    http.Response response = await http.post(
        apiurl + "Order/UpdateOrder",
        headers: userheaders,
        body: json.encode(param.toParam()),
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
  Future<ReturnResponse> updateOrderSync(String orderNo) async {
    ReturnResponse result = new ReturnResponse();
    http.Response response = await http.post(
      apiurlERP + "Order/UpdateOrderSync?orderNo="+orderNo,
      headers: userheaders,
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
  Future<List<OrderOutstanding>> GetOrderOutstanding(String eMail) async {
    List<OrderOutstanding> result = [];
    http.Response response = await http.get(
      apiurlERP + "Order/GetOrderOutStanding?eMail="+eMail,
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = OrderOutstanding.fromData(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<ReturnResponse> updateOrderOutstanding(OrderUpdateParam param) async {
    ReturnResponse result = new ReturnResponse();
    http.Response response = await http.post(
      apiurlERP + "Order/UpdateOutstandingOrder",
      headers: userheaders,
      body: json.encode(param.toParam()),
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
  Future<List<OrderH>> getOrderH(OrderGetParam param) async {
    List<OrderH> result = new List<OrderH>();
    http.Response response = await http.post(
      apiurl + "Order/GetCustomerOrderH",
      headers: userheaders,
      body: json.encode(param.toParam()),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = OrderH.fromData(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<List<OrderD>> getOrderD(OrderGetParam param) async {
    List<OrderD> result = new List<OrderD>();
    http.Response response = await http.post(
      apiurl + "Order/GetCustomerOrderD",
      headers: userheaders,
      body: json.encode(param.toParam()),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = OrderD.fromData(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
  Future<ReturnResponse> updateCart(String mode, List<Cart> param) async {
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
  Future<List<Cart>> getCart(String eMail, String orderType) async {
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
  Future<List<GoldRate>> getGoldSellingRate() async {
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
  Future<List<Country>> getCountry(String country) async {
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
  Future<List<StateList>> getState(String country) async {
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
  Future<List<City>> getCity(String country, String state) async {
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
  Future<List<Setting>> getSetting() async {
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
  Future<List<DefaultData>> getDefaultData(DefaultDataParam param) async {
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
  Future<List<Product>> getProductDetails(ProductParam param) async {
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
  Future<List<Product>> getProduct(ProductParam param) async {
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
  Future<List<Group>> getGroup() async {
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
  Future<Customer> updateCustomer(Customer param) async {
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
  Future<List<Address>> getDeliveryAddress(String eMail) async {
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
  Future<List<Address>> getBillingAddress(String eMail) async {
    List<Address> result = [];
    http.Response response = await http.get(
      apiurl + "Customer/GetBillingAddress?eMail="+eMail,
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
  Future<ReturnResponse> updateBillingAddress(Address param) async {
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
  Future<Customer> getCustomer(Customer param) async {
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
  Future<String> updateMember(String mode, Customer param) async {
    String result = "ERROR";
    http.Response response = await http.post(
        apiurlERP + "Customer/UpdateMember?mode="+mode,
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
  Future<SendEmail> sendEmailtoCustomer(SendEmail param) async {
    SendEmail result;
    String sparam ='{"param":'+json.encode(param.toParam())+'}';

    http.Response response = await http.post(
        emailapiurl + "SMSeMailService.svc/SendeMailToCustomerInvoice",
        headers: userheaders,
        //ody: json.encode(param.toParam())
        body: sparam
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      result = SendEmail.fromJson(data);
      return result;
    }
    else {
      return result;
      //throw Exception('Failed to load album');
    }
  }
  Future<List<Store>> getStores() async {
    List<Store> result = new List<Store>();
    http.Response response = await http.get(
      apiurl + "Store/GetStore",
      headers: userheaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        var iRow = Store.fromData(i);
        result.add(iRow);
      }
      return result;
    }
    else {
      return result;
    }
  }
}
