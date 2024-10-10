class SendOtpRequestModel {
  String? newCellnumber;

  SendOtpRequestModel({this.newCellnumber});

  SendOtpRequestModel.fromJson(Map<String, dynamic> json) {
    newCellnumber = json['newCellnumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newCellnumber'] = this.newCellnumber;
    return data;
  }
}
