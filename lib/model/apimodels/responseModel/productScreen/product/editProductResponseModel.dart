// To parse this JSON data, do
//
//     final createProductResponseModel = createProductResponseModelFromJson(jsonString);

import 'dart:convert';

EditProductResponseModel editProductResponseModelFromJson(String str) =>
    EditProductResponseModel.fromJson(json.decode(str));

String editProductResponseModelToJson(EditProductResponseModel data) =>
    json.encode(data.toJson());

class EditProductResponseModel {
  EditProductResponseModel({
    this.name,
    this.description,
    this.totalavailablequantity,
    this.enablewatermark,
    this.price,
    this.viewcount,
    this.salescount,
    this.allowoncepersadadaccount,
    this.expecteddays,
    this.showproduct,
    this.createdby,
    this.transactionFees,
    this.netamount,
    this.isUnlimited,
    this.prodId,
    this.shareUrl,
    this.recurringFreq,
    this.isdisplayinpanel,
    this.isRecurringProduct,
    this.isShippingAddressRequired,
    this.nextCycleCharge,
    this.id,
    this.date,
    this.productNumber,
    this.merchantId,
    this.deletedAt,
    this.created,
    this.modified,
  });

  var name;
  var description;
  var totalavailablequantity;
  var enablewatermark;
  var price;
  var viewcount;
  var salescount;
  var allowoncepersadadaccount;
  var expecteddays;
  var showproduct;
  var createdby;
  var transactionFees;
  var netamount;
  var isUnlimited;
  var prodId;
  var shareUrl;
  var recurringFreq;
  var isdisplayinpanel;
  bool? isRecurringProduct;
  var isShippingAddressRequired;
  var nextCycleCharge;
  var id;
  DateTime? date;
  var productNumber;
  var merchantId;
  dynamic deletedAt;
  DateTime? created;
  DateTime? modified;

  factory EditProductResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProductResponseModel(
        name: json["name"],
        description: json["description"],
        totalavailablequantity: json["totalavailablequantity"],
        enablewatermark: json["enablewatermark"],
        price: json["price"],
        viewcount: json["viewcount"],
        salescount: json["salescount"],
        allowoncepersadadaccount: json["allowoncepersadadaccount"],
        expecteddays: json["expecteddays"],
        showproduct: json["showproduct"],
        createdby: json["createdby"],
        transactionFees: json["transactionFees"],
        netamount: json["netamount"],
        isUnlimited: json["isUnlimited"],
        prodId: json["prodId"],
        shareUrl: json["shareUrl"],
        recurringFreq: json["recurring_freq"],
        isdisplayinpanel: json["isdisplayinpanel"],
        isRecurringProduct: json["isRecurringProduct"],
        isShippingAddressRequired: json["isShippingAddressRequired"],
        nextCycleCharge: json["nextCycleCharge"],
        id: json["id"],
        date: DateTime.parse(json["date"]),
        productNumber: json["productNumber"],
        merchantId: json["merchantId"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "totalavailablequantity": totalavailablequantity,
        "enablewatermark": enablewatermark,
        "price": price,
        "viewcount": viewcount,
        "salescount": salescount,
        "allowoncepersadadaccount": allowoncepersadadaccount,
        "expecteddays": expecteddays,
        "showproduct": showproduct,
        "createdby": createdby,
        "transactionFees": transactionFees,
        "netamount": netamount,
        "isUnlimited": isUnlimited,
        "prodId": prodId,
        "shareUrl": shareUrl,
        "recurring_freq": recurringFreq,
        "isdisplayinpanel": isdisplayinpanel,
        "isRecurringProduct": isRecurringProduct,
        "isShippingAddressRequired": isShippingAddressRequired,
        "nextCycleCharge": nextCycleCharge,
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "productNumber": productNumber,
        "merchantId": merchantId,
        "deletedAt": deletedAt,
        "created": created!.toIso8601String(),
        "modified": modified!.toIso8601String(),
      };
}
