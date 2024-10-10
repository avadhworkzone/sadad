class TerminalReportResponseModel {
  var count;
  List<TerminalData>? data;

  TerminalReportResponseModel({this.count, this.data});

  TerminalReportResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <TerminalData>[];
      json['data'].forEach((v) {
        data!.add(new TerminalData.fromJson(v));
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

class TerminalData {
  var terminalId;
  var terminalLocation;
  var terminalName;
  var terminalType;
  var deviceSerialNumber;
  var terminalCreatedDate;
  var terminalStatus;
  var lastTransactionDate;
  var totalSuccessTransactionsAmount;
  var totalSuccessTransactionsCount;
  var transactionMode;
  var paymentMethods;
  var cardEntryTypes;
  var city;
  var location;
  var loginId;
  var currentDeviceId;
  var previousDeviceId;
  var comments;
  var deviceSerialNo;
  var deviceType;
  var deviceId;
  var imei;
  var status;
  var deviceStatus;
  var terminalActivated;
  var terminalDeactivated;

  TerminalData(
      {this.terminalId,
      this.terminalLocation,
      this.terminalName,
      this.terminalType,
      this.deviceSerialNumber,
      this.terminalCreatedDate,
      this.terminalStatus,
      this.lastTransactionDate,
      this.totalSuccessTransactionsAmount,
      this.totalSuccessTransactionsCount,
      this.transactionMode,
      this.paymentMethods,
      this.cardEntryTypes,
      this.city,
      this.location,
      this.loginId,
      this.currentDeviceId,
      this.previousDeviceId,
      this.comments,
      this.deviceSerialNo,
      this.deviceType,
      this.deviceId,
      this.imei,
      this.status,
      this.deviceStatus,
      this.terminalActivated,
      this.terminalDeactivated});

  TerminalData.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    terminalLocation = json['terminalLocation'];
    terminalName = json['terminalName'];
    terminalType = json['terminalType'];
    deviceSerialNumber = json['deviceSerialNumber'];
    terminalCreatedDate = json['terminalCreatedDate'];
    terminalStatus = json['terminalStatus'];
    lastTransactionDate = json['lastTransactionDate'];
    totalSuccessTransactionsAmount = json['totalSuccessTransactionsAmount'];
    totalSuccessTransactionsCount = json['totalSuccessTransactionsCount'];
    transactionMode = json['transactionMode'];
    paymentMethods = json['paymentMethods'];
    cardEntryTypes = json['cardEntryTypes'];
    city = json['city'];
    location = json['location'];
    loginId = json['loginId'];
    currentDeviceId = json['currentDeviceId'];
    previousDeviceId = json['previousDeviceId'];
    comments = json['comments'];
    deviceSerialNo = json['deviceSerialNo'];
    deviceType = json['deviceType'];
    deviceId = json['deviceId'];
    imei = json['imei'];
    status = json['status'];
    deviceStatus = json['deviceStatus'];
    terminalActivated = json['TerminalActivated'];
    terminalDeactivated = json['TerminalDeactivated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['terminalLocation'] = this.terminalLocation;
    data['terminalName'] = this.terminalName;
    data['terminalType'] = this.terminalType;
    data['deviceSerialNumber'] = this.deviceSerialNumber;
    data['terminalCreatedDate'] = this.terminalCreatedDate;
    data['terminalStatus'] = this.terminalStatus;
    data['lastTransactionDate'] = this.lastTransactionDate;
    data['totalSuccessTransactionsAmount'] =
        this.totalSuccessTransactionsAmount;
    data['totalSuccessTransactionsCount'] = this.totalSuccessTransactionsCount;
    data['transactionMode'] = this.transactionMode;
    data['paymentMethods'] = this.paymentMethods;
    data['cardEntryTypes'] = this.cardEntryTypes;
    data['city'] = this.city;
    data['location'] = this.location;
    data['loginId'] = this.loginId;
    data['currentDeviceId'] = this.currentDeviceId;
    data['previousDeviceId'] = this.previousDeviceId;
    data['comments'] = this.comments;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['deviceType'] = this.deviceType;
    data['deviceId'] = this.deviceId;
    data['imei'] = this.imei;
    data['status'] = this.status;
    data['deviceStatus'] = this.deviceStatus;
    data['TerminalActivated'] = this.terminalActivated;
    data['TerminalDeactivated'] = this.terminalDeactivated;
    return data;
  }
}
