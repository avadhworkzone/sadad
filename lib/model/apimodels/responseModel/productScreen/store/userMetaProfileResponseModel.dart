class UserMetaProfileResponse {
  bool? transfersenabled;
  var totalavailablefunds;
  var totalavailablefundsforwithdrawal;
  var totalPartnerRewardFunds;
  var createdby;
  var modifiedby;
  var agreementdoc;
  var partneragreementdoc;
  var tempemail;
  var tempcell;
  var tempname;
  var mainmerchantid;
  var autowithdrawfreq;
  var suspiciousAmount;
  var uniqueIdentity;
  var shorturl;
  var id;
  var userId;
  var deletedAt;
  var posdeviceId;
  bool? blocked;

  UserMetaProfileResponse(
      {this.transfersenabled,
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
      this.blocked});

  UserMetaProfileResponse.fromJson(Map<String, dynamic> json) {
    transfersenabled = json['transfersenabled'];
    totalavailablefunds = json['totalavailablefunds'];
    totalavailablefundsforwithdrawal = json['totalavailablefundsforwithdrawal'];
    totalPartnerRewardFunds = json['totalPartnerRewardFunds'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    agreementdoc = json['agreementdoc'];
    partneragreementdoc = json['partneragreementdoc'];
    tempemail = json['tempemail'];
    tempcell = json['tempcell'];
    tempname = json['tempname'];
    mainmerchantid = json['mainmerchantid'];
    autowithdrawfreq = json['autowithdrawfreq'];
    suspiciousAmount = json['suspicious_amount'];
    uniqueIdentity = json['unique_Identity'];
    shorturl = json['shorturl'];
    id = json['id'];
    userId = json['userId'];
    deletedAt = json['deletedAt'];
    posdeviceId = json['posdeviceId'];
    blocked = json['blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transfersenabled'] = this.transfersenabled;
    data['totalavailablefunds'] = this.totalavailablefunds;
    data['totalavailablefundsforwithdrawal'] =
        this.totalavailablefundsforwithdrawal;
    data['totalPartnerRewardFunds'] = this.totalPartnerRewardFunds;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['agreementdoc'] = this.agreementdoc;
    data['partneragreementdoc'] = this.partneragreementdoc;
    data['tempemail'] = this.tempemail;
    data['tempcell'] = this.tempcell;
    data['tempname'] = this.tempname;
    data['mainmerchantid'] = this.mainmerchantid;
    data['autowithdrawfreq'] = this.autowithdrawfreq;
    data['suspicious_amount'] = this.suspiciousAmount;
    data['unique_Identity'] = this.uniqueIdentity;
    data['shorturl'] = this.shorturl;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['deletedAt'] = this.deletedAt;
    data['posdeviceId'] = this.posdeviceId;
    data['blocked'] = this.blocked;
    return data;
  }
}
