// To parse this JSON data, do
//
//     final availableBalanceResponseModel = availableBalanceResponseModelFromJson(jsonString);

import 'dart:convert';

List<AvailableBalanceResponseModel> availableBalanceResponseModelFromJson(
        String str) =>
    List<AvailableBalanceResponseModel>.from(
        json.decode(str).map((x) => AvailableBalanceResponseModel.fromJson(x)));

String availableBalanceResponseModelToJson(
        List<AvailableBalanceResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AvailableBalanceResponseModel {
  AvailableBalanceResponseModel({
    this.transfersenabled,
    this.totalavailablefunds,
    this.totalavailablefundsforwithdrawal,
    this.totalPartnerRewardFunds,
    this.createdby,
    this.modifiedby,
    this.agreementdoc,
    this.partneragreementdoc,
    this.tempemail,
    this.tempcell,
    this.tempname,
    this.mainmerchantid,
    this.autowithdrawfreq,
    this.suspiciousAmount,
    this.uniqueIdentity,
    this.shorturl,
    this.id,
    this.userId,
    this.deletedAt,
    this.posdeviceId,
    this.blocked,
  });

  bool? transfersenabled;
  double? totalavailablefunds;
  double? totalavailablefundsforwithdrawal;
  var totalPartnerRewardFunds;
  var createdby;
  var modifiedby;
  var agreementdoc;
  dynamic partneragreementdoc;
  dynamic tempemail;
  dynamic tempcell;
  dynamic tempname;
  dynamic mainmerchantid;
  var autowithdrawfreq;
  var suspiciousAmount;
  var uniqueIdentity;
  var shorturl;
  var id;
  var userId;
  dynamic deletedAt;
  dynamic posdeviceId;
  bool? blocked;

  factory AvailableBalanceResponseModel.fromJson(Map<String, dynamic> json) =>
      AvailableBalanceResponseModel(
        transfersenabled: json["transfersenabled"],
        totalavailablefunds: (json["totalavailablefunds"] is int)
            ? (json["totalavailablefunds"] as int).toDouble()
            : json["totalavailablefunds"],
        totalavailablefundsforwithdrawal:
            (json["totalavailablefundsforwithdrawal"] is int)
                ? (json["totalavailablefundsforwithdrawal"] as int).toDouble()
                : json["totalavailablefundsforwithdrawal"],
        totalPartnerRewardFunds: json["totalPartnerRewardFunds"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        agreementdoc: json["agreementdoc"],
        partneragreementdoc: json["partneragreementdoc"],
        tempemail: json["tempemail"],
        tempcell: json["tempcell"],
        tempname: json["tempname"],
        mainmerchantid: json["mainmerchantid"],
        autowithdrawfreq: json["autowithdrawfreq"],
        suspiciousAmount: json["suspicious_amount"],
        uniqueIdentity: json["unique_Identity"],
        shorturl: json["shorturl"],
        id: json["id"],
        userId: json["userId"],
        deletedAt: json["deletedAt"],
        posdeviceId: json["posdeviceId"],
        blocked: json["blocked"],
      );

  Map<String, dynamic> toJson() => {
        "transfersenabled": transfersenabled,
        "totalavailablefunds": totalavailablefunds,
        "totalavailablefundsforwithdrawal": totalavailablefundsforwithdrawal,
        "totalPartnerRewardFunds": totalPartnerRewardFunds,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "agreementdoc": agreementdoc,
        "partneragreementdoc": partneragreementdoc,
        "tempemail": tempemail,
        "tempcell": tempcell,
        "tempname": tempname,
        "mainmerchantid": mainmerchantid,
        "autowithdrawfreq": autowithdrawfreq,
        "suspicious_amount": suspiciousAmount,
        "unique_Identity": uniqueIdentity,
        "shorturl": shorturl,
        "id": id,
        "userId": userId,
        "deletedAt": deletedAt,
        "posdeviceId": posdeviceId,
        "blocked": blocked,
      };
}
