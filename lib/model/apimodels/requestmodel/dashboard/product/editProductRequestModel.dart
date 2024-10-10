import '../../../../../staticData/utility.dart';

class EditProductRequestModel {
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
  List<EditProductProductmedia>? editProductProductmedia;
  var merchantId;
  var createdby;

  EditProductRequestModel(
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
      this.editProductProductmedia,
      this.merchantId,
      this.createdby});

  EditProductRequestModel.fromJson(Map<String, dynamic> json) {
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
        editProductProductmedia = <EditProductProductmedia>[];
        json['productmedia'].forEach((v) {
          editProductProductmedia!.add(new EditProductProductmedia.fromJson(v));
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
    if (this.editProductProductmedia != null) {
      data['productmedia'] =
          this.editProductProductmedia!.map((v) => v.toJson()).toList();
    }
    data['merchantId'] = this.merchantId;
    data['createdby'] = this.createdby;
    return data;
  }
}

class EditProductProductmedia {
  String? name;

  EditProductProductmedia({this.name});

  EditProductProductmedia.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
