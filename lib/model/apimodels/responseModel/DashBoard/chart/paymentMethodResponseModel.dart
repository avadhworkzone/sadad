class PaymentMethodResponseModel {
  Counter? counter;
  Counter? amount;
  bool? isEmpty;

  PaymentMethodResponseModel({this.counter, this.amount, this.isEmpty});

  PaymentMethodResponseModel.fromJson(Map<String, dynamic> json) {
    counter =
        json['counter'] != null ? new Counter.fromJson(json['counter']) : null;
    amount =
        json['amount'] != null ? new Counter.fromJson(json['amount']) : null;
    isEmpty = json['isEmpty'] == null ? false : json['isEmpty'];
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
  List<Success>? success;
  List<Success>? failure;
  List<Both>? both;

  Counter({this.success, this.failure, this.both});

  Counter.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      success = <Success>[];
      json['success'].forEach((v) {
        success!.add(new Success.fromJson(v));
      });
    }
    if (json['failure'] != null) {
      failure = <Success>[];
      json['failure'].forEach((v) {
        failure!.add(new Success.fromJson(v));
      });
    }
    // if (json['failure'] != null) {
    //   failure = <Null>[];
    //   json['failure'].forEach((v) {
    //     failure!.add(Null.fromJson(v));
    //   });
    // }
    if (json['both'] != null) {
      both = <Both>[];
      json['both'].forEach((v) {
        both!.add(new Both.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success!.map((v) => v.toJson()).toList();
    }
    if (this.failure != null) {
      data['failure'] = this.failure!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Success {
  String? label;
  PaData? data;

  Success({this.label, this.data});

  Success.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    data = json['data'] != null ? new PaData.fromJson(json['data']) : null;
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

class Both {
  Both({
    this.label,
    this.data,
  });

  String? label;
  PaData? data;

  factory Both.fromJson(Map<String, dynamic> json) => Both(
        label: json["label"],
        data: PaData.fromJson(json["data"]),
      );
}

class PaData {
  var perc;
  var relPerc;
  var value;

  PaData({this.perc, this.relPerc, this.value});

  PaData.fromJson(Map<String, dynamic> json) {
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
