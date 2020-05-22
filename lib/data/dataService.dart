import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jemisyseshop/model/dataObject.dart';

class DataService {
  //SharedPreferences prefs;

  final String apiurl = 'http://42.61.99.57/JEMiSyseShopAPI/api/';

  final Map<String, String> userheaders = {
    "Content-type": "application/json",
    "APIKey": "SkVNaVN5czo1MzU2NDNBVDk4NjU0MzU2"
  };

  Future<List<Product>> GetProduct(ProductParam param) async {
    List<Product> result = [];
    print(param.toParam());
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
    param.orderOfDisplay = 0;
    print('GROUP');
    print(param.toJson());
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
}
