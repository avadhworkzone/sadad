class SubscriptionReportResponseModel {
  var count;
  List<SubData>? subData;

  SubscriptionReportResponseModel({this.count, this.subData});

  SubscriptionReportResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      subData = <SubData>[];
      json['data'].forEach((v) {
        subData!.add(new SubData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.subData != null) {
      data['data'] = this.subData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubData {
  var transactionId;
  var subscriptionId;
  var subscriptionPaidDate;
  var nextDuePaymentDate;
  var subscriberId;
  var subscriptionPaymentStatus;
  var subscriptionAmount;
  var totalSubscriptionPaid;
  var subscriptionFrequency;
  var subscriberName;
  var subscriberEmailId;
  var subscriberMobileNumber;
  var shippingAddress;
  var productName;
  var productDescription;
  var productPlanId;

  SubData(
      {this.transactionId,
      this.subscriptionId,
      this.subscriptionPaidDate,
      this.nextDuePaymentDate,
      this.subscriberId,
      this.subscriptionPaymentStatus,
      this.subscriptionAmount,
      this.totalSubscriptionPaid,
      this.subscriptionFrequency,
      this.subscriberName,
      this.subscriberEmailId,
      this.subscriberMobileNumber,
      this.shippingAddress,
      this.productName,
      this.productDescription,
      this.productPlanId});

  SubData.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    subscriptionId = json['subscriptionId'];
    subscriptionPaidDate = json['subscriptionPaidDate'];
    nextDuePaymentDate = json['nextDuePaymentDate'];
    subscriberId = json['subscriberId'];
    subscriptionPaymentStatus = json['subscriptionPaymentStatus'];
    subscriptionAmount = json['subscriptionAmount'];
    totalSubscriptionPaid = json['totalSubscriptionPaid'];
    subscriptionFrequency = json['subscriptionFrequency'];
    subscriberName = json['subscriberName'];
    subscriberEmailId = json['subscriberEmailId'];
    subscriberMobileNumber = json['subscriberMobileNumber'];
    shippingAddress = json['shippingAddress'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productPlanId = json['productPlanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['subscriptionId'] = this.subscriptionId;
    data['subscriptionPaidDate'] = this.subscriptionPaidDate;
    data['nextDuePaymentDate'] = this.nextDuePaymentDate;
    data['subscriberId'] = this.subscriberId;
    data['subscriptionPaymentStatus'] = this.subscriptionPaymentStatus;
    data['subscriptionAmount'] = this.subscriptionAmount;
    data['totalSubscriptionPaid'] = this.totalSubscriptionPaid;
    data['subscriptionFrequency'] = this.subscriptionFrequency;
    data['subscriberName'] = this.subscriberName;
    data['subscriberEmailId'] = this.subscriberEmailId;
    data['subscriberMobileNumber'] = this.subscriberMobileNumber;
    data['shippingAddress'] = this.shippingAddress;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['productPlanId'] = this.productPlanId;
    return data;
  }
}
