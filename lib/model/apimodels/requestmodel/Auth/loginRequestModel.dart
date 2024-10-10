class LoginRequestModel {
  String? cellnumber;
  String? password;
  String? devicetoken;
  String? appSignature;
  LoginRequestModel(
      {this.cellnumber, this.password, this.devicetoken, this.appSignature});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    cellnumber = json['cellnumber'];
    password = json['password'];
    devicetoken = json['devicetoken'];
    appSignature = json['appSignature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cellnumber'] = this.cellnumber;
    data['password'] = this.password;
    data['devicetoken'] = this.devicetoken;
    data['appSignature'] = this.appSignature;
    return data;
  }
}
