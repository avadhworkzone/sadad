class ECommerceCounterResponseModel {
  var successRate;
  var successTxnAmnt;
  var refundAccepted;
  var transactions;
  var invoiceAmount;
  var invoiceCount;
  var subscriptionAmnt;
  var subscriptions;
  var soldProductAmnt;
  var orderCount;
  var productCounts;
  var storeProdCounts;
  var payoutReceived;

  ECommerceCounterResponseModel(
      {this.successRate,
      this.successTxnAmnt,
      this.refundAccepted,
      this.transactions,
      this.invoiceAmount,
      this.invoiceCount,
      this.subscriptionAmnt,
      this.subscriptions,
      this.soldProductAmnt,
      this.orderCount,
      this.productCounts,
      this.payoutReceived,
      this.storeProdCounts});

  ECommerceCounterResponseModel.fromJson(Map<String, dynamic> json) {
    successRate = json['successRate'];
    successTxnAmnt = json['successTxnAmnt'];
    refundAccepted = json['refundAccepted'];
    transactions = json['transactions'];
    invoiceAmount = json['invoiceAmount'];
    invoiceCount = json['invoiceCount'];
    subscriptionAmnt = json['subscriptionAmnt'];
    subscriptions = json['subscriptions'];
    soldProductAmnt = json['soldProductAmnt'];
    orderCount = json['orderCount'];
    productCounts = json['productCounts'];
    storeProdCounts = json['storeProdCounts'];
    payoutReceived = json['payoutReceived'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['successRate'] = this.successRate;
    data['successTxnAmnt'] = this.successTxnAmnt;
    data['refundAccepted'] = this.refundAccepted;
    data['transactions'] = this.transactions;
    data['invoiceAmount'] = this.invoiceAmount;
    data['invoiceCount'] = this.invoiceCount;
    data['subscriptionAmnt'] = this.subscriptionAmnt;
    data['subscriptions'] = this.subscriptions;
    data['soldProductAmnt'] = this.soldProductAmnt;
    data['orderCount'] = this.orderCount;
    data['productCounts'] = this.productCounts;
    data['storeProdCounts'] = this.storeProdCounts;
    data['payoutReceived'] = this.payoutReceived;
    return data;
  }
}
