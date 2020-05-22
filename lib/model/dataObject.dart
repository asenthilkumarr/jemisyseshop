import 'dart:convert';

final String imageUrl = 'http://42.61.99.57/JEMiSyseShopImage/jewelimages/';

class Product{
  String groupName;
  String designCode;
  int version;
  String metalType;
  bool onSale;
  double listingPrice;
  double onlinePrice;
  double discountPercentage;
  int salesType;
  double weightFrom;
  double weightTo;
  String productType;
  String imageFile1;
  String imageFile2;
  String imageFile3;
  String imageFile4;
  String imageFile5;

  Product({this.groupName, this.designCode, this.version, this.metalType, this.onSale, this.listingPrice,
      this.onlinePrice, this.discountPercentage, this.salesType, this.weightFrom, this.weightTo, this.productType,
      this.imageFile1, this.imageFile2, this.imageFile3, this.imageFile4, this.imageFile5});

  Map<String, dynamic> toJson() => {
    'groupName': groupName,
    'designCode': designCode,
    'version': version,
    'metalType': metalType,
    'onSale': onSale,
    'listingPrice': listingPrice,
    'onlinePrice': onlinePrice,
    'discountPercentage': discountPercentage,
    'salesType': salesType,
    'weightFrom': weightFrom,
    'weightTo': weightTo,
    'productType': productType,
    'imageFile1': imageFile1,
    'imageFile2': imageFile2,
    'imageFile3': imageFile3,
    'imageFile4': imageFile4,
    'imageFile5': imageFile5
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        groupName: json['groupName'],
        designCode: json['designCode'],
        version: json['version'],
        metalType: json['metalType'],
        onSale: json['onSale'] == 0 ? false : true,
        listingPrice: json['listingPrice'],
        onlinePrice: json['onlinePrice'],
        discountPercentage: json['discountPercentage'],
        salesType: json['salesType'],
        weightFrom: json['weightFrom'],
        weightTo: json['weightTo'],
        productType: json['productType'],
        imageFile1: imageUrl + json['imageFile1'],
        imageFile2: imageUrl + json['imageFile2'],
        imageFile3: imageUrl + json['imageFile3'],
        imageFile4: imageUrl + json['imageFile4'],
        imageFile5: imageUrl + json['imageFile5']
    );
  }
}
class ProductParam {
  String productType;
  String filter;
  String where;

  Map<String, dynamic> toParam() =>
      {
        'productType': productType,
        'filter': filter,
        'where': where
      };
}
class Group {
  String groupName;
  String imageFileName;
  int orderOfDisplay;
  Group({this.groupName, this.imageFileName, this.orderOfDisplay});

  Map<String, dynamic> toJson() => {
    'groupName': groupName,
    'imageFileName': imageFileName,
    'orderOfDisplay': orderOfDisplay
  };

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupName: json['groupName'],
      imageFileName: imageUrl + json['imageFileName'],
      orderOfDisplay: json['orderOfDisplay']
    );
  }
}
class Category{
  String categoryCode;
  String description;
  String imageUrl;
  Category(this.categoryCode, this.description, this.imageUrl);
  Map<String, dynamic> toJson() => {
    'categoryCode': categoryCode,
    'description': description,
    'imageUrl': imageUrl
  };
}
class DesignCode{
  String designCode;
  String categoryCode;
  String designName;
  String classCode;
  double tagPrice;
  double grossWeight;
  double goldWeight;
  double goldWeight2;
  String discountCode;
  double promotionPrice;
  bool promotion;
  String imageUrl;
  DesignCode(this.designCode, this.categoryCode, this.designName, this.classCode,
      this.tagPrice, this.grossWeight, this.goldWeight, this.goldWeight2, this.discountCode, this.promotionPrice, this.promotion, this.imageUrl);
}
class ItemMasterList{
  String inventoryCode;
  String description;
  String categoryCode;
  String imageUrl;
  ItemMasterList(this.inventoryCode, this.description, this.categoryCode, this.imageUrl);
  Map<String, dynamic> toJson() =>{
    'inventoryCode': inventoryCode,
    'description': description,
    'categoryCode': categoryCode,
    'imageUrl': imageUrl
  };
}
class Country{
  String name;
  String shortCode;
  String currency;
  String imageUrl;
  Country(this.name, this.shortCode, this.currency, this.imageUrl);
}