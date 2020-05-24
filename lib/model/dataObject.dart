import 'dart:convert';

import 'package:jemisyseshop/model/common.dart';


class Product {
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
  String itemCode;
  double tax;
  double sellRate;
  double goldWeight;
  double labourPrice;
  String designName;
  String brand;
  String shortDescription;
  String description;
  int shippingDays;
  String labelLine1;
  String labelLine2;
  String labelLine3;
  String labelLine4;
  String labelLine5;
  int noOfImages;
  bool isShowEvenIfStockIsNull;
  int quantity;

  Product(
      {this.groupName, this.designCode, this.version, this.metalType, this.onSale, this.listingPrice,
        this.onlinePrice, this.discountPercentage, this.salesType, this.weightFrom, this.weightTo, this.productType,
        this.imageFile1, this.imageFile2, this.imageFile3, this.imageFile4, this.imageFile5,
        this.itemCode, this.tax, this.sellRate, this.goldWeight, this.labourPrice, this.designName, this.brand,
        this.shortDescription, this.description, this.shippingDays, this.labelLine1, this.labelLine2, this.labelLine3, this.labelLine4, this.labelLine5,
        this.noOfImages, this.isShowEvenIfStockIsNull});

  Map<String, dynamic> toJson() =>
      {
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
      imageFile1: json['imageFile1'] != "" ? imageUrl + json['imageFile1'] : json['imageFile1'],
      imageFile2: json['imageFile2'] != "" ? imageUrl + json['imageFile2'] : json['imageFile2'],
      imageFile3: json['imageFile3'] != "" ? imageUrl + json['imageFile3'] : json['imageFile3'],
      imageFile4: json['imageFile4'] != "" ? imageUrl + json['imageFile4'] : json['imageFile4'],
      imageFile5: json['imageFile5'] != "" ? imageUrl + json['imageFile5'] : json['imageFile5'],
      itemCode: json['itemCode'],
      tax: json['tax'].toDouble(),
      sellRate: json['sellRate'].toDouble(),
      goldWeight: json['goldWeight'].toDouble(),
      labourPrice: json['labourPrice'].toDouble(),
      designName: json['designName'],
      brand: json['brand'],
      shortDescription: json['shortDescription'],
      description: json['description'],
      shippingDays: json['shippingDays'],
      labelLine1: json['labelLine1'],
      labelLine2: json['labelLine2'],
      labelLine3: json['labelLine3'],
      labelLine4: json['labelLine4'],
      labelLine5: json['labelLine5'],
      noOfImages: json['noOfImages'],
      isShowEvenIfStockIsNull: json['isShowEvenIfStockIsNull'] == 0
          ? false
          : true,
    );
  }
}
class ProductParam {
  String productType;
  String filterType;
  String filter;
  String where;
  String designCode;
  int version;

  Map<String, dynamic> toParam() =>
      {
        'productType': productType,
        'filterType': filterType,
        'filter': filter,
        'where': where,
        'designCode': designCode,
        'version': version == null ? 0 : version,
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
    'orderOfDisplay': orderOfDisplay == null ? 0 : orderOfDisplay,
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