class DoRefundTransactionResponseModel {
  var entityid;
  var invoicenumber;
  bool? verificationstatus;
  bool? isRefund;
  var isPartialRefund;
  var amount;
  var createdby;
  var modifiedby;
  var servicecharge;
  var servicechargedescription;
  var transactionSummary;
  var txnip;
  var cardholdername;
  var bincardstatusvalue;
  var txniptrackervalue;
  var isSuspicious;
  bool? isFraud;
  List<OsHistory>? osHistory;
  var refundcharge;
  Refundchargedescription? refundchargedescription;
  var refundType;
  var partialRefundRemainAmount;
  var transactionNote;
  List<TxnBankStatus>? txnBankStatus;
  var cardtype;
  var sourceofTxn;
  bool? isDisputed;
  var id;
  var transactiondate;
  var deletedAt;
  var created;
  var modified;
  var transactionentityId;
  var transactionmodeId;
  var transactionstatusId;
  TrackerValue? trackerValue;
  var senderId;
  var receiverId;

  DoRefundTransactionResponseModel(
      {this.entityid,
      this.invoicenumber,
      this.verificationstatus,
      this.isRefund,
      this.isPartialRefund,
      this.amount,
      this.createdby,
      this.modifiedby,
      this.servicecharge,
      this.servicechargedescription,
      this.transactionSummary,
      this.txnip,
      this.cardholdername,
      this.bincardstatusvalue,
      this.txniptrackervalue,
      this.isSuspicious,
      this.isFraud,
      this.osHistory,
      this.refundcharge,
      this.refundchargedescription,
      this.refundType,
      this.partialRefundRemainAmount,
      this.transactionNote,
      this.txnBankStatus,
      this.cardtype,
      this.sourceofTxn,
      this.isDisputed,
      this.id,
      this.transactiondate,
      this.deletedAt,
      this.created,
      this.modified,
      this.transactionentityId,
      this.transactionmodeId,
      this.transactionstatusId,
      this.trackerValue,
      this.senderId,
      this.receiverId});

  DoRefundTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    entityid = json['entityid'];
    invoicenumber = json['invoicenumber'];
    verificationstatus = json['verificationstatus'];
    isRefund = json['isRefund'];
    isPartialRefund = json['isPartialRefund'];
    amount = json['amount'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    servicecharge = json['servicecharge'];
    servicechargedescription = json['servicechargedescription'];
    transactionSummary = json['transaction_summary'];
    txnip = json['txnip'];
    cardholdername = json['cardholdername'];
    bincardstatusvalue = json['bincardstatusvalue'];
    txniptrackervalue = json['txniptrackervalue'];
    isSuspicious = json['is_suspicious'];
    isFraud = json['isFraud'];
    if (json['os_history'] != null) {
      osHistory = <OsHistory>[];
      json['os_history'].forEach((v) {
        osHistory!.add(new OsHistory.fromJson(v));
      });
    }
    refundcharge = json['refundcharge'];
    refundchargedescription = json['refundchargedescription'] != null
        ? new Refundchargedescription.fromJson(json['refundchargedescription'])
        : null;
    refundType = json['refund_type'];
    partialRefundRemainAmount = json['partialRefundRemainAmount'];
    transactionNote = json['transaction_note'];
    if (json['txn_bank_status'] != null) {
      txnBankStatus = <TxnBankStatus>[];
      json['txn_bank_status'].forEach((v) {
        txnBankStatus!.add(new TxnBankStatus.fromJson(v));
      });
    }
    cardtype = json['cardtype'];
    sourceofTxn = json['sourceofTxn'];
    isDisputed = json['isDisputed'];
    id = json['id'];
    transactiondate = json['transactiondate'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    transactionentityId = json['transactionentityId'];
    transactionmodeId = json['transactionmodeId'];
    transactionstatusId = json['transactionstatusId'];
    trackerValue = json['tracker_value'] != null
        ? new TrackerValue.fromJson(json['tracker_value'])
        : null;
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityid'] = this.entityid;
    data['invoicenumber'] = this.invoicenumber;
    data['verificationstatus'] = this.verificationstatus;
    data['isRefund'] = this.isRefund;
    data['isPartialRefund'] = this.isPartialRefund;
    data['amount'] = this.amount;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['servicecharge'] = this.servicecharge;
    data['servicechargedescription'] = this.servicechargedescription;
    data['transaction_summary'] = this.transactionSummary;
    data['txnip'] = this.txnip;
    data['cardholdername'] = this.cardholdername;
    data['bincardstatusvalue'] = this.bincardstatusvalue;
    data['txniptrackervalue'] = this.txniptrackervalue;
    data['is_suspicious'] = this.isSuspicious;
    data['isFraud'] = this.isFraud;
    if (this.osHistory != null) {
      data['os_history'] = this.osHistory!.map((v) => v.toJson()).toList();
    }
    data['refundcharge'] = this.refundcharge;
    if (this.refundchargedescription != null) {
      data['refundchargedescription'] = this.refundchargedescription!.toJson();
    }
    data['refund_type'] = this.refundType;
    data['partialRefundRemainAmount'] = this.partialRefundRemainAmount;
    data['transaction_note'] = this.transactionNote;
    if (this.txnBankStatus != null) {
      data['txn_bank_status'] =
          this.txnBankStatus!.map((v) => v.toJson()).toList();
    }
    data['cardtype'] = this.cardtype;
    data['sourceofTxn'] = this.sourceofTxn;
    data['isDisputed'] = this.isDisputed;
    data['id'] = this.id;
    data['transactiondate'] = this.transactiondate;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['transactionentityId'] = this.transactionentityId;
    data['transactionmodeId'] = this.transactionmodeId;
    data['transactionstatusId'] = this.transactionstatusId;
    if (this.trackerValue != null) {
      data['tracker_value'] = this.trackerValue!.toJson();
    }
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    return data;
  }
}

class OsHistory {
  var datetime;
  var os;

  OsHistory({this.datetime, this.os});

  OsHistory.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    os = json['os'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['os'] = this.os;
    return data;
  }
}

class Refundchargedescription {
  var percentage;
  var percentageAmount;
  var fixedCharges;
  var finalRefundCharges;

  Refundchargedescription(
      {this.percentage,
      this.percentageAmount,
      this.fixedCharges,
      this.finalRefundCharges});

  Refundchargedescription.fromJson(Map<String, dynamic> json) {
    percentage = json['Percentage'];
    percentageAmount = json['PercentageAmount'];
    fixedCharges = json['FixedCharges'];
    finalRefundCharges = json['finalRefundCharges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Percentage'] = this.percentage;
    data['PercentageAmount'] = this.percentageAmount;
    data['FixedCharges'] = this.fixedCharges;
    data['finalRefundCharges'] = this.finalRefundCharges;
    return data;
  }
}

class TxnBankStatus {
  var date;
  var txnID;
  var code;
  var message;

  TxnBankStatus({this.date, this.txnID, this.code, this.message});

  TxnBankStatus.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    txnID = json['TxnID'];
    code = json['Code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['TxnID'] = this.txnID;
    data['Code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class TrackerValue {
  var ip;
  var city;
  var countryCodeFull;

  TrackerValue({this.ip, this.city, this.countryCodeFull});

  TrackerValue.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    city = json['city'];
    countryCodeFull = json['country_code_full'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this.ip;
    data['city'] = this.city;
    data['country_code_full'] = this.countryCodeFull;
    return data;
  }
}
