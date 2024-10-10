class TerminalBatchSummaryResModel {
  var terminalId;
  var location;
  var deviceSerialNo;
  var activated;
  var terminalName;

  List<PaymentMethodData>? paymentMethodData;

  TerminalBatchSummaryResModel(
      {this.terminalId,
      this.location,
      this.deviceSerialNo,
      this.activated,
      this.terminalName,
      this.paymentMethodData});

  TerminalBatchSummaryResModel.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    location = json['location'];
    activated = json['activated'];
    terminalName = json['name'];
    deviceSerialNo = json['deviceSerialNo'];
    if (json['paymentMethodData'] != null) {
      paymentMethodData = <PaymentMethodData>[];
      json['paymentMethodData'].forEach((v) {
        paymentMethodData!.add(new PaymentMethodData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['name'] = this.terminalName;
    data['location'] = this.location;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['activated'] = this.activated;
    if (this.paymentMethodData != null) {
      data['paymentMethodData'] =
          this.paymentMethodData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentMethodData {
  List? sales;
  List? refunds;
  List? preauth;

  PaymentMethodData({this.sales, this.refunds, this.preauth});

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    if (json['sales'] != null) {
      sales = [];
      json['sales'].forEach((v) {
        //sales!.add(new Sales.fromJson(v));
        sales!.add(v);
      });
    }
    if (json['refunds'] != null) {
      refunds = [];
      json['refunds'].forEach((v) {
        //refunds!.add(new Sales.fromJson(v));
        refunds!.add(v);
      });
    }
    if (json['preauth'] != null) {
      preauth = [];
      json['preauth'].forEach((v) {
        //preauth!.add(new Sales.fromJson(v));
        preauth!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sales != null) {
      data['sales'] = this.sales!.map((v) => v.toJson()).toList();
    }
    if (this.refunds != null) {
      data['refunds'] = this.refunds!.map((v) => v.toJson()).toList();
    }
    if (this.preauth != null) {
      data['preauth'] = this.preauth!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sales {
  MASTERCARD? mASTERCARD;
  MASTERCARD? vISA;
  MASTERCARD? aMERICANEXPRESS;
  NAPS? nAPS;

  Sales({this.mASTERCARD, this.vISA, this.aMERICANEXPRESS, this.nAPS});

  Sales.fromJson(Map<String, dynamic> json) {
    mASTERCARD = json['MASTERCARD'] != null
        ? new MASTERCARD.fromJson(json['MASTERCARD'])
        : null;
    vISA = json['VISA'] != null ? new MASTERCARD.fromJson(json['VISA']) : null;
    aMERICANEXPRESS = json['AMERICAN EXPRESS'] != null
        ? new MASTERCARD.fromJson(json['AMERICAN EXPRESS'])
        : null;
    nAPS = json['NAPS'] != null ? new NAPS.fromJson(json['NAPS']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mASTERCARD != null) {
      data['MASTERCARD'] = this.mASTERCARD!.toJson();
    }
    if (this.vISA != null) {
      data['VISA'] = this.vISA!.toJson();
    }
    if (this.aMERICANEXPRESS != null) {
      data['AMERICAN EXPRESS'] = this.aMERICANEXPRESS!.toJson();
    }
    if (this.nAPS != null) {
      data['NAPS'] = this.nAPS!.toJson();
    }
    return data;
  }
}

class MASTERCARD {
  var count;
  var amount;

  MASTERCARD({this.count, this.amount});

  MASTERCARD.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['amount'] = this.amount;
    return data;
  }
}

class NAPS {
  var count;
  var amount;

  NAPS({this.count, this.amount});

  NAPS.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['amount'] = this.amount;
    return data;
  }
}
