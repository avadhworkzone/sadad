class OnlineTransactionResponseModel {
  var totalAuthorizations;
  var grossSales;
  var netSales;
  var amountReceived;
  var amountRefunded;
  var successTransaction;
  var successRatio;

  OnlineTransactionResponseModel(
      {this.totalAuthorizations,
      this.grossSales,
      this.netSales,
      this.amountReceived,
      this.amountRefunded,
      this.successTransaction,
      this.successRatio});

  OnlineTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    totalAuthorizations = json['totalAuthorizations'];
    grossSales = json['grossSales'];
    netSales = json['netSales'];
    amountReceived = json['amountReceived'];
    amountRefunded = json['amountRefunded'];
    successTransaction = json['successTransaction'];
    successRatio = json['successRatio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAuthorizations'] = this.totalAuthorizations;
    data['grossSales'] = this.grossSales;
    data['netSales'] = this.netSales;
    data['amountReceived'] = this.amountReceived;
    data['amountRefunded'] = this.amountRefunded;
    data['successTransaction'] = this.successTransaction;
    data['successRatio'] = this.successRatio;
    return data;
  }
}
