class PosSplineChartResponseModel {
  List<String>? labels;
  PSData? data;
  bool? isEmpty;

  PosSplineChartResponseModel({this.labels, this.data, this.isEmpty});

  PosSplineChartResponseModel.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    data = json['data'] != null ? new PSData.fromJson(json['data']) : null;
    isEmpty = json["isEmpty"] == null ? false : json["isEmpty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labels'] = this.labels;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isEmpty'] = this.isEmpty;
    return data;
  }
}

class PSData {
  Counter? counter;
  Counter? amount;

  PSData({this.counter, this.amount});

  PSData.fromJson(Map<String, dynamic> json) {
    counter =
        json['counter'] != null ? new Counter.fromJson(json['counter']) : null;
    amount =
        json['amount'] != null ? new Counter.fromJson(json['amount']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.counter != null) {
      data['counter'] = this.counter!.toJson();
    }
    if (this.amount != null) {
      data['amount'] = this.amount!.toJson();
    }
    return data;
  }
}

class Counter {
  Success? success;
  Success? failure;

  Counter({this.success, this.failure});

  Counter.fromJson(Map<String, dynamic> json) {
    success =
        json['success'] != null ? new Success.fromJson(json['success']) : null;
    failure =
        json['failure'] != null ? new Success.fromJson(json['failure']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.failure != null) {
      data['failure'] = this.failure!.toJson();
    }
    return data;
  }
}

class Success {
  List<dynamic>? active;
  List<dynamic>? inactive;
  List<dynamic>? all;

  Success({this.active, this.inactive, this.all});

  Success.fromJson(Map<String, dynamic> json) {
    active = json['active'].cast<dynamic>();
    inactive = json['inactive'].cast<dynamic>();
    all = json['all'].cast<dynamic>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['inactive'] = this.inactive;
    data['all'] = this.all;
    return data;
  }
}
