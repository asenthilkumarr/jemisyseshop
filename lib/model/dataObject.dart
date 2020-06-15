import 'package:jemisyseshop/model/common.dart';

class ReturnResponse{
  String returnStatus;
  String errorMessage;
  int status;
  String value;
  ReturnResponse({this.status, this.returnStatus, this.errorMessage, this.value});
  factory ReturnResponse.fromData(Map<String, dynamic> json){
    return ReturnResponse(
      returnStatus: json['returnStatus'],
      errorMessage: json['errorMessage'],
      status: json['status'],
      value: json['value']
    );
  }
}
class Cart{
  String eMail;
  int recordNo;
  String macID;
  String designCode;
  int version;
  String itemCode;
  String onlineName;
  String description;
  int qty;
  String jewelSize;
  double unitPrice;
  double totalPrice;
  int shippingDays;
  bool isSizeCanChange;
  String orderType;
  String imageFileName;
  DateTime createdDate;

  Cart({this.eMail, this.recordNo, this.macID, this.designCode, this.version, this.itemCode, this.onlineName,
  this.description, this.qty, this.jewelSize, this.unitPrice, this.totalPrice, this.shippingDays, this.isSizeCanChange, this.orderType,
    this.imageFileName, this.createdDate});

  factory Cart.fromData(Map<String, dynamic> json){
    return Cart(
      eMail: json['eMail'],
      recordNo: json['recordNo'],
      macID: json['macID'],
      designCode: json['designCode'],
        version: json['version'],
        itemCode: json['inventoryCode'],
      onlineName: json['onlineName'],
      description: json['description'],
      qty: json['qty'],
      jewelSize: json['jewelSize'].toString() == "" ? "15" : json['jewelSize'],
      unitPrice: json['unitPrice'],
      totalPrice: json['totalPrice'],
      orderType: json['orderType'],
        imageFileName: json['imageFileName'] != "" ? imageUrl + json['imageFileName'] : json['imageFileName'],
        isSizeCanChange: json['isSizeCanChange'] == 0 ? false : true,
      shippingDays: json['shippingDays'],
      createdDate: DateTime.parse(json['createdDate'])
    );
  }

  Map<String, dynamic> toParam() =>{
    'eMail':eMail,
    'recordNo': recordNo,
    'macID': macID,
    'designCode':designCode,
    'version' :version,
    'inventoryCode':itemCode != ""? itemCode : null,
    'description':description,
    'qty':qty,
    'jewelSize':jewelSize,
    'unitPrice':unitPrice,
    'totalPrice':totalPrice,
    'shippingDays':shippingDays,
    'isSizeCanChange': isSizeCanChange == true ? 1 : 0,
    'orderType':orderType,
  };
}
class GoldRate {
  String goldType;
  double buyRate;
  double sellRate;
  DateTime lastUpdated;

  GoldRate({ this.goldType, this.buyRate, this.sellRate, this.lastUpdated});

  factory GoldRate.fromJson(Map<String, dynamic> json) {
    return GoldRate(
      goldType: json['goldType'],
      buyRate: json['buyRate'],
      sellRate: json['sellRate'],
      //lastUpdated: json['lastUpdated'],
    );
  }
}
class DefaultData {
  String docType;
  String title;
  String imageFileName;
  String procedureName;

  DefaultData(
      { this.docType, this.title, this.imageFileName, this.procedureName});

  factory DefaultData.fromJson(Map<String, dynamic> json) {
    return DefaultData(
      docType: json['docType'],
      title: json['title'],
      imageFileName: bannerimageUrl + json['imageFileName'],
      procedureName: json['procedureName'],
    );
  }
}
class DefaultDataParam {
  String docType;
  String mode;
  Map<String, dynamic> toParam() =>
      {
        'docType': docType,
        'mode': mode,
      };
}
class Setting {
  String appName;
  String currCode;
  String message;
  String startupImageName;
  String imageFolderName;
  String fontName;
  bool isBackendJEMiSys;

  Setting({ this.appName, this.currCode, this.startupImageName, this.imageFolderName, this.fontName, this.message, this.isBackendJEMiSys});

  factory Setting.fromJson(Map<String, dynamic> json) {
    imgFolderName = json['imageFolderName'];
    imageUrl = imageDefaultUrl + imgFolderName+"/JewelImages/";
    startupimageUrl = imageDefaultUrl + imgFolderName+"/Startup/";
    bannerimageUrl = imageDefaultUrl + imgFolderName+"/Banner/";
    return Setting(
      appName: json['appName'],
      currCode: json['currCode'],
      message: json['message'],
      startupImageName: startupimageUrl+json['startupImageName'],
      imageFolderName: json['imageFolderName'],
      fontName: json['fontName'],
      isBackendJEMiSys: json['isBackendJEMiSys'] == 1 ? true : false
    );
  }
}

class Product {
  String groupName;
  String onlineName;
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
  int qtyOnHand;
  String designName;
  String brand;
  String jewelSize;
  String jewelLength;
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
  bool homeTryOn;

  Product(
      {this.groupName, this.onlineName, this.designCode, this.version, this.metalType, this.onSale, this.listingPrice,
        this.onlinePrice, this.discountPercentage, this.salesType, this.weightFrom, this.weightTo, this.productType,
        this.imageFile1, this.imageFile2, this.imageFile3, this.imageFile4, this.imageFile5,
        this.itemCode, this.tax, this.sellRate, this.goldWeight, this.labourPrice, this.qtyOnHand, this.designName, this.brand, this.jewelSize, this.jewelLength,
        this.shortDescription, this.description, this.shippingDays, this.labelLine1, this.labelLine2, this.labelLine3, this.labelLine4, this.labelLine5,
        this.noOfImages, this.isShowEvenIfStockIsNull, this.homeTryOn});

  Map<String, dynamic> toJson() =>
      {
        'groupName': groupName,
        'onlineName': onlineName,
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
        'imageFile5': imageFile5,
        "homeTryon": homeTryOn == false ? 0 : 1
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      groupName: json['groupName'],
      onlineName: json['onlineName'],
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
      qtyOnHand: json['qtyOnHand'],
      designName: json['designName'],
      brand: json['brand'],
      jewelSize: json['jewelSize'],
      jewelLength: json['jewelLength'],
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
      homeTryOn: json['homeTryon'] == 0 ? false : true,
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
class Customer{
  String eMail;
  String referralEmail;
  String password;
  String firstName;
  String lastName;
  String gender;
  String dOB;
  String mobileNumber;
  String mode;
//  DateTime createdDate;
  String returnStatus;

  Customer({this.eMail, this.referralEmail, this.password, this.firstName, this.lastName, this.gender,
    this.dOB, this.mobileNumber, this.mode,  this.returnStatus});

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
        eMail: json['eMail'],
        referralEmail: json['referralEmail'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        dOB: json['dOB'],
        mobileNumber: json['mobileNumber'],
        returnStatus:json['returnStatus']
    );
  }

  Map<String, dynamic> toParam() =>{
    'eMail':eMail,
    'referralEmail': referralEmail,
    'password': password,
    'firstName':firstName,
    'lastName':lastName,
    'gender':gender,
    'dOB':dOB,
    'mobileNumber':mobileNumber,
    'mode':mode,
  };
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