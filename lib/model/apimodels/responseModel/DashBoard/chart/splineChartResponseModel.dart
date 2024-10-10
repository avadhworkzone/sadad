// To parse this JSON data, do
//
//     final splineChartResponseModel = splineChartResponseModelFromJson(jsonString);

import 'dart:convert';

SplineChartResponseModel splineChartResponseModelFromJson(String str) =>
    SplineChartResponseModel.fromJson(json.decode(str));

String splineChartResponseModelToJson(SplineChartResponseModel data) =>
    json.encode(data.toJson());

class SplineChartResponseModel {
  SplineChartResponseModel({
    this.labels,
    this.data,
    this.isEmpty,
  });

  List<String>? labels;
  SData? data;
  bool? isEmpty;

  factory SplineChartResponseModel.fromJson(Map<String, dynamic> json) =>
      SplineChartResponseModel(
        labels: List<String>.from(json["labels"].map((x) => x)),
        data: SData.fromJson(json["data"]),
        isEmpty: json["isEmpty"] == null ? false : json["isEmpty"],
      );

  Map<String, dynamic> toJson() => {
        "labels": List<dynamic>.from(labels!.map((x) => x)),
        "data": data!.toJson(),
        "isEmpty": isEmpty,
      };
}

class SData {
  SData({
    this.counter,
    this.amount,
  });

  var counter;
  var amount;

  factory SData.fromJson(Map<String, dynamic> json) => SData(
        counter: Amount.fromJson(json["counter"]),
        amount: Amount.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "counter": counter!.toJson(),
        "amount": amount!.toJson(),
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
