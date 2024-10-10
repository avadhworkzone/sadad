class OrderReportResponseModel {
  var count;
  List<OrdData>? ordData;

  OrderReportResponseModel({this.count, this.ordData});

  OrderReportResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      ordData = <OrdData>[];
      json['data'].forEach((v) {
        ordData!.add(new OrdData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.ordData != null) {
      data['data'] = this.ordData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdData {
  var orderDateTime;
  var transactionId;
  var orderNumber;
  var orderAmount;
  var orderStatus;
  var productItemName;
  var quantity;
  var currency;
  var deliveryDateTime;
  var buyerName;
  var buyerEmailId;
  var buyerMobileNumber;
  var Id;
  var deliveryDate;
  var productAmount;
  var orderStatusId;
  List<ProductMediaName>? productMediaName;

  OrdData(
      {this.orderDateTime,
      this.transactionId,
      this.orderNumber,
      this.orderAmount,
      this.orderStatus,
      this.productItemName,
      this.quantity,
      this.currency,
      this.deliveryDateTime,
      this.buyerName,
      this.buyerEmailId,
      this.deliveryDate,
      this.productAmount,
      this.orderStatusId,
      this.productMediaName,
      this.Id,
      this.buyerMobileNumber});

  OrdData.fromJson(Map<String, dynamic> json) {
    orderDateTime = json['orderDateTime'];
    transactionId = json['transactionId'];
    orderNumber = json['orderNumber'];
    orderAmount = json['orderAmount'];
    orderStatus = json['orderStatus'];
    productItemName = json['productItemName'];
    quantity = json['quantity'];
    currency = json['currency'];
    deliveryDateTime = json['deliveryDateTime'];
    buyerName = json['buyerName'];
    buyerEmailId = json['buyerEmailId'];
    buyerMobileNumber = json['buyerMobileNumber'];
    Id = json['Id'];
    deliveryDate = json['deliveryDate '];
    productAmount = json['productAmount'];
    orderStatusId = json['orderStatusId'];
    if (json['productMediaName'] != null) {
      productMediaName = <ProductMediaName>[];
      json['productMediaName'].forEach((v) {
        productMediaName!.add(new ProductMediaName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDateTime'] = this.orderDateTime;
    data['transactionId'] = this.transactionId;
    data['orderNumber'] = this.orderNumber;
    data['orderAmount'] = this.orderAmount;
    data['orderStatus'] = this.orderStatus;
    data['productItemName'] = this.productItemName;
    data['quantity'] = this.quantity;
    data['currency'] = this.currency;
    data['deliveryDateTime'] = this.deliveryDateTime;
    data['buyerName'] = this.buyerName;
    data['buyerEmailId'] = this.buyerEmailId;
    data['buyerMobileNumber'] = this.buyerMobileNumber;
    data['Id'] = this.Id;
    data['deliveryDate '] = this.deliveryDate;
    data['productAmount'] = this.productAmount;
    data['orderStatusId'] = this.orderStatusId;
    if (this.productMediaName != null) {
      data['productMediaName'] =
          this.productMediaName!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductMediaName {
  var name;
  var id;
  var productId;

  ProductMediaName({this.name, this.id, this.productId});

  ProductMediaName.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['productId'] = this.productId;
    return data;
  }
}
