class MyProductListResponseModel {
  var name;
  var description;
  var arabicName;
  var arabicDescription;
  var totalavailablequantity;
  var enablewatermark;
  var price;
  var viewcount;
  var salescount;
  var allowoncepersadadaccount;
  var expecteddays;
  bool? showproduct;
  var createdby;
  var modifiedby;
  var transactionFees;
  var netamount;
  bool? isUnlimited;
  var prodId;
  var shareUrl;
  var recurringFreq;
  var isdisplayinpanel;
  bool? isRecurringProduct;
  var isShippingAddressRequired;
  var recurringCycleLimit;
  var nextCycleCharge;
  var id;
  var date;
  var productNumber;
  var merchantId;
  var deletedAt;
  var created;
  var modified;
  var viewproductipId;
  List<ProductMedia>? productmedia;

  MyProductListResponseModel(
      {this.name,
      this.description,
      this.arabicName,
      this.arabicDescription,
      this.totalavailablequantity,
      this.enablewatermark,
      this.price,
      this.viewcount,
      this.salescount,
      this.allowoncepersadadaccount,
      this.expecteddays,
      this.showproduct,
      this.createdby,
      this.modifiedby,
      this.transactionFees,
      this.netamount,
      this.isUnlimited,
      this.prodId,
      this.shareUrl,
      this.recurringFreq,
      this.isdisplayinpanel,
      this.isRecurringProduct,
      this.isShippingAddressRequired,
      this.recurringCycleLimit,
      this.nextCycleCharge,
      this.id,
      this.date,
      this.productNumber,
      this.merchantId,
      this.deletedAt,
      this.created,
      this.modified,
      this.viewproductipId,
      this.productmedia});

  MyProductListResponseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    arabicName = json['arabicName'];
    arabicDescription = json['arabicDescription'];
    totalavailablequantity = json['totalavailablequantity'];
    enablewatermark = json['enablewatermark'];
    price = json['price'];
    viewcount = json['viewcount'];
    salescount = json['salescount'];
    allowoncepersadadaccount = json['allowoncepersadadaccount'];
    expecteddays = json['expecteddays'];
    showproduct = json['showproduct'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    transactionFees = json['transactionFees'];
    netamount = json['netamount'];
    isUnlimited = json['isUnlimited'];
    prodId = json['prodId'];
    shareUrl = json['shareUrl'];
    recurringFreq = json['recurring_freq'];
    isdisplayinpanel = json['isdisplayinpanel'];
    isRecurringProduct = json['isRecurringProduct'];
    isShippingAddressRequired = json['isShippingAddressRequired'];
    recurringCycleLimit = json['recurringCycleLimit'];
    nextCycleCharge = json['nextCycleCharge'];
    id = json['id'];
    date = json['date'];
    productNumber = json['productNumber'];
    merchantId = json['merchantId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    viewproductipId = json['viewproductipId'];
    productmedia = json['productmedia'] == null
        ? []
        : (json['productmedia'] as List<dynamic>).isEmpty
            ? []
            : List<ProductMedia>.from(
                json['productmedia'].map((x) => ProductMedia.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['arabicName'] = this.arabicName;
    data['arabicDescription'] = this.arabicDescription;
    data['totalavailablequantity'] = this.totalavailablequantity;
    data['enablewatermark'] = this.enablewatermark;
    data['price'] = this.price;
    data['viewcount'] = this.viewcount;
    data['salescount'] = this.salescount;
    data['allowoncepersadadaccount'] = this.allowoncepersadadaccount;
    data['expecteddays'] = this.expecteddays;
    data['showproduct'] = this.showproduct;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['transactionFees'] = this.transactionFees;
    data['netamount'] = this.netamount;
    data['isUnlimited'] = this.isUnlimited;
    data['prodId'] = this.prodId;
    data['shareUrl'] = this.shareUrl;
    data['recurring_freq'] = this.recurringFreq;
    data['isdisplayinpanel'] = this.isdisplayinpanel;
    data['isRecurringProduct'] = this.isRecurringProduct;
    data['isShippingAddressRequired'] = this.isShippingAddressRequired;
    data['recurringCycleLimit'] = this.recurringCycleLimit;
    data['nextCycleCharge'] = this.nextCycleCharge;
    data['id'] = this.id;
    data['date'] = this.date;
    data['productNumber'] = this.productNumber;
    data['merchantId'] = this.merchantId;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['viewproductipId'] = this.viewproductipId;
    if (this.productmedia != null) {
      data['productmedia'] = this.productmedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductMedia {
  ProductMedia({
    this.name,
    this.version,
    this.createdby,
    this.modifiedby,
    this.watermarkimg,
    this.id,
    this.productId,
  });

  var name;
  var version;
  var createdby;
  dynamic modifiedby;
  dynamic watermarkimg;
  var id;
  var productId;

  factory ProductMedia.fromJson(Map<String, dynamic> json) => ProductMedia(
        name: json["name"],
        version: json["version"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        watermarkimg: json["watermarkimg"],
        id: json["id"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "version": version,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "watermarkimg": watermarkimg,
        "id": id,
        "productId": productId,
      };
}
