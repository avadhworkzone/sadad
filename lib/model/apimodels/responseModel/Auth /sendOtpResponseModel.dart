class SendOtpResponseModel {
  bool? result;
  var receiveotpvia;

  SendOtpResponseModel({this.result, this.receiveotpvia});

  SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    receiveotpvia = json['receiveotpvia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['receiveotpvia'] = this.receiveotpvia;
    return data;
  }
}
