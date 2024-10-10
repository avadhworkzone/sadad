class PosPaymentReportTransactionResModel {
  var count;
  List<PosPaymentReportResponseModel>? data;

  PosPaymentReportTransactionResModel({this.count, this.data});

  PosPaymentReportTransactionResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <PosPaymentReportResponseModel>[];
      json['data'].forEach((v) {
        data!.add(new PosPaymentReportResponseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PosPaymentReportResponseModel {
  var transactionDateTime;
  var terminalId;
  var transactionId;
  var id;
  var transactionType;
  var transactionAmount;
  var sadadCharges;
  var currrency;
  var transactionStatus;
  var rRN;
  var paymentMethods;
  var cardType;
  var cardEnteredType;
  var maskedCardNumber;
  var cardHolderName;
  var responseCode;
  var responseMessage;
  var sadadMerchantId;
  var terminalName;
  var terminalLocation;
  var terminalStatus;
  var deviceId;
  var deviceType;
  var deviceStatus;
  var deviceSerialNo;
  var refundId;
  var refundRRN;
  var refundAmount;
  var refundRequestedDateTime;
  var refundStatus;
  var disputeId;
  var disputeCreatedDateTime;
  var disputeAmouont;
  var disputeType;
  var disputeStatus;
  var comments;
  var isActive;
  var isOnline;

  PosPaymentReportResponseModel(
      {this.transactionDateTime,
      this.terminalId,
      this.transactionId,
      this.id,
      this.transactionType,
      this.transactionAmount,
      this.sadadCharges,
      this.currrency,
      this.transactionStatus,
      this.rRN,
      this.paymentMethods,
      this.cardType,
      this.cardEnteredType,
      this.maskedCardNumber,
      this.cardHolderName,
      this.responseCode,
      this.responseMessage,
      this.sadadMerchantId,
      this.terminalName,
      this.terminalLocation,
      this.terminalStatus,
      this.deviceId,
      this.deviceType,
      this.deviceStatus,
      this.deviceSerialNo,
      this.refundId,
      this.refundRRN,
      this.refundAmount,
      this.refundRequestedDateTime,
      this.refundStatus,
      this.disputeId,
      this.disputeCreatedDateTime,
      this.disputeAmouont,
      this.disputeType,
      this.disputeStatus,
      this.comments,
      this.isActive,
      this.isOnline});

  PosPaymentReportResponseModel.fromJson(Map<String, dynamic> json) {
    transactionDateTime = json['transactionDateTime'];
    terminalId = json['terminalId'];
    transactionId = json['transactionId'];
    id = json['id'];
    transactionType = json['transactionType'];
    transactionAmount = json['transactionAmount'];
    sadadCharges = json['sadadCharges'];
    currrency = json['currrency'];
    transactionStatus = json['transactionStatus'];
    rRN = json['RRN'];
    paymentMethods = json['paymentMethods'];
    cardType = json['cardType'];
    cardEnteredType = json['cardEnteredType'];
    maskedCardNumber = json['maskedCardNumber'];
    cardHolderName = json['cardHolderName'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    sadadMerchantId = json['sadadMerchantId'];
    terminalName = json['terminalName'];
    terminalLocation = json['terminalLocation'];
    terminalStatus = json['terminalStatus'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    deviceStatus = json['deviceStatus'];
    deviceSerialNo = json['deviceSerialNo'];
    refundId = json['refundId'];
    refundRRN = json['refundRRN'];
    refundAmount = json['refundAmount'];
    refundRequestedDateTime = json['refundRequestedDateTime'];
    refundStatus = json['refundStatus'];
    disputeId = json['disputeId'];
    disputeCreatedDateTime = json['disputeCreatedDateTime'];
    disputeAmouont = json['disputeAmouont'];
    disputeType = json['disputeType'];
    disputeStatus = json['disputeStatus'];
    comments = json['comments'];
    isActive = json['is_active'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionDateTime'] = this.transactionDateTime;
    data['terminalId'] = this.terminalId;
    data['transactionId'] = this.transactionId;
    data['id'] = this.id;
    data['transactionType'] = this.transactionType;
    data['transactionAmount'] = this.transactionAmount;
    data['sadadCharges'] = this.sadadCharges;
    data['currrency'] = this.currrency;
    data['transactionStatus'] = this.transactionStatus;
    data['RRN'] = this.rRN;
    data['paymentMethods'] = this.paymentMethods;
    data['cardType'] = this.cardType;
    data['cardEnteredType'] = this.cardEnteredType;
    data['maskedCardNumber'] = this.maskedCardNumber;
    data['cardHolderName'] = this.cardHolderName;
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['sadadMerchantId'] = this.sadadMerchantId;
    data['terminalName'] = this.terminalName;
    data['terminalLocation'] = this.terminalLocation;
    data['terminalStatus'] = this.terminalStatus;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['deviceStatus'] = this.deviceStatus;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['refundId'] = this.refundId;
    data['refundRRN'] = this.refundRRN;
    data['refundAmount'] = this.refundAmount;
    data['refundRequestedDateTime'] = this.refundRequestedDateTime;
    data['refundStatus'] = this.refundStatus;
    data['disputeId'] = this.disputeId;
    data['disputeCreatedDateTime'] = this.disputeCreatedDateTime;
    data['disputeAmouont'] = this.disputeAmouont;
    data['disputeType'] = this.disputeType;
    data['disputeStatus'] = this.disputeStatus;
    data['comments'] = this.comments;
    data['is_active'] = this.isActive;
    data['is_online'] = this.isOnline;
    return data;
  }
}
