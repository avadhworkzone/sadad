class BalanceListResponseModel {
  var count;
  List<BalanceData>? data;

  BalanceListResponseModel({this.count, this.data});

  BalanceListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <BalanceData>[];
      json['data'].forEach((v) {
        data!.add(new BalanceData.fromJson(v));
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

class BalanceData {
  var date;
  var transactionId;
  var terminalId;
  var txnSource;
  var txnType;
  var txnAmount;
  var servicecharge;
  var paymentIn;
  var paymentOut;
  var accountBalance;

  BalanceData(
      {this.date,
      this.transactionId,
      this.terminalId,
      this.txnSource,
      this.txnType,
      this.txnAmount,
      this.servicecharge,
      this.paymentIn,
      this.paymentOut,
      this.accountBalance});

  BalanceData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    transactionId = json['transactionId'];
    terminalId = json['terminalId'];
    txnSource = json['txnSource'];
    txnType = json['txnType'];
    txnAmount = json['txnAmount'];
    servicecharge = json['servicecharge'];
    paymentIn = json['paymentIn'];
    paymentOut = json['paymentOut'];
    accountBalance = json['accountBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['transactionId'] = this.transactionId;
    data['terminalId'] = this.terminalId;
    data['txnSource'] = this.txnSource;
    data['txnType'] = this.txnType;
    data['txnAmount'] = this.txnAmount;
    data['servicecharge'] = this.servicecharge;
    data['paymentIn'] = this.paymentIn;
    data['paymentOut'] = this.paymentOut;
    data['accountBalance'] = this.accountBalance;
    return data;
  }
}
