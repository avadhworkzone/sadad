// To parse this JSON data, do
//
//     final transactionChartResponseModel = transactionChartResponseModelFromJson(jsonString);

import 'dart:convert';

TransactionChartResponseModel transactionChartResponseModelFromJson(
        String str) =>
    TransactionChartResponseModel.fromJson(json.decode(str));

String transactionChartResponseModelToJson(
        TransactionChartResponseModel data) =>
    json.encode(data.toJson());

class TransactionChartResponseModel {
  TransactionChartResponseModel({
    this.labels,
    this.data,
    this.isEmpty,
  });

  List<String>? labels;
  TransData? data;
  bool? isEmpty;

  factory TransactionChartResponseModel.fromJson(Map<String, dynamic> json) =>
      TransactionChartResponseModel(
        labels: List<String>.from(json["labels"].map((x) => x)),
        data: TransData.fromJson(json["data"]),
        isEmpty: json["isEmpty"],
      );

  Map<String, dynamic> toJson() => {
        "labels": List<dynamic>.from(labels!.map((x) => x)),
        "data": data!.toJson(),
        "isEmpty": isEmpty,
      };
}

class TransData {
  TransData({
    this.amount,
    this.counter,
  });

  Amount? amount;
  Amount? counter;

  factory TransData.fromJson(Map<String, dynamic> json) => TransData(
        amount: Amount.fromJson(json["amount"]),
        counter: Amount.fromJson(json["counter"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount!.toJson(),
        "counter": counter!.toJson(),
      };
}

class Amount {
  Amount({
    this.success,
    this.failure,
  });

  List<dynamic>? success;
  List<dynamic>? failure;

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        success: List<dynamic>.from(json["success"].map((x) => x)),
        failure: List<dynamic>.from(json["failure"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success!.map((x) => x)),
        "failure": List<dynamic>.from(failure!.map((x) => x)),
      };
}
