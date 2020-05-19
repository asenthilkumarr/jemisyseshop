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