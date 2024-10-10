class VerifyOtpRequestModel {
  int? otp;
  int? userId;
  String? devicetoken;

  VerifyOtpRequestModel({this.otp, this.userId, this.devicetoken});

  VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    userId = json['userId'];
    devicetoken = json['devicetoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['userId'] = this.userId;
    data['devicetoken'] = this.devicetoken;
    return data;
  }
}
