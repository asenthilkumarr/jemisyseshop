import 'package:jemisyseshop/model/common.dart';

class Voucher {
  String refNo;
  double voucherValue;
  String remarks;
  bool isSelected;
  Voucher({this.refNo, this.voucherValue, this.remarks, this.isSelected});
  factory Voucher.fromData(Map<String, dynamic> json){
    return Voucher(
      refNo: json['refNo'],
      voucherValue: double.parse(json['voucherValue'].toString()),
      remarks: json['remarks'],
      isSelected: false
    );
  }
}
class PaymentLog {
  String response_code;
  String acquirer_transaction_id;
  String acquirer_authorized_ccy;
  String acquirer_authorized_amount;
  String acquirer_response_msg;

  PaymentLog(
      {this.response_code, this.acquirer_transaction_id, this.acquirer_authorized_ccy,
        this.acquirer_authorized_amount, this.acquirer_response_msg});

  factory PaymentLog.fromData(Map<String, dynamic> json){
    if (json['response_code'] == "0") {
      return PaymentLog(
        response_code: json['response_code'],
        acquirer_transaction_id: json['acquirer_transaction_id'],
        acquirer_authorized_ccy: json['acquirer_authorized_ccy'],
        acquirer_authorized_amount: json['acquirer_authorized_amount'],
      );
    }
    else {
      return PaymentLog(
        response_code: json['response_code'],
        acquirer_transaction_id: json['acquirer_transaction_id'],
        acquirer_response_msg: json['acquirer_response_msg'],
      );
    }
  }
}
class Store{
  String storeCode;
  String description;
  String address1;
  String address2;
  String address3;
  String address4;
  String state;
  String pinCode;
  String telePhone;
  DateTime openingTime;
  DateTime closingTime;

  Store({this.storeCode, this.description, this.address1, this.address2, this.address3, this.address4,
    this.state, this.pinCode, this.telePhone, this.openingTime, this.closingTime});

  factory Store.fromData(Map<String, dynamic> json){
    return Store(
      storeCode: json['storeCode'],
      description: json['description'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      address4: json['address4'],
      state: json['state'],
      pinCode: json['pinCode'],
      telePhone: json['telephone'],
      openingTime: json['openingTime'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["openingTime"]) : null,
      closingTime: json['closingTime'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["closingTime"]) : null,
    );
  }
}
class OrderH {
  String orderNo;
  DateTime orderDate;
  double netAmount;
  String dcustomerTitle;
  String dcustomerName;
  String dAddress1;
  String dAddress2;
  String invoiceNo;
  DateTime invoiceDate;
  DateTime shipDate;
  String shipRefNo;
  String shipBy;
  String orderType;
  bool isVisiblemore;

  OrderH({this.orderNo, this.orderDate, this.netAmount, this.dcustomerTitle, this.dcustomerName,
        this.dAddress1, this.dAddress2, this.invoiceNo, this.invoiceDate, this.shipDate,
    this.shipBy, this.shipRefNo, this.orderType, this.isVisiblemore});

  factory OrderH.fromData(Map<String, dynamic> json){
    return OrderH(
        orderNo: json['orderNo'],
        orderDate: json['orderDate'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["orderDate"]) : null,
        netAmount: double.parse(json['netAmount'].toString()),
        dcustomerTitle: json['dcustomerTitle'],
        dcustomerName: json['dcustomerName'],
        dAddress1: json['dAddress1'],
        dAddress2: json['dAddress2'],
        invoiceNo: json['invoiceNo'],
        invoiceDate: json['invoiceDate'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["invoiceDate"]) : null,
        shipDate: json['shipDate'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["shipDate"]) : null,
        shipBy: json['shipBy'],
        shipRefNo: json['shipRefNo'],
        orderType: json['orderType'],
        isVisiblemore: true
    );
  }
}
class OrderD{
  String orderNo;
  String designCode;
  int version;
  String inventoryCode;
  String onlineName;
  String description;
  String jewelsize;
  int shippingDays;
  double unitPrice;
  double totalPrice;
  String imagefileName;
  bool isVisible;

  OrderD({this.orderNo, this.designCode, this.version, this.inventoryCode, this.onlineName, this.description,
  this.jewelsize, this.shippingDays, this.unitPrice, this.totalPrice, this.imagefileName, this.isVisible});

  factory OrderD.fromData(Map<String, dynamic> json){
    return OrderD(
      orderNo: json['orderNo'],
      designCode: json['designCode'],
      version: int.parse(json['version'].toString()),
      inventoryCode: json['inventoryCode'],
      onlineName: json['onlineName'],
      description: json['description'],
      jewelsize: json['jewelsize'],
      shippingDays: int.parse(json['shippingDays'].toString()),
      unitPrice: double.parse(json['unitPrice'].toString()),
      totalPrice: double.parse(json['totalPrice'].toString()),
      imagefileName: json['imagefileName'] != "" ? imageUrl + json['imagefileName'] : json['imagefileName'],
        isVisible: false
    );
  }
}
class OrderGetParam{
  String eMail;
  String mode;
  String orderType;

  Map<String, dynamic> toParam() =>
      {
        'eMail': eMail,
        'mode': mode,
        'orderType': orderType
      };
}
class OrderData {
  String eMail;
  double totalAmount;
  double discount;
  double netAmount;
  String referraleMail;
  String deliveryMode;
  Address shippingAddress;
  Address billingAddress;
  String dstoreCode;
  String payMode1;
  double payMode1_Amt;
  String payMode1_Ref;
  String payMode2;
  double payMode2_Amt;
  String payMode2_Ref;
  String payMode3;
  double payMode3_Amt;
  String payMode3_Ref;
  String mode;
  OrderData({this.eMail, this.totalAmount, this.discount, this.netAmount, this.referraleMail,
  this.deliveryMode, this.shippingAddress, this.billingAddress, this.dstoreCode,
  this.payMode1, this.payMode1_Amt, this.payMode1_Ref,
  this.payMode2, this.payMode2_Amt, this.payMode2_Ref,
  this.payMode3, this.payMode3_Amt, this.payMode3_Ref, this.mode});

  Map<String, dynamic> toParam() =>{
    'eMail':eMail,
    'totalAmount':totalAmount,
    'discount':discount,
    'netAmount':netAmount,
    'referraleMail':referraleMail,
    'deliveryMode':deliveryMode,
    'shippingAddress':shippingAddress.toParam(),
    'billingAddress':billingAddress.toParam(),
    'dstoreCode':dstoreCode,
    'payMode1':payMode1,
    'payMode1_Amt':payMode1_Amt,
    'payMode1_Ref':payMode1_Ref,
    'payMode2':payMode2,
    'payMode2_Amt':payMode2_Amt,
    'payMode2_Ref':payMode2_Ref,
    'payMode3':payMode3,
    'payMode3_Amt':payMode3_Amt,
    'payMode3_Ref':payMode3_Ref,
    'mode':mode
  };
}
class OrderOutstanding{
  String storeCode;
  String refNo;
  String docType;
  DateTime tranDate;
  String vipNo;
  String name;
  int totalAmount;
  int receivedAmount;
  DateTime collectionDate;
  DateTime nextpaymentDate;
  String email;
  int filesCount;
  String orderBy;

  OrderOutstanding({
    this.storeCode, this.refNo, this.docType, this.tranDate, this.vipNo, this.name, this.totalAmount, this.receivedAmount,
    this.collectionDate, this.nextpaymentDate, this.filesCount,this.email, this.orderBy
  });

  factory OrderOutstanding.fromData(Map<String, dynamic> json){
    return OrderOutstanding(
      storeCode: json['storeCode'],
      refNo: json['refNo'],
      docType: json['docType'],
      tranDate: json['tranDate'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["tranDate"]) : null,
      nextpaymentDate: json['nextpaymentDate'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["nextpaymentDate"]) : null,
      collectionDate: json['collectionDate'].toString() != "0001-01-01T00:00:00" ? DateTime.parse(json["collectionDate"]) : null,
      vipNo: json['vipNo'],
      totalAmount: json['totalAmount'],
      receivedAmount: json['receivedAmount'],
      name: json['name'],
      orderBy: json['orderBy'],
    );
  }

}
class OrderUpdateParam{
  String storeCode;
  String refNo;
  String docType;
  String payMode;
  double amount;
  String reff;

  Map<String, dynamic> toParam() =>{
    'storeCode':storeCode,
    'refNo':refNo,
    'docType': docType,
    'payMode': payMode,
    'amount': amount,
    'reff': reff
  };
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
    'imageFileName':imageFileName,
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
  String currSymbol;
  String message;
  String startupImageName;
  String imageFolderName;
  String fontName;
  bool isERPandEShopOnSameServer;
  String isBackendJEMiSys;
  String paymentGateway;
  String aboutusUrl;
  String contactCompanyName;
  String contactName;
  String contactNumber;
  String contactEmail;
  String contactAddress;
  String contactInstagram;
  String contactFacebook;
  String contactTwitter;
  String paymode_CC;
  String paymode_Nets;
  String paymode_Points;
  String paymode_Voucher;

  Setting({ this.appName, this.currCode, this.currSymbol, this.startupImageName, this.imageFolderName, this.fontName, this.message, this.isERPandEShopOnSameServer, this.isBackendJEMiSys, this.paymentGateway,
  this.aboutusUrl, this.contactCompanyName, this.contactName, this.contactNumber, this.contactEmail, this.contactAddress,
  this.contactInstagram, this.contactFacebook, this.contactTwitter, this.paymode_CC, this.paymode_Nets, this.paymode_Points, this.paymode_Voucher});

  factory Setting.fromJson(Map<String, dynamic> json) {
    imgFolderName = json['imageFolderName'];
    imageUrl = imageDefaultUrl + imgFolderName+"/JewelImages/";
    startupimageUrl = imageDefaultUrl + imgFolderName+"/Startup/";
    bannerimageUrl = imageDefaultUrl + imgFolderName+"/Banner/";
    return Setting(
        appName: json['appName'],
        currCode: json['currCode'],
        currSymbol: json['currSymbol'],
        message: json['message'],
        startupImageName: startupimageUrl+json['startupImageName'],
        imageFolderName: json['imageFolderName'],
        fontName: json['fontName'],
        isERPandEShopOnSameServer: json['isERPandEShopOnSameServer'] == "0" ? false : true,
        isBackendJEMiSys: json['isBackendJEMiSys'],
        paymentGateway: json['paymentGateway'],
        aboutusUrl: json['aboutusUrl'],
        contactCompanyName: json['contactCompanyName'],
        contactName: json['contactName'],
        contactNumber: json['contactNumber'],
        contactEmail: json['contactEmail'],
        contactAddress: json['contactAddress'],
        contactInstagram: json['contactInstagram'],
        contactFacebook: json['contactFacebook'],
        contactTwitter: json['contactTwitter'],
        paymode_CC: json['paymode_CC'],
        paymode_Nets: json['paymode_Nets'],
        paymode_Points: json['paymode_Points'],
        paymode_Voucher: json['paymode_Voucher']
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
  String title;
  String firstName;
  String lastName;
  String gender;
  String dOB;
  String mobileNumber;
  double pointsAvailable;
  double pointsDollor;
  String mode;
  String udid;
//  DateTime createdDate;
  String returnStatus;
  Address address;

  Customer({this.eMail, this.referralEmail, this.password, this.title, this.firstName, this.lastName, this.gender,
    this.dOB, this.mobileNumber, this.pointsAvailable, this.pointsDollor, this.address,  this.returnStatus, this.mode,
  this.udid});

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(
      eMail: json['eMail'],
      referralEmail: json['referralEmail'],
      password: json['password'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      dOB: json['dOB'] != "" ? json['dOB'] : null,
      mobileNumber: json['mobileNumber'],
      pointsAvailable: double.parse(json['pointsAvailable'].toString()),
      pointsDollor: double.parse(json['pointsDollor'].toString()),
      returnStatus: json['returnStatus'],
      udid: json['udid'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
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
    'udid':udid,
    'mode':mode,
  };
}
class Points{
  String memberType;
  String vipNo;
  double pointsAvailable;
  double dollortoRedeem;
  Points({this.memberType, this.vipNo, this.pointsAvailable, this.dollortoRedeem});
  factory Points.fromJson(Map<String, dynamic> json){
    return Points(
      memberType: json['memberType'],
      vipNo: json['vipNo'],
      pointsAvailable: double.parse(json['pointsAvailable'].toString()),
      dollortoRedeem: double.parse(json['dollortoRedeem'].toString())
    );
  }
}
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
class Address {
  String eMail;
  String title;
  String fullName;
  String mobileNo;
  String address1;
  String address2;
  String address3;
  String address4;
  String city;
  String state;
  String country;
  String pinCode;

  Address(
      {this.eMail, this.title, this.fullName, this.mobileNo, this.address1, this.address2, this.address3, this.address4,
        this.city, this.state, this.country, this.pinCode});

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      eMail: json['eMail'],
      title: json['title'],
      fullName: json['fullName'],
      mobileNo: json['mobileNumber'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      address4: json['address4'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pinCode: json['pinCode'],
    );
  }
  Map<String, dynamic> toParam() =>{
    'eMail':eMail,
    'title':title,
    'fullName':fullName,
    'mobileNumber':mobileNo,
    'address1':address1,
    'address2':address2,
    'address3':address3,
    'address4':address4,
    'city':city,
    'state':state,
    'country':country,
    'pinCode':pinCode
  };
}
class Country{
  String country;
  int orderOfDisplay;
  bool homeTryOn;
  bool cityState;
  Country({this.country, this.orderOfDisplay, this.homeTryOn, this.cityState});
  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
      country: json['country'],
      homeTryOn: json['homeTryon'] == 0 ? false : true,
      orderOfDisplay: json['orderOfDisplay'],
      cityState: json['cityState'] == 0 ? false : true,
    );
  }
}
class StateList{
  String country;
  String state;
  int orderOfDisplay;
  bool homeTryOn;
  bool cityState;
  StateList({this.country, this.state, this.orderOfDisplay, this.homeTryOn, this.cityState});
  factory StateList.fromJson(Map<String, dynamic> json){
    return StateList(
      country: json['country'],
      state: json['state'],
      homeTryOn: json['homeTryon'] == 0 ? false : true,
      orderOfDisplay: json['orderOfDisplay'],
      cityState: json['cityState'] == 0 ? false : true,
    );
  }
}
class City{
  String country;
  String state;
  String city;
  int orderOfDisplay;
  bool homeTryOn;
  City({this.country, this.state, this.city, this.orderOfDisplay, this.homeTryOn});
  factory City.fromJson(Map<String, dynamic> json){
    return City(
      country: json['country'],
      state: json['state'],
      city: json['city'],
      homeTryOn: json['homeTryon'] == 0 ? false : true,
      orderOfDisplay: json['orderOfDisplay'],
    );
  }
}
class FCM_UpdateToken{
  String deviceId;
  String eMail;
  String token;

  FCM_UpdateToken({this.deviceId, this.eMail, this.token});

  Map<String, dynamic> toParam() =>{
    'deviceId':deviceId,
    'eMail':eMail,
    'token':token
  };
}
class SendEmail {
  String source;
  String storeCode;
  String macid;
  String mailHost;
  String mailFrom;
  String mailTo;
  String mailSubject;
  String mailBody;
  String mailAttachFileName;
  String docno;
  String returnStatus;
  String errormsg;
  String status;
  String connectionString;
  String doctype;
  String vipname;
  String userid;
  String SendeMailToCustomerInvoiceResult;

  SendEmail({
    this.source, this.storeCode , this.macid, this.mailHost, this.mailFrom, this.mailTo,
    this.mailSubject,this.mailBody,this.mailAttachFileName,this.docno,this.returnStatus,this.errormsg,this.status,
    this.doctype,this.vipname,this.userid,this.SendeMailToCustomerInvoiceResult
  });
  factory SendEmail.fromJson(Map<String, dynamic> json){
    return SendEmail(
      returnStatus:json['SendeMailToCustomerInvoiceResult'].toString(),
    );
  }
  Map<String, dynamic> toParam() =>{

    'storeCode': storeCode,
    'docno':docno,
    'macid':macid,
    'mailTo':mailTo,
    'doctype':doctype,
    'vipname':vipname,
    'userid':userid,

  };
}
class RadioButtonListValue {
  String name;
  int index;
  RadioButtonListValue({this.name, this.index});
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

class Country2{
  String name;
  String shortCode;
  String currency;
  String imageUrl;
  Country2(this.name, this.shortCode, this.currency, this.imageUrl);
}
