class PosCounterResponseModel {
  var successRate;
  var successTxnAmnt;
  var refundAccepted;
  var transactions;
  var terminals;
  var activeTerminals;
  var inactiveTerminals;
  var devices;

  PosCounterResponseModel(
      {this.successRate,
      this.successTxnAmnt,
      this.refundAccepted,
      this.transactions,
      this.terminals,
      this.activeTerminals,
      this.inactiveTerminals,
      this.devices});

  PosCounterResponseModel.fromJson(Map<String, dynamic> json) {
    successRate = json['successRate'];
    successTxnAmnt = json['successTxnAmnt'];
    refundAccepted = json['refundAccepted'];
    transactions = json['transactions'];
    terminals = json['terminals'];
    activeTerminals = json['activeTerminals'];
    inactiveTerminals = json['inactiveTerminals'];
    devices = json['devices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['successRate'] = this.successRate;
    data['successTxnAmnt'] = this.successTxnAmnt;
    data['refundAccepted'] = this.refundAccepted;
    data['transactions'] = this.transactions;
    data['terminals'] = this.terminals;
    data['activeTerminals'] = this.activeTerminals;
    data['inactiveTerminals'] = this.inactiveTerminals;
    data['devices'] = this.devices;
    return data;
  }
}
