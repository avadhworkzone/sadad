class PosPaymentMethodResponseModel {
  Counter? counter;
  Counter? amount;
  bool? isEmpty;

  PosPaymentMethodResponseModel({this.counter, this.amount, this.isEmpty});

  PosPaymentMethodResponseModel.fromJson(Map<String, dynamic> json) {
    counter =
        json['counter'] != null ? new Counter.fromJson(json['counter']) : null;
    amount =
        json['amount'] != null ? new Counter.fromJson(json['amount']) : null;
    isEmpty = isEmpty = json['isEmpty'] == null ? false : json['isEmpty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.counter != null) {
      data['counter'] = this.counter!.toJson();
    }
    if (this.amount != null) {
      data['amount'] = this.amount!.toJson();
    }
    data['isEmpty'] = this.isEmpty;
    return data;
  }
}

class Counter {
  Success? success;
  Success? failure;
  Success? both;

  Counter({this.success, this.failure, this.both});

  Counter.fromJson(Map<String, dynamic> json) {
    success =
        json['success'] != null ? new Success.fromJson(json['success']) : null;
    failure =
        json['failure'] != null ? new Success.fromJson(json['failure']) : null;
    both = json['both'] != null ? new Success.fromJson(json['both']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.failure != null) {
      data['failure'] = this.failure!.toJson();
    }
    if (this.both != null) {
      data['both'] = this.both!.toJson();
    }
    return data;
  }
}

class Success {
  List<Active>? active;
  List<Inactive>? inactive;
  List<All>? all;

  Success({this.active, this.inactive, this.all});

  Success.fromJson(Map<String, dynamic> json) {
    if (json['active'] != null) {
      active = <Active>[];
      json['active'].forEach((v) {
        active!.add(new Active.fromJson(v));
      });
    }
    if (json['inactive'] != null) {
      inactive = <Inactive>[];
      json['inactive'].forEach((v) {
        inactive!.add(new Inactive.fromJson(v));
      });
    }
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all!.add(new All.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.active != null) {
      data['active'] = this.active!.map((v) => v.toJson()).toList();
    }
    if (this.inactive != null) {
      data['inactive'] = this.inactive!.map((v) => v.toJson()).toList();
    }
    if (this.all != null) {
      data['all'] = this.all!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Active {
  String? label;
  PosPaData? data;

  Active({this.label, this.data});

  Active.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    data = json['data'] != null ? new PosPaData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

// class Data {
//   double? perc;
//   double? relPerc;
//   int? value;
//
//   Data({this.perc, this.relPerc, this.value});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     perc = json['perc'];
//     relPerc = json['rel_perc'];
//     value = json['value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['perc'] = this.perc;
//     data['rel_perc'] = this.relPerc;
//     data['value'] = this.value;
//     return data;
//   }
// }

class PosPaData {
  dynamic perc;
  dynamic relPerc;
  dynamic value;

  PosPaData({this.perc, this.relPerc, this.value});

  PosPaData.fromJson(Map<String, dynamic> json) {
    perc = json['perc'];
    relPerc = json['rel_perc'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['perc'] = this.perc;
    data['rel_perc'] = this.relPerc;
    data['value'] = this.value;
    return data;
  }
}

class All {
  String? label;
  PosPaData? data;

  All({this.label, this.data});

  All.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    data = json['data'] != null ? new PosPaData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Inactive {
  String? label;
  PosPaData? data;

  Inactive({this.label, this.data});

  Inactive.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    data = json['data'] != null ? new PosPaData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
