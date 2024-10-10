import '../../../../../staticData/utility.dart';

class CreateProductRequestModel {
  var name;
  var price;
  var expecteddays;
  bool? isUnlimited;
  bool? allowoncepersadadaccount;
  int? totalavailablequantity;
  var description;
  bool? showproduct;
  var isdisplayinpanel;
  bool? enablewatermark;
  List<CreateProductProductmedia>? createProductProductmedia;
  var merchantId;
  var createdby;

  CreateProductRequestModel(
      {this.name,
      this.price,
      this.expecteddays,
      this.isUnlimited,
      this.allowoncepersadadaccount,
      this.description,
      this.showproduct,
      this.isdisplayinpanel,
      this.totalavailablequantity,
      this.enablewatermark,
      this.createProductProductmedia,
      this.merchantId,
      this.createdby});

  CreateProductRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    expecteddays = json['expecteddays'];
    isUnlimited = json['isUnlimited'];
    allowoncepersadadaccount = json['allowoncepersadadaccount'];
    description = json['description'];
    showproduct = json['showproduct'];
    isdisplayinpanel = json['isdisplayinpanel'];
    totalavailablequantity = json['totalavailablequantity'];
    enablewatermark = json['enablewatermark'];
    if (Utility.isCreateImageUploadEmpty == false) {
      print('value${Utility.isCreateImageUploadEmpty}');
      if (json['productmedia'] != null) {
        createProductProductmedia = <CreateProductProductmedia>[];
        json['productmedia'].forEach((v) {
          createProductProductmedia!
              .add(new CreateProductProductmedia.fromJson(v));
        });
      }
    }
    merchantId = json['merchantId'];
    createdby = json['createdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['expecteddays'] = this.expecteddays;
    data['isUnlimited'] = this.isUnlimited;
    data['totalavailablequantity'] = this.totalavailablequantity;
    data['allowoncepersadadaccount'] = this.allowoncepersadadaccount;
    data['description'] = this.description;
    data['showproduct'] = this.showproduct;
    data['isdisplayinpanel'] = this.isdisplayinpanel;
    data['enablewatermark'] = this.enablewatermark;
    if (this.createProductProductmedia != null) {
      data['productmedia'] =
          this.createProductProductmedia!.map((v) => v.toJson()).toList();
    }
    data['merchantId'] = this.merchantId;
    data['createdby'] = this.createdby;
    return data;
  }
}

class CreateProductProductmedia {
  String? name;

  CreateProductProductmedia({this.name});

  CreateProductProductmedia.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
