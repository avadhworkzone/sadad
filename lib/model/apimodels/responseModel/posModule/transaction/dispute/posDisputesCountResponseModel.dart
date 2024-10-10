class PosDisputesCountResponseModel {
  var count;

  PosDisputesCountResponseModel({this.count});

  PosDisputesCountResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
