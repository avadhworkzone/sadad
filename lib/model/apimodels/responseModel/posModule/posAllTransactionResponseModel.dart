class PosAllTransactionCountResponseModel {
  var totalAuthorizations;
  var grossSales;
  var netSales;
  var amountReceived;
  var amountRefunded;
  var successTransaction;
  var activeTerminals;
  var inactiveTerminals;
  var successRatio;

  PosAllTransactionCountResponseModel(
      {this.totalAuthorizations,
      this.grossSales,
      this.netSales,
      this.amountReceived,
      this.amountRefunded,
      this.successTransaction,
      this.activeTerminals,
      this.inactiveTerminals,
      this.successRatio});

  PosAllTransactionCountResponseModel.fromJson(Map<String, dynamic> json) {
    totalAuthorizations = json['totalAuthorizations'];
    grossSales = json['grossSales'];
    netSales = json['netSales'];
    amountReceived = json['amountReceived'];
    amountRefunded = json['amountRefunded'];
    successTransaction = json['successTransaction'];
    activeTerminals = json['activeTerminals'];
    inactiveTerminals = json['inactiveTerminals'];
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
    data['activeTerminals'] = this.activeTerminals;
    data['inactiveTerminals'] = this.inactiveTerminals;
    data['successRatio'] = this.successRatio;
    return data;
  }
}
