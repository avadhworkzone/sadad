class OnlineTransactionReportResponse {
  var count;
  List<OnlineTransReportData>? data;

  OnlineTransactionReportResponse({this.count, this.data});

  OnlineTransactionReportResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <OnlineTransReportData>[];
      json['data'].forEach((v) {
        data!.add(new OnlineTransReportData.fromJson(v));
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

class OnlineTransReportData {
  var transactionDateTime;
  var transactionId;
  var transactionType;
  var transactionAmount;
  var sadadCharges;
  var currency;
  var transactionStatus;
  var invoiceNumber;
  var invoiceCreated;
  var invoiceDescription;
  var username;
  var rrn;
  var paymentMethods;
  var cardType;
  var sadadMerchantId;
  var maskedCardNumber;
  var cardHolderName;
  var alphaCountry;
  var binCountry;
  var customerName;
  var customerEmailId;
  var customerMobileNumber;
  var originatedIp;
  var authenticationStatus;
  var eci;
  var responseCode;
  var responseMessage;
  var traxOrigin;
  var transactionSource;
  var integrationSource;
  var authNumber;
  var refundId;
  var refundRequestedDateTime;
  var refundAmount;
  var refundCharges;
  var refundStatus;
  var refundType;
  var disputeId;
  var disputeCreatedDateTime;
  var disputeAmount;
  var disputeType;
  var disputeStatus;
  var comments;
  var city;
  var country;
  var address1;
  var address2;
  var transferType;
  var inOut;
  var id;

  OnlineTransReportData(
      {this.transactionDateTime,
      this.transactionId,
      this.transactionType,
      this.transactionAmount,
      this.sadadCharges,
      this.currency,
      this.transactionStatus,
      this.invoiceNumber,
      this.invoiceCreated,
      this.invoiceDescription,
      this.username,
      this.rrn,
      this.paymentMethods,
      this.cardType,
      this.sadadMerchantId,
      this.maskedCardNumber,
      this.cardHolderName,
      this.alphaCountry,
      this.binCountry,
      this.customerName,
      this.customerEmailId,
      this.customerMobileNumber,
      this.originatedIp,
      this.authenticationStatus,
      this.eci,
      this.responseCode,
      this.responseMessage,
      this.traxOrigin,
      this.transactionSource,
      this.integrationSource,
      this.authNumber,
      this.refundId,
      this.refundRequestedDateTime,
      this.refundAmount,
      this.refundCharges,
      this.refundStatus,
      this.refundType,
      this.disputeId,
      this.disputeCreatedDateTime,
      this.disputeAmount,
      this.disputeType,
      this.disputeStatus,
      this.comments,
      this.city,
      this.country,
      this.address1,
      this.address2,
      this.transferType,
      this.id,
      this.inOut});

  OnlineTransReportData.fromJson(Map<String, dynamic> json) {
    transactionDateTime = json['transactionDateTime'];
    transactionId = json['transactionId'];
    transactionType = json['transactionType'];
    transactionAmount = json['transactionAmount'];
    sadadCharges = json['sadadCharges'];
    currency = json['currency'];
    transactionStatus = json['transactionStatus'];
    invoiceNumber = json['invoiceNumber'];
    invoiceCreated = json['invoiceCreated'];
    invoiceDescription = json['invoiceDescription'];
    username = json['username'];
    rrn = json['rrn'];
    paymentMethods = json['paymentMethods'];
    cardType = json['cardType'];
    sadadMerchantId = json['sadadMerchantId'];
    maskedCardNumber = json['maskedCardNumber'];
    cardHolderName = json['cardHolderName'];
    alphaCountry = json['alphaCountry'];
    binCountry = json['binCountry'];
    customerName = json['customerName'];
    customerEmailId = json['customerEmailId'];
    customerMobileNumber = json['customerMobileNumber'];
    originatedIp = json['originatedIp'];
    authenticationStatus = json['authenticationStatus'];
    eci = json['eci'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    traxOrigin = json['traxOrigin'];
    transactionSource = json['transactionSource'];
    integrationSource = json['integrationSource'];
    authNumber = json['authNumber'];
    refundId = json['refundId'];
    refundRequestedDateTime = json['refundRequestedDateTime'];
    refundAmount = json['refundAmount'];
    refundCharges = json['refundCharges'];
    refundStatus = json['refundStatus'];
    refundType = json['refundType'];
    disputeId = json['disputeId'];
    disputeCreatedDateTime = json['disputeCreatedDateTime'];
    disputeAmount = json['disputeAmount'];
    disputeType = json['disputeType'];
    disputeStatus = json['disputeStatus'];
    comments = json['comments'];
    city = json['city'];
    country = json['country'];
    address1 = json['address1'];
    address2 = json['address2'];
    transferType = json['transferType'];
    inOut = json['InOut'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionDateTime'] = this.transactionDateTime;
    data['transactionId'] = this.transactionId;
    data['transactionType'] = this.transactionType;
    data['transactionAmount'] = this.transactionAmount;
    data['sadadCharges'] = this.sadadCharges;
    data['currency'] = this.currency;
    data['transactionStatus'] = this.transactionStatus;
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceCreated'] = this.invoiceCreated;
    data['invoiceDescription'] = this.invoiceDescription;
    data['username'] = this.username;
    data['rrn'] = this.rrn;
    data['paymentMethods'] = this.paymentMethods;
    data['cardType'] = this.cardType;
    data['sadadMerchantId'] = this.sadadMerchantId;
    data['maskedCardNumber'] = this.maskedCardNumber;
    data['cardHolderName'] = this.cardHolderName;
    data['alphaCountry'] = this.alphaCountry;
    data['binCountry'] = this.binCountry;
    data['customerName'] = this.customerName;
    data['customerEmailId'] = this.customerEmailId;
    data['customerMobileNumber'] = this.customerMobileNumber;
    data['originatedIp'] = this.originatedIp;
    data['authenticationStatus'] = this.authenticationStatus;
    data['eci'] = this.eci;
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['traxOrigin'] = this.traxOrigin;
    data['transactionSource'] = this.transactionSource;
    data['integrationSource'] = this.integrationSource;
    data['authNumber'] = this.authNumber;
    data['refundId'] = this.refundId;
    data['refundRequestedDateTime'] = this.refundRequestedDateTime;
    data['refundAmount'] = this.refundAmount;
    data['refundCharges'] = this.refundCharges;
    data['refundStatus'] = this.refundStatus;
    data['refundType'] = this.refundType;
    data['disputeId'] = this.disputeId;
    data['disputeCreatedDateTime'] = this.disputeCreatedDateTime;
    data['disputeAmount'] = this.disputeAmount;
    data['disputeType'] = this.disputeType;
    data['disputeStatus'] = this.disputeStatus;
    data['comments'] = this.comments;
    data['city'] = this.city;
    data['country'] = this.country;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['transferType'] = this.transferType;
    data['InOut'] = this.inOut;
    data['id'] = this.id;
    return data;
  }
}
