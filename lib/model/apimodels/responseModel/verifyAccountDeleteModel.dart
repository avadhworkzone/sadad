// To parse this JSON data, do
//
//     final verifyAccountDeleteModel = verifyAccountDeleteModelFromJson(jsonString);

import 'dart:convert';

VerifyAccountDeleteModel verifyAccountDeleteModelFromJson(String str) => VerifyAccountDeleteModel.fromJson(json.decode(str));

String verifyAccountDeleteModelToJson(VerifyAccountDeleteModel data) => json.encode(data.toJson());

class VerifyAccountDeleteModel {
  int? statusCode;
  bool? isallowedtodelete;
  List<dynamic>? message;

  VerifyAccountDeleteModel({
    this.statusCode,
    this.isallowedtodelete,
    this.message,
  });

  factory VerifyAccountDeleteModel.fromJson(Map<String, dynamic> json) => VerifyAccountDeleteModel(
    statusCode: json["statusCode"],
    isallowedtodelete: json["isallowedtodelete"],
    message: json["message"] == null ? [] : List<dynamic>.from(json["message"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "isallowedtodelete": isallowedtodelete,
    "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
  };
}
