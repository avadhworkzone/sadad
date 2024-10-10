class SettlementReportResponseModel {
  var count;
  List<SetRData>? setRdata;

  SettlementReportResponseModel({this.count, this.setRdata});

  SettlementReportResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      setRdata = <SetRData>[];
      json['data'].forEach((v) {
        setRdata!.add(new SetRData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.setRdata != null) {
      data['data'] = this.setRdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SetRData {
  var withdrawalRequestId;
  var withdrawalRequestDateTime;
  var availableAmountAtWithdrawalRequestDateTime;
  var requestAmount;
  var currency;
  var withdrawalRequestStatus;
  var username;
  var payoutStatus;
  var payoutId;
  var payoutDateTime;
  var payoutAmount;
  var sadadCharges;
  var bankName;
  var ibanNumber;
  var bankAccountHoldername;
  var bankReferenceNumber;

  SetRData(
      {this.withdrawalRequestId,
      this.withdrawalRequestDateTime,
      this.availableAmountAtWithdrawalRequestDateTime,
      this.requestAmount,
      this.currency,
      this.withdrawalRequestStatus,
      this.username,
      this.payoutStatus,
      this.payoutId,
      this.payoutDateTime,
      this.payoutAmount,
      this.sadadCharges,
      this.bankName,
      this.ibanNumber,
      this.bankAccountHoldername,
      this.bankReferenceNumber});

  SetRData.fromJson(Map<String, dynamic> json) {
    withdrawalRequestId = json['withdrawalRequestId'];
    withdrawalRequestDateTime = json['withdrawalRequestDateTime'];
    availableAmountAtWithdrawalRequestDateTime =
        json['availableAmountAtWithdrawalRequestDateTime'];
    requestAmount = json['requestAmount'];
    currency = json['currency'];
    withdrawalRequestStatus = json['withdrawalRequestStatus'];
    username = json['username'];
    payoutStatus = json['payoutStatus'];
    payoutId = json['payoutId'];
    payoutDateTime = json['payoutDateTime'];
    payoutAmount = json['payoutAmount'];
    sadadCharges = json['sadadCharges'];
    bankName = json['bankName'];
    ibanNumber = json['ibanNumber'];
    bankAccountHoldername = json['bankAccountHoldername'];
    bankReferenceNumber = json['bankReferenceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['withdrawalRequestId'] = this.withdrawalRequestId;
    data['withdrawalRequestDateTime'] = this.withdrawalRequestDateTime;
    data['availableAmountAtWithdrawalRequestDateTime'] =
        this.availableAmountAtWithdrawalRequestDateTime;
    data['requestAmount'] = this.requestAmount;
    data['currency'] = this.currency;
    data['withdrawalRequestStatus'] = this.withdrawalRequestStatus;
    data['username'] = this.username;
    data['payoutStatus'] = this.payoutStatus;
    data['payoutId'] = this.payoutId;
    data['payoutDateTime'] = this.payoutDateTime;
    data['payoutAmount'] = this.payoutAmount;
    data['sadadCharges'] = this.sadadCharges;
    data['bankName'] = this.bankName;
    data['ibanNumber'] = this.ibanNumber;
    data['bankAccountHoldername'] = this.bankAccountHoldername;
    data['bankReferenceNumber'] = this.bankReferenceNumber;
    return data;
  }
}
