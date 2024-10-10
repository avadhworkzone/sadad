// To parse this JSON data, do
//
//     final orderCountResponseModel = orderCountResponseModelFromJson(jsonString);

import 'dart:convert';

OrderCountResponseModel orderCountResponseModelFromJson(String str) =>
    OrderCountResponseModel.fromJson(json.decode(str));

String orderCountResponseModelToJson(OrderCountResponseModel data) =>
    json.encode(data.toJson());

class OrderCountResponseModel {
  OrderCountResponseModel({
    this.totalOrders,
    this.deliveredOrders,
    this.pendingOrders,
  });

  Orders? totalOrders;
  Orders? deliveredOrders;
  Orders? pendingOrders;

  factory OrderCountResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderCountResponseModel(
        totalOrders: Orders.fromJson(json["totalOrders"]),
        deliveredOrders: Orders.fromJson(json["deliveredOrders"]),
        pendingOrders: Orders.fromJson(json["pendingOrders"]),
      );

  Map<String, dynamic> toJson() => {
        "totalOrders": totalOrders!.toJson(),
        "deliveredOrders": deliveredOrders!.toJson(),
        "pendingOrders": pendingOrders!.toJson(),
      };
}

class Orders {
  Orders({
    this.amount,
    this.count,
  });

  var amount;
  var count;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        amount: json["amount"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "count": count,
      };
}
