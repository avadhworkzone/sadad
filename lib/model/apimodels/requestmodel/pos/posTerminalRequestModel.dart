class PosTerminalRequestModel {
  List<Requestedposdata>? requestedposdata;
  int? txnvolumerangeId;
  bool? isaccepted;

  PosTerminalRequestModel(
      {this.requestedposdata, this.txnvolumerangeId, this.isaccepted});

  PosTerminalRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['requestedposdata'] != null) {
      requestedposdata = <Requestedposdata>[];
      json['requestedposdata'].forEach((v) {
        requestedposdata!.add(new Requestedposdata.fromJson(v));
      });
    }
    txnvolumerangeId = json['txnvolumerangeId'];
    isaccepted = json['isaccepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requestedposdata != null) {
      data['requestedposdata'] =
          this.requestedposdata!.map((v) => v.toJson()).toList();
    }
    data['txnvolumerangeId'] = this.txnvolumerangeId;
    data['isaccepted'] = this.isaccepted;
    return data;
  }
}

class Requestedposdata {
  int? deviceId;
  int? quantity;

  Requestedposdata({this.deviceId, this.quantity});

  Requestedposdata.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['quantity'] = this.quantity;
    return data;
  }
}
